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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          0.09.dpH(dp).spaceX(
                Text(
                  text,
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.title_2),
                ),
              ),
          Expanded(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: AppColor.action,
                ),
                30.spX,
                Icon(
                  CupertinoIcons.group,
                  color: AppColor.navIcon,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
