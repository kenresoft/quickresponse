import 'package:flutter/material.dart';

import '../../data/constants/styles.dart';

class OutlinedFab extends StatelessWidget {
  final bool theme;
  final bool isExpanded;
  final Widget child;
  final VoidCallback onPressed;

  const OutlinedFab(
    this.theme, {
    Key? key,
    required this.isExpanded,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColor(theme).fab),
        minimumSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
        side: MaterialStateProperty.all<BorderSide>(
          const BorderSide(color: Colors.redAccent, width: 2),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
      child: child,
    );
  }
}
