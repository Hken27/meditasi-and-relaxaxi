import 'package:Lugowo/view/screen/register_screen/login_screen.dart';
import 'package:Lugowo/view/widget/app_buttons.dart';
import 'package:Lugowo/view/widget/app_logo.dart';
import 'package:Lugowo/view/widget/app_text.dart';
import 'package:flutter/material.dart';

class ProsesSignSignUp extends StatelessWidget {
  const ProsesSignSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Image(
              image: AssetImage(
                "asset/images/backgrounds/sign_up_page.png",
              ),
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const AppLogo(),
                  const Spacer(flex: 20),
                  AppText.normalText(
                    "Harap Mendaftar Dahulu",
                    fontSize: 30,
                    isBold: true,
                  ),
                  const SizedBox(height: 15),
                  AppText.normalText(
                    "Untuk Kenyamanan Bersama ",
                    fontSize: 16,
                    color: const Color(0xffA1A4B2),
                  ),
                  const Spacer(flex: 1),
                  SizedBox(
                    width: double.maxFinite,
                    child: AppButtons.mainButton(
                      "Proses",
                      onPressed: () {
                        onProceedPressed(context);
                      },
                      buttonColor: const Color.fromARGB(255, 36, 54, 250),
                      textColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onProceedPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
