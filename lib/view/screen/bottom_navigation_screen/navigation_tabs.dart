import 'package:Lugowo/view/screen/audio_screen/audio_medorrel_screen.dart';
import 'package:Lugowo/view/screen/image_picker/image_picker_screen.dart';
import 'package:Lugowo/view/screen/meditation_screen/meditatation_screen.dart';
import 'package:Lugowo/view/screen/sleep_screens/sleep_home_screen.dart';
import 'package:flutter/material.dart';
import '../home_screen/home_screen.dart';

class NavigationTabData {
  final IconData iconData;
  final String label;
  final Widget page;

  NavigationTabData(this.iconData, this.label, this.page);
}

var navigationTabsData = [
  NavigationTabData(Icons.home, "HOME", const HomeScreen()),
  NavigationTabData(Icons.bed, "SLEEP", const SleepHomeScreen()),
  NavigationTabData(Icons.chair, "MEDITATE", const MeditateScreen()),
  NavigationTabData(
      Icons.music_note, "MUSIC", const MeditationSoundPage()),
      // Icons.music_note, "MUSIC", AlbumListScreen()),
  // NavigationTabData(Icons.person, "PROFILE", const Center(child: Icon(Icons.person))),
  NavigationTabData(Icons.person, "PROFILE", ImagePickerPage()),
];
