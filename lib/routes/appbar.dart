import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

import '../data/constants/colors.dart';

AppBar appBar({required String title, required String actionTitle, required IconData actionIcon}) {
  return AppBar(
    iconTheme: IconThemeData(color: AppColor.navIconSelected),
    backgroundColor: AppColor.background,
    title: Text(title),
    titleTextStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColor.title),
    centerTitle: true,
    actions: [
      Row(children: [
        Text(
          actionTitle,
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.navIconSelected),
          textAlign: TextAlign.center,
        ),
        2.spX,
        Icon(
          actionIcon,
          color: AppColor.navIconSelected,
          size: 18,
        ),
        20.spX
      ])
    ],
  );
}
