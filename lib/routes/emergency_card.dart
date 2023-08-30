import 'package:flutter/material.dart';

import '../data/constants/colors.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.overlay,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: child,
    );
  }
}
