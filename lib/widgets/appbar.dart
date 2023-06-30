import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

import '../data/constants/colors.dart';

AppBar appBar({
  Widget? title,
  Widget? leading,
  Widget? trailing,
  double? height,
  required String actionTitle,
  IconData? actionIcon,
}) {
  return AppBar(
    iconTheme: IconThemeData(color: AppColor.navIconSelected),
    backgroundColor: AppColor.background,
    title: title,
    leading: leading,
    toolbarHeight: height,
    titleTextStyle: title != null ? TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColor.title) : null,
    centerTitle: true,
    actions: [
      trailing ??
          Row(
            children: [
              Text(
                actionTitle,
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.navIconSelected),
                textAlign: TextAlign.center,
              ),
              2.spX,
              Icon(actionIcon, color: AppColor.navIconSelected, size: 18),
              20.spX,
            ],
          ),
    ],
  );
}
