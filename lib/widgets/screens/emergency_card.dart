import 'package:flutter/material.dart';

import '../../data/constants/styles.dart';
import '../../providers/settings/prefs.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor(theme).overlay,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: child,
    );
  }
}
