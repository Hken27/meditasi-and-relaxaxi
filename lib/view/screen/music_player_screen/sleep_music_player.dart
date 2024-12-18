import 'package:Lugowo/view/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers

class MusicPlayerColors {
  final String background;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color iconBackgroundColor;
  final Color iconColor;

  MusicPlayerColors(this.background, this.primaryTextColor,
      this.secondaryTextColor, this.iconBackgroundColor, this.iconColor);
}

var lightMusicPlayerColors = MusicPlayerColors(
  "asset/images/backgrounds/music_background.png",
  const Color(0xff3F414E),
  const Color(0xffA0A3B1),
  const Color(0xffb6b8bf),
  Colors.white,
);

var darkMusicPlayerColors = MusicPlayerColors(
  "asset/images/backgrounds/music_background_sleep.png",
  const Color(0xffE6E7F2),
  const Color(0xff98A1BD),
  const Color(0xff2C4179),
  Colors.white,
);

class MusicPlayer extends StatefulWidget {
  final bool sleepPlayer;

  const MusicPlayer({
    Key? key,
    this.sleepPlayer = false,
  }) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isSong1 = true; // Track the current song being played

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MusicPlayerColors musicPlayerColors =
        widget.sleepPlayer ? darkMusicPlayerColors : lightMusicPlayerColors;

    return Scaffold(
      backgroundColor: const Color(0xff03174C),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              musicPlayerColors.background,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              getHeaderIcons(context, musicPlayerColors),
              const Spacer(
                flex: 5,
              ),
              AppText.normalText(
                "Night Sleep",
                fontSize: 34,
                isBold: true,
                color: musicPlayerColors.primaryTextColor,
              ),
              const SizedBox(height: 15),
              AppText.normalText(
                "Sleep Music",
                fontSize: 14,
                color: musicPlayerColors.secondaryTextColor,
              ),
              const Spacer(
                flex: 1,
              ),
              getMusicControls(musicPlayerColors),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeaderIcons(
      BuildContext context, MusicPlayerColors musicPlayerColors) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const AppIconButton(
            Icons.close,
          ),
        ),
        const Spacer(),
        AppIconButton(
          Icons.favorite,
          backgroundColor: musicPlayerColors.iconBackgroundColor,
          iconColor: musicPlayerColors.iconColor,
        ),
        const SizedBox(width: 15),
        AppIconButton(
          Icons.download,
          backgroundColor: musicPlayerColors.iconBackgroundColor,
          iconColor: musicPlayerColors.iconColor,
        ),
      ],
    );
  }

  Widget getMusicControls(MusicPlayerColors musicPlayerColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ForwardWidget(
          color: musicPlayerColors.primaryTextColor,
        ),
        const SizedBox(width: 50),
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            size: 80,
            color: musicPlayerColors.primaryTextColor,
          ),
          onPressed: _togglePlayPause,
        ),
        const SizedBox(width: 50),
        BackWidget(
          color: musicPlayerColors.primaryTextColor,
        ),
      ],
    );
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(
          _isSong1 ? 'assets/audio/song1.mp3' : 'assets/audio/song2.mp3'));
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleSong() {
    setState(() {
      _isSong1 = !_isSong1;
    });

    // Stop the current song and play the new one
    _audioPlayer.stop();
    _audioPlayer.play(AssetSource(
        _isSong1 ? 'assets/audio/song1.mp3' : 'assets/audio/song2.mp3'));
  }
}

class AppIconButton extends StatelessWidget {
  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const AppIconButton(
    this.iconData, {
    Key? key,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Icon(
        iconData,
        size: size,
        color: iconColor,
      ),
    );
  }
}

class ChangePlayBackIcon extends StatelessWidget {
  final Color color;
  const ChangePlayBackIcon({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.refresh,
      size: 60,
      color: color,
    );
  }
}

class ForwardWidget extends StatelessWidget {
  final Color color;
  const ForwardWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: ChangePlayBackIcon(
            color: color,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: AppText.normalText(
              "15",
              fontSize: 10,
              color: color,
            ),
          ),
        )
      ],
    );
  }
}

class BackWidget extends StatelessWidget {
  final Color color;
  const BackWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ChangePlayBackIcon(
          color: color,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: AppText.normalText(
              "15",
              fontSize: 10,
              color: const Color(0xff98A1BD),
            ),
          ),
        )
      ],
    );
  }
}
