import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MicController extends GetxController {
  final SpeechToText _speechToText = SpeechToText();
  final RxBool isListening = false.obs; // Untuk memantau status mendengarkan
  final RxString recognizedText = ''.obs; // Teks hasil dari suara

  // Inisialisasi SpeechToText
  Future<void> initSpeech() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        debugPrint('Speech status: $status');
        if (status == 'notListening') {
          isListening.value = false;
        }
      },
      onError: (error) {
        debugPrint('Speech error: $error');
        isListening.value = false;
      },
    );
    if (available) {
      debugPrint("Speech recognition available!");
    } else {
      debugPrint("Speech recognition is NOT available.");
      Get.snackbar('Error', 'Speech recognition is not available.');
    }
  }

  Future<void> startListening() async {
    if (!_speechToText.isAvailable) {
      await initSpeech();
    }
    if (!_speechToText.isListening) {
      isListening.value = true;
      await _speechToText.listen(
        onResult: (result) {
          recognizedText.value = result.recognizedWords;
          debugPrint("Recognized words: ${result.recognizedWords}");
        },
      );
    }
  }

  // Berhenti mendengarkan suara
  void stopListening() {
    if (_speechToText.isListening) {
      _speechToText.stop();
    }
    isListening.value = false;
  }

  // Reset hasil teks
  void reset() {
    recognizedText.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    initSpeech();
  }
}
