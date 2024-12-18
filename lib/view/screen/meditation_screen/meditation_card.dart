import 'package:Lugowo/view/widget/app_text.dart';
import 'package:flutter/material.dart';

class MeditationCard extends StatelessWidget {
  final String image;
  final String text;

  const MeditationCard({Key? key, required this.text, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          bottom: 0.0,
          left: 0.0,
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Row(
                  children: [
                    AppText.normalText(
                      text,
                      isBold: true,
                      color: Colors.white,
                      fontSize: 16,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
