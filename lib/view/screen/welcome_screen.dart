import 'package:Lugowo/view/screen/choose_topic_screen/choose_topic_screen.dart';
import 'package:Lugowo/view/themes/theme.dart';
import 'package:Lugowo/view/widget/app_buttons.dart';
import 'package:Lugowo/view/widget/app_logo.dart';
import 'package:Lugowo/view/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).theme.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    "asset/images/backgrounds/welcome_screen_background_objects.svg",
                    semanticsLabel: 'A red up arrow',
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const AppLogoLight(),
                  const Spacer(),
                  AppText.normalText(
                    "Hi, Welcome",
                    fontSize: 30,
                    isBold: true,
                    color: const Color(0xffFFECCC),
                  ),
                  AppText.normalText(
                    "to Silent Moon",
                    fontSize: 30,
                    color: const Color(0xffFFECCC),
                  ),
                  const SizedBox(height: 15),
                  AppText.normalText(
                    "Explore the app, find some peace of mind to prepare for meditation",
                    fontSize: 16,
                    color: const Color(0xffEBEAEC),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: SvgPicture.asset(
                      "asset/images/backgrounds/welcome_screen_background_woman.svg",
                      semanticsLabel: 'A red up arrow',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.maxFinite,
                    child: AppButtons.mainButton(
                      "Get Started",
                      onPressed: () {
                        onGettingStartedPressed(context);
                      },
                      fontSize: 14,
                      buttonColor: const Color(0xffEBEAEC),
                      textColor: const Color(0xff3F414E),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onGettingStartedPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChooseTopicScreen()),
    );
  }
}
