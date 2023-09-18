import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/utils/util.dart';

import '../data/constants/colors.dart';
import '../data/emergency/emergency.dart';
import 'color_mix.dart';
import 'hero_page.dart';

class TipSlider extends StatelessWidget {
  final List<EmergencyTip> tips;

  const TipSlider({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: tips.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        EmergencyTip tip = tips[index];
        return GestureDetector(
          onTap: () {
            // Implement navigation to a hero page showing the long description
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HeroPage(tip: tip),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ColorMix(
                  gradient: AppColor.alertMix,
                  child: Icon(
                    tips[index].iconData,
                    size: 56.0,
                    color: AppColor.action, // Customize the icon color
                  ),
                ),
                const SizedBox(height: 16.0),
                ColorMix(
                  gradient: AppColor.textMix,
                  child: Text(
                    Util.formatCategory(tips[index].category),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColor.action,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  tips[index].shortDescription,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        aspectRatio: 16 / 9,
      ),
    );
  }
}
