import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontresoft/fontresoft.dart';

import '../../data/constants/styles.dart';
import '../../providers/settings/prefs.dart';

class CustomAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final Widget? trailing;
  final double? height;
  final String actionTitle;
  final dynamic actionIcon;
  final Widget? action2;
  final VoidCallback? onActionClick;
  final Color? leadingColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.height,
    required this.actionTitle,
    this.actionIcon,
    this.action2,
    this.onActionClick,
    this.leadingColor,
  });

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: widget.leadingColor ?? (widget.actionIcon is IconData ? AppColor(theme).navIconSelected : Colors.white)),
      title: widget.title,
      leading: widget.leading,
      toolbarHeight: widget.height,
      titleTextStyle: widget.title != null ? TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColor(theme).black, package: FontResoft.package, fontFamily: FontResoft.sourceSansPro) : null,
      centerTitle: true,
      actions: [
        widget.action2 ?? const SizedBox(),
        GestureDetector(
          onTap: widget.onActionClick,
          child: widget.trailing ??
              Row(
                children: [
                  Text(
                    widget.actionTitle,
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColor(theme).navIconSelected, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 2),
                  widget.actionIcon is IconData ? Icon(widget.actionIcon, color: AppColor(theme).navIconSelected, size: 20) : (widget.actionIcon ?? const SizedBox()),
                  const SizedBox(width: 20),
                ],
              ),
        ),
      ],
    );
  }
}

/*
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

import '../data/constants/styles.dart';

AppBar appBar({
  Widget? title,
  Widget? leading,
  Widget? trailing,
  double? height,
  required String actionTitle,
  dynamic actionIcon,
  Widget? action2,
  VoidCallback? onActionClick,
}) {
  return AppBar(
    iconTheme: IconThemeData(color: actionIcon is IconData ? AppColor(theme).navIconSelected : Colors.white),
    title: title,
    leading: leading,
    toolbarHeight: height,
    titleTextStyle: title != null ? TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColor(theme).black) : null,
    centerTitle: true,
    actions: [
      action2 ?? const SizedBox(),
      GestureDetector(
        onTap: onActionClick,
        child: trailing ??
            Row(
              children: [
                Text(
                  actionTitle,
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColor(theme).navIconSelected, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                2.spX,
                actionIcon is IconData ? Icon(actionIcon, color: AppColor(theme).navIconSelected, size: 20) : (actionIcon ?? const SizedBox()),
                20.spX,
              ],
            ),
      ),
    ],
  );
}
*/
