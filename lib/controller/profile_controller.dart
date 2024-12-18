import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  
  var profiles = <Profile>[].obs;
  var isConnected = true.obs; // Status koneksi

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Connectivity connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();

    // Mulai listener untuk memantau perubahan koneksi
    connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        // Tidak ada koneksi
        isConnected.value = false;
        Get.snackbar(
          "Koneksi Terputus",
          "Anda sedang offline. Data akan disimpan secara lokal.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        // Ada koneksi
        isConnected.value = true;
        Get.snackbar(
          "Koneksi Tersambung",
          "Anda kembali online. Data akan disinkronkan.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        // Sinkronisasi data lokal ke database
        await syncLocalToOnline();
      }
    });

    // Ambil data dari lokal dan Firestore saat aplikasi dimulai
    fetchProfilesFromLocal();
    fetchProfiles();
  }

  Future<void> updateProfile(int index, String name, String gender,
      double weight, double height) async {
    String docId = profiles[index].id;

    // Update data ke Firestore
    await firestore.collection('profiles').doc(docId).update({
      'name': name,
      'gender': gender,
      'weight': weight,
      'height': height,
    });

    // Update data di list lokal
    profiles[index] = Profile(
      id: docId,
      name: name,
      gender: gender,
      weight: weight,
      height: height,
    );
  }

  // Fungsi untuk update profile ke penyimpanan lokal
  Future<void> updateProfileToLocal(int index, String name, String gender,
      double weight, double height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> localProfiles =
        prefs.getStringList('local_profiles') ?? <String>[];

    if (index < localProfiles.length) {
      // Buat profile yang sudah di-update
      Profile updatedProfile = Profile(
        id: profiles[index].id,
        name: name,
        gender: gender,
        weight: weight,
        height: height,
      );

      // Update di daftar lokal
      localProfiles[index] = jsonEncode(updatedProfile.toJson());
      await prefs.setStringList('local_profiles', localProfiles);

      // Update data di list lokal aplikasi
      profiles[index] = updatedProfile;
    }
  }

  // Tambahkan profil ke Firestore
  Future<void> addProfile(
      String name, String gender, double weight, double height) async {
    try {
      DocumentReference docRef = await firestore.collection('profiles').add({
        'name': name,
        'gender': gender,
        'weight': weight,
        'height': height,
      });
      profiles.add(Profile(
        id: docRef.id,
        name: name,
        gender: gender,
        weight: weight,
        height: height,
      ));
    } catch (e) {
      print('Error adding profile to Firestore: $e');
    }
  }

  // Tambahkan profil ke penyimpanan lokal
  Future<void> addProfileToLocal(
      String name, String gender, double weight, double height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> localProfiles =
        prefs.getStringList('local_profiles') ?? <String>[];

    Profile profile = Profile(
      id: DateTime.now().toIso8601String(),
      name: name,
      gender: gender,
      weight: weight,
      height: height,
    );

    localProfiles.add(jsonEncode(profile.toJson()));
    await prefs.setStringList('local_profiles', localProfiles);
    profiles.add(profile);
  }

  // Sinkronisasi data lokal ke Firestore
  // Sinkronisasi data lokal ke Firestore
  Future<void> syncLocalToOnline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> localProfiles =
        prefs.getStringList('local_profiles') ?? <String>[];

    if (localProfiles.isNotEmpty) {
      List<String> successfullySyncedProfiles =
          []; // Untuk melacak data yang berhasil diunggah
      for (String profileJson in localProfiles) {
        try {
          // Decode JSON ke Map
          Map<String, dynamic> data = jsonDecode(profileJson);

          // Unggah data ke Firestore
          await firestore.collection('profiles').add({
            'name': data['name'],
            'gender': data['gender'],
            'weight': data['weight'],
            'height': data['height'],
          });

          print('Data berhasil diunggah: ${data['name']}');

          // Tambahkan ke daftar data yang berhasil diunggah
          successfullySyncedProfiles.add(profileJson);
        } catch (e) {
          print('Error uploading data to Firestore: $e');
        }
      }

      // Hapus hanya data yang berhasil diunggah
      for (String syncedProfile in successfullySyncedProfiles) {
        localProfiles.remove(syncedProfile);
      }

      // Perbarui penyimpanan lokal
      await prefs.setStringList('local_profiles', localProfiles);

      // Log jika semua data lokal telah dihapus
      if (localProfiles.isEmpty) {
        print('Semua data lokal telah disinkronkan dan dihapus.');
      } else {
        print(
            'Masih ada data lokal yang belum berhasil disinkronkan. Silakan coba lagi.');
      }
    } else {
      print('Tidak ada data lokal untuk disinkronkan.');
    }
  }

  // Ambil data dari Firestore
  Future<void> fetchProfiles() async {
    try {
      // Cek koneksi internet
      var connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        // Jika terhubung ke internet, sinkronkan data lokal ke database
        await syncLocalToOnline();
      }

      // Ambil data dari Firestore
      QuerySnapshot snapshot = await firestore.collection('profiles').get();
      profiles.value = snapshot.docs.map((doc) {
        return Profile(
          id: doc.id,
          name: doc['name'],
          gender: doc['gender'],
          weight: doc['weight'],
          height: doc['height'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching profiles from Firestore: $e');
    }
  }

  // Ambil data dari penyimpanan lokal
  Future<void> fetchProfilesFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> localProfiles =
        prefs.getStringList('local_profiles') ?? <String>[];

    profiles.value = localProfiles.map((profileJson) {
      Map<String, dynamic> data = jsonDecode(profileJson);
      return Profile.fromJson(data);
    }).toList();
  }

  // Hapus profil dari Firestore
  Future<void> deleteProfile(int index) async {
    String docId = profiles[index].id;
    try {
      await firestore.collection('profiles').doc(docId).delete();
      profiles.removeAt(index);
    } catch (e) {
      print('Error deleting profile: $e');
    }
  }
}

class Profile {
  String id;
  String name;
  String gender;
  double weight;
  double height;

  Profile({
    required this.id,
    required this.name,
    required this.gender,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'weight': weight,
      'height': height,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      weight: json['weight'],
      height: json['height'],
    );
  }
}
