import 'dart:io';  // Untuk mengakses file sistem
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagePickerController extends GetxController {
  var selectedImagePath = ''.obs; // Untuk menyimpan path gambar
  FirebaseFirestore firestore = FirebaseFirestore.instance; // Inisialisasi Firestore
  final Connectivity _connectivity = Connectivity(); // Untuk cek koneksi internet

  // Fungsi untuk memilih gambar
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImagePath.value = image.path; // Simpan path gambar
      final connectivityResult = await _connectivity.checkConnectivity();

      // Cek koneksi internet
      if (connectivityResult != ConnectivityResult.none) {
        // Jika ada koneksi, simpan langsung ke Firestore
        await saveImagePathToFirestore(image.path);
      } else {
        // Jika tidak ada koneksi, simpan ke SharedPreferences
        await saveImagePathToLocal(image.path);
        Get.snackbar(
          'Offline',
          'Image path saved locally. It will be uploaded when online.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'No image selected',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk menyimpan path gambar ke Firestore
  Future<void> saveImagePathToFirestore(String imagePath) async {
    try {
      await firestore.collection('profiles').add({
        'image_path': imagePath, // Menyimpan path lokal gambar
        'uploaded_at': FieldValue.serverTimestamp(), // Menyimpan waktu unggah
      });

      Get.snackbar(
        'Success',
        'Image path saved to Firestore successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Setelah berhasil upload ke Firestore, tampilkan dialog pilihan
      bool? shouldDelete = await Get.dialog(
        AlertDialog(
          title: const Text('Upload Success'),
          content: Text('Do you want to delete or keep the image locally?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: true), // Pilih untuk menghapus gambar lokal
              child: const Text('Delete Locally'),
            ),
            TextButton(
              onPressed: () => Get.back(result: false), // Pilih untuk menyimpan gambar lokal
              child: const Text('Keep Locally'),
            ),
          ],
        ),
      );

      if (shouldDelete == true) {
        // Hapus gambar dari SharedPreferences dan file jika dipilih untuk menghapus
        await deleteImagePathLocally(imagePath);
        await deleteImageFile(imagePath);
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save image path: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk menyimpan path gambar ke SharedPreferences jika offline
  Future<void> saveImagePathToLocal(String imagePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedPaths = prefs.getStringList('offline_images') ?? [];
      savedPaths.add(imagePath);
      await prefs.setStringList('offline_images', savedPaths);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save image path locally: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk menghapus path gambar dari SharedPreferences
  Future<void> deleteImagePathLocally(String imagePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedPaths = prefs.getStringList('offline_images') ?? [];

      if (savedPaths.contains(imagePath)) {
        savedPaths.remove(imagePath); // Menghapus path gambar dari daftar
        await prefs.setStringList('offline_images', savedPaths);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete image path locally: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk menghapus file gambar secara fisik
  Future<void> deleteImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete(); // Menghapus file gambar dari penyimpanan lokal
        Get.snackbar(
          'Success',
          'Image deleted from local storage.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Image file does not exist.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete image file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk mengunggah data dari SharedPreferences ke Firestore jika online
  Future<void> uploadOfflineImages() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String>? savedPaths = prefs.getStringList('offline_images');

        if (savedPaths != null && savedPaths.isNotEmpty) {
          for (String imagePath in savedPaths) {
            // Tampilkan dialog untuk konfirmasi
            bool? shouldSave = await Get.dialog(
              AlertDialog(
                title: const Text('Upload or Delete?'),
                content: Text('Do you want to upload or delete this image: $imagePath?'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false), // Pilih hapus
                    child: const Text('Delete'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true), // Pilih simpan
                    child: const Text('Upload'),
                  ),
                ],
              ),
            );

            if (shouldSave == true) {
              // Simpan ke Firestore
              await saveImagePathToFirestore(imagePath);
            } else {
              // Hapus gambar dari lokal jika tidak ingin di-upload
              await deleteImagePathLocally(imagePath);
              await deleteImageFile(imagePath);
            }
          }
          // Hapus semua data dari SharedPreferences setelah selesai
          await prefs.remove('offline_images');
          Get.snackbar(
            'Success',
            'Offline images processed successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to process offline images: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
