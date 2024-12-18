import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedVideoPath = ''.obs;

  Future<void> recordVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      selectedVideoPath.value = video.path;
    }
  }

  VideoPlayerController? videoPlayerController;

// Fungsi untuk inisialisasi video
  void initializeVideo(String path) {
    videoPlayerController
        ?.dispose(); // Pastikan controller sebelumnya dihentikan
    videoPlayerController = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        videoPlayerController?.play();
        videoPlayerController?.setLooping(true);
      });
  }
}
