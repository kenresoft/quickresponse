import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:quickresponse/widgets/display/blinking_text.dart';

import '../../data/constants/styles.dart';
import '../../data/emergency/emergency.dart';
import '../../providers/settings/prefs.dart';
import '../../utils/util.dart';
import '../display/color_mix.dart';
import 'appbar.dart';

class HeroPage extends ConsumerStatefulWidget {
  final EmergencyTip tip;

  const HeroPage({super.key, required this.tip});

  @override
  ConsumerState<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends ConsumerState<HeroPage> {
  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Scaffold(
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        leading: const Icon(CupertinoIcons.increase_quotelevel),
        title: Text(
          widget.tip.shortDescription,
          style: const TextStyle(fontSize: 21),
        ),
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
              color: AppColor(theme).overlay,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Hero(
              tag: widget.tip.iconData, // Use the image URL as the hero tag
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlinkingText(
                    null,
                    isNotText: true,
                    child: ColorMix(
                      gradient: AppColor(theme).alertMix,
                      child: Icon(
                        widget.tip.iconData,
                        size: 72.0,
                        color: AppColor(theme).action, // Customize the icon color
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.6.dpW(dp),
                    child: ColorMix(
                      gradient: AppColor(theme).textMix,
                      child: Text(
                        softWrap: true,
                        Util.formatCategory(widget.tip.category),
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
              gradient: AppColor(theme).iconMix,
              child: Text(
                widget.tip.longDescription,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
