import 'package:Lugowo/view/widget/app_images.dart';
import 'package:Lugowo/view/widget/app_text.dart';
import 'package:Lugowo/view/widget/favorites_widget.dart';
import 'package:Lugowo/view/widget/listening_widget.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'episode_widget.dart';
import 'voices_tab_widget.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({Key? key}) : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  // Function to play the audio based on the episode
  void _playSound(String episode) async {
    String audioUrl = '';

    switch (episode) {
      case 'Focus Attention':
        audioUrl = 'asset/audio/song1.mp3'; // Corrected path
        break;
      case 'Body Scan':
        audioUrl = 'asset/audio/song2.mp3'; // Corrected path
        break;
      case 'Making Happiness':
        audioUrl = 'asset/audio/song1.mp3'; // Corrected path
        break;
      default:
        audioUrl = '';
        break;
    }

    if (audioUrl.isNotEmpty) {
      // Stop the current audio before starting a new one
      await _audioPlayer.stop();
      await _audioPlayer
          .play(AssetSource(audioUrl)); // Play the selected episode's sound
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up the player when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                AppImages.roundedContainerWithImage(
                  "asset/images/backgrounds/course_background.png",
                  height: 250,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 50,
                          horizontal: 20,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        )),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.normalText(
                    "Happy Morning",
                    fontSize: 34,
                    isBold: true,
                  ),
                  AppText.normalText("Course",
                      fontSize: 14,
                      isBold: true,
                      color: const Color(0xffA1A4B2)),
                  const SizedBox(
                    height: 20,
                  ),
                  AppText.normalText(
                    "Ease the mind into a "
                    "restful night's sleep with these deep tones",
                    fontSize: 16,
                    color: const Color(0xffA1A4B2),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      FavoritesWidget(
                        iconColor: Color(0xffFF84A2),
                        textColor: Color(0xffA1A4B2),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      ListeningWidget(
                        iconColor: Color(0xff67C8C1),
                        textColor: Color(0xffA1A4B2),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  AppText.normalText(
                    "Pick A Narrator",
                    fontSize: 20,
                    isBold: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 500,
                    child: VoicesTab(
                      tabOne: Column(
                        children: [
                          EpisodeWidget(
                            title: "Focus Attention",
                            duration: "10 MIN",
                            isSelected: true,
                            onTap: () {
                              // Play sound when tapped
                              _playSound('Focus Attention');
                            },
                          ),
                          const Divider(
                            height: 1,
                          ),
                          EpisodeWidget(
                            title: "Body Scan",
                            duration: "5 MIN",
                            onTap: () {
                              // Play sound when tapped
                              _playSound('Body Scan');
                            },
                          ),
                          const Divider(
                            height: 1,
                          ),
                          EpisodeWidget(
                            title: "Making Happiness",
                            duration: "3 MIN",
                            onTap: () {
                              // Play sound when tapped
                              _playSound('Making Happiness');
                            },
                          ),
                        ],
                      ),
                      tabTwo: Column(
                        children: [
                          EpisodeWidget(
                            title: "Focus Attention",
                            duration: "10 MIN",
                            isSelected: true,
                            onTap: () {
                              // Play sound when tapped
                              _playSound('Focus Attention');
                            },
                          ),
                          const Divider(
                            height: 1,
                          ),
                          EpisodeWidget(
                            title: "Body Scan",
                            duration: "5 MIN",
                            onTap: () {
                              // Play sound when tapped
                              _playSound('Body Scan');
                            },
                          ),
                          const Divider(
                            height: 1,
                          ),
                          EpisodeWidget(
                            title: "Making Happiness",
                            duration: "3 MIN",
                            onTap: () {
                              // Play sound when tapped
                              _playSound('Making Happiness');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
