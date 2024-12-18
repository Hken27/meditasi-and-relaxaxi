import 'dart:io';
import 'package:Lugowo/controller/image_pic_controller.dart';
import 'package:Lugowo/controller/microphone_controller.dart';
import 'package:Lugowo/controller/profile_controller.dart';
import 'package:Lugowo/controller/video_pic_controller.dart';
import 'package:Lugowo/view/screen/map_screen/map_screen.dart';
import 'package:Lugowo/view/screen/register_screen/login_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ImagePickerPage extends StatelessWidget {
  final ImagePickerController controller = Get.put(ImagePickerController());
  final ProfileController profileController = Get.put(ProfileController());
  final VideoPickerController videoController =
      Get.put(VideoPickerController());
  final MicController micController = Get.put(MicController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  int? editingIndex;

  // Video player controller
  VideoPlayerController? videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false, // Menghapus semua rute sebelumnya
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture Section

            // kode eksekusi driven tugas 1-3
            Column(
              children: [
                Obx(() {
                  // Menampilkan gambar atau video sesuai dengan path yang tersedia
                  if (controller.selectedImagePath.value != '') {
                    // Menampilkan gambar jika path gambar tersedia
                    return CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          FileImage(File(controller.selectedImagePath.value)),
                    );
                  } else {
                    // Menampilkan gambar default jika tidak ada path gambar atau video
                    return const CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          AssetImage("asset/images/image_picker/profile.png"),
                    );
                  }
                }),
                const SizedBox(height: 16),
                // Obx(() {
                //   if (videoController.selectedVideoPath.value != '') {
                //     // Inisialisasi video controller
                //     if (videoPlayerController == null ||
                //         videoPlayerController?.dataSource !=
                //             videoController.selectedVideoPath.value) {
                //       videoPlayerController?.dispose();
                //       videoPlayerController = VideoPlayerController.file(
                //         File(videoController.selectedVideoPath.value),
                //       )..initialize().then((_) {
                //           videoPlayerController?.play();
                //           videoPlayerController?.setLooping(true);
                //         });
                //     }

                //     // Tampilkan video jika sudah terinisialisasi
                //     return FutureBuilder(
                //       future: videoPlayerController?.initialize(),
                //       builder: (context, snapshot) {
                //         if (snapshot.connectionState == ConnectionState.done) {
                //           return SizedBox(
                //             height: 200,
                //             child: VideoPlayer(videoPlayerController!),
                //           );
                //         } else {
                //           return const CircularProgressIndicator(); // Loading Indicator
                //         }
                //       },
                //     );
                //   } else {
                //     return const CircleAvatar(
                //       radius: 80,
                //       backgroundImage:
                //           AssetImage("asset/images/image_picker/profile.png"),
                //     );
                //   }
                // }),
                const SizedBox(height: 16),
                // Tampilkan hasil transkripsi suara
                Obx(() => Text(
                      micController.recognizedText.value.isEmpty
                          ? 'Press the mic button and start speaking.'
                          : micController.recognizedText.value,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(height: 16),

                // kode untuk button driven tugas 1-3

                Wrap(
                  spacing: 10, // Jarak horizontal antar elemen
                  runSpacing:
                      10, // Jarak vertikal antar elemen (jika pindah baris)
                  alignment:
                      WrapAlignment.center, // Menyejajarkan elemen di tengah
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.pickImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text('Camera'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_album),
                      label: const Text('Album'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        videoController.recordVideo();
                      },
                      icon: const Icon(Icons.videocam),
                      label: const Text('Record'),
                    ),
                    ElevatedButton.icon(
                      onPressed: micController.isListening.value
                          ? micController.stopListening
                          : micController.startListening,
                      icon: Icon(
                        micController.isListening.value
                            ? Icons.stop
                            : Icons.mic,
                      ),
                      label: Text(
                        micController.isListening.value
                            ? 'Stop Listening'
                            : 'Start Listening',
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: micController.reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ],
                )
              ],
            ),

            const Divider(height: 40),
            // Form Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add or Edit Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: genderController,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kelamin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Berat (kg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    labelText: 'Tinggi (cm)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        genderController.text.isEmpty ||
                        weightController.text.isEmpty ||
                        heightController.text.isEmpty) {
                      Get.snackbar("Error", "Semua field harus diisi");
                      return;
                    }

                    var connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult == ConnectivityResult.none) {
                      // Simpan ke lokal jika tidak ada koneksi
                      if (editingIndex == null) {
                        await profileController.addProfileToLocal(
                          nameController.text,
                          genderController.text,
                          double.tryParse(weightController.text) ?? 0,
                          double.tryParse(heightController.text) ?? 0,
                        );
                      } else {
                        await profileController.updateProfileToLocal(
                          editingIndex!,
                          nameController.text,
                          genderController.text,
                          double.tryParse(weightController.text) ?? 0,
                          double.tryParse(heightController.text) ?? 0,
                        );
                        editingIndex = null;
                      }
                    } else {
                      // Simpan ke Firestore jika ada koneksi
                      if (editingIndex == null) {
                        await profileController.addProfile(
                          nameController.text,
                          genderController.text,
                          double.tryParse(weightController.text) ?? 0,
                          double.tryParse(heightController.text) ?? 0,
                        );
                      } else {
                        await profileController.updateProfile(
                          editingIndex!,
                          nameController.text,
                          genderController.text,
                          double.tryParse(weightController.text) ?? 0,
                          double.tryParse(heightController.text) ?? 0,
                        );
                        editingIndex = null;
                      }
                      await profileController.syncLocalToOnline();
                    }
                    clearInputs();
                  },
                  child: Text(
                      editingIndex == null ? 'Tambah Profil' : 'Update Profil'),
                ),
              ],
            ),

            const Divider(height: 40),
            // Profile List Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Profile List",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profileController.profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profileController.profiles[index];
                      return Card(
                        child: ListTile(
                          title: Text(profile.name),
                          subtitle: Text(
                              '${profile.gender}, ${profile.weight} kg, ${profile.height} cm'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  nameController.text = profile.name;
                                  genderController.text = profile.gender;
                                  weightController.text =
                                      profile.weight.toString();
                                  heightController.text =
                                      profile.height.toString();
                                  editingIndex = index;
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  profileController.deleteProfile(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
            const Divider(height: 40),

            // google maps
            ElevatedButton.icon(
              onPressed: () {
                // Navigasi ke MapScreen
                Get.to(() => const MapScreen());
              },
              icon: const Icon(Icons.map),
              label: const Text('Open Google Maps'),
            ),
            const Divider(height: 40),
            // akhir google maps icon
          ],
        ),
      ),
    );
  }

  void clearInputs() {
    nameController.clear();
    genderController.clear();
    weightController.clear();
    heightController.clear();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    // super.onClose();
  }
}
