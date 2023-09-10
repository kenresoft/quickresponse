import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:quickresponse/widgets/blinking_text.dart';

import '../data/constants/colors.dart';
import '../data/emergency/emergency.dart';
import '../utils/density.dart';
import '../utils/util.dart';
import 'appbar.dart';
import 'color_mix.dart';

class HeroPage extends StatelessWidget {
  final EmergencyTip tip;

  const HeroPage({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Scaffold(
      appBar: appBar(
        leading: const Icon(CupertinoIcons.increase_quotelevel),
        title: Text(tip.shortDescription),
        actionTitle: '',
        actionIcon: null,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: AppColor.overlay,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Hero(
              tag: tip.iconData, // Use the image URL as the hero tag
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlinkingText(
                    null,
                    isNotText: true,
                    child: ColorMix(
                      gradient: AppColor.alert,
                      child: Icon(
                        tip.iconData,
                        size: 72.0,
                        color: AppColor.action, // Customize the icon color
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.6.dpW(dp),
                    child: ColorMix(
                      gradient: AppColor.radiant,
                      child: Text(
                        softWrap: true,
                        Util.formatCategory(tip.category),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  )
                ],
              ), /*Image.asset(
                tip.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),*/
            ),
            const SizedBox(height: 16),
            ColorMix(
              gradient: AppColor.textMix,
              child: Text(
                tip.longDescription,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
