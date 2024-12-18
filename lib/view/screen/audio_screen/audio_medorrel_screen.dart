import 'package:Lugowo/controller/audio_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MeditationSoundPage extends StatefulWidget {
  const MeditationSoundPage({Key? key}) : super(key: key);

  @override
  _MeditationSoundPageState createState() => _MeditationSoundPageState();
}

class _MeditationSoundPageState extends State<MeditationSoundPage> {
  final AudioController _audioController = AudioController();

  List<Map<String, String>> sounds = [
    {
      'title': 'Ombak Laut',
      'duration': '4 min',
      'icon': 'asset/images/meditation_cards/card_1.png',
      'audio': "asset/audio/song.mp3"
    },
    {
      'title': 'Hujan Tropis',
      'duration': '5 min',
      'icon': 'asset/images/meditation_cards/card_2.png',
      'audio': 'asset/audio/songg.mp3'
    },
    {
      'title': 'Angin Sejuk',
      'duration': '3 min',
      'icon': 'asset/images/meditation_cards/card_4.png',
      'audio': 'asset/audio/songgg.mp3'
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioController.init(); // Initialize the audio controller
  }

  @override
  void dispose() {
    _audioController.dispose(); // Dispose the audio controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih suara yang menenangkan pikiran Anda',
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color ?? Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sounds.length,
                itemBuilder: (context, index) {
                  final sound = sounds[index];
                  final isPlaying = _audioController.playerState == PlayerState.playing;
                  return Card(
                    color: theme.primaryColor.withOpacity(0.1),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(sound['icon']!),
                        backgroundColor: theme.primaryColor.withOpacity(0.2),
                      ),
                      title: Text(
                        sound['title']!,
                        style: TextStyle(
                          color: theme.textTheme.titleLarge?.color ?? const Color(0xff3F414E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        sound['duration']!,
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color ?? const Color(0xffA1A4B2),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: theme.primaryColor,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            _audioController.pause();
                          } else {
                            _audioController.play('asset/audio/song.mp3');
                          }
                          setState(() {}); // Update UI
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _audioController.playerState == PlayerState.playing || _audioController.playerState == PlayerState.paused
                      ? () {
                          _audioController.stop();
                          setState(() {}); // Update UI
                        }
                      : null,
                ),
                Text(
                  '${_audioController.position.toString().split('.').first} / ${_audioController.duration.toString().split('.').first}'
                )
              ],
            ),
            Slider(
              value: (_audioController.position.inMilliseconds > 0 &&
                      _audioController.position.inMilliseconds < _audioController.duration.inMilliseconds)
                  ? _audioController.position.inMilliseconds / _audioController.duration.inMilliseconds
                  : 0.0,
              onChanged: (value) {
                final position = value * _audioController.duration.inMilliseconds;
                _audioController.seek(Duration(milliseconds: position.round()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
