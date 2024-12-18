// lib/controller/audio_controller.dart

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class AudioController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateChangeSubscription;
  StreamSubscription? _playerCompleteSubscription;

  // Getters
  PlayerState get playerState => _playerState;
  Duration get duration => _duration;
  Duration get position => _position;
  AudioPlayer get audioPlayer => _audioPlayer;

  // Initialization
  void init() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  // Clean up
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
  }

  // Audio control methods
  Future<void> play(String path) async {
    await _audioPlayer.play(AssetSource(path));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _position = Duration.zero;
    _playerState = PlayerState.stopped;
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }
}
