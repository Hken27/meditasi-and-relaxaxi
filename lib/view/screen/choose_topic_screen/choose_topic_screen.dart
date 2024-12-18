import 'package:Lugowo/view/screen/bottom_navigation_screen/bottom_navigation_screen.dart';
import 'package:Lugowo/view/screen/choose_topic_screen/topics_waterfall_widget.dart';
import 'package:Lugowo/view/widget/app_buttons.dart';
import 'package:Lugowo/view/widget/app_text.dart';
import 'package:flutter/material.dart';

class ChooseTopicScreen extends StatelessWidget {
  const ChooseTopicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),
                  AppButtons.mainButton(
                    "Skip",
                    buttonColor: const Color(0xff8E97FD),
                    textColor: Colors.white,
                    onPressed: () {
                      onSkipButtonPressed(context);
                    },
                  ),
                ],
              ),
              AppText.normalText(
                "What brings you",
                fontSize: 34,
                isBold: true,
              ),
              AppText.normalText(
                "to Silent moon?",
                fontSize: 28,
              ),
              AppText.normalText(
                "Choose a topic to focus on:",
                fontSize: 20,
                color: const Color(0xffA1A4B2),
              ),
              const SizedBox(height: 30),
              const TopicsWaterfallWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void onSkipButtonPressed(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BottomNavigationScreen()),
        (Route<dynamic> route) => false);
  }
}
