import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/data/constants/density.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 0.3.dpW(dp).spaceX(
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                0.13.dpH(dp).spaceX(Text(
                      text,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.title_2),
                    )),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 15,
                    color: AppColor.action,
                  ),
                  //0.15.dpW(dp).spX,
                  Icon(
                    CupertinoIcons.group,
                    color: AppColor.navIcon,
                  ),
                ])
              ]),
            ),
      ),
    );
  }
}
