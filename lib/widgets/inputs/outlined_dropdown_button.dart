import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/styles.dart';

import '../../providers/settings/prefs.dart';

class OutlinedDropdownButton extends StatelessWidget {
  final Text label;
  final IconData icon;
  final Function() onPressed;

  const OutlinedDropdownButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: label,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(
          color: AppColor(theme).black,
        ),
      ),
    );
  }
}
