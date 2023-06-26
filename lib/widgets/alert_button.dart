import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertButton extends StatefulWidget {
  const AlertButton({super.key});

  @override
  State<AlertButton> createState() => _AlertButtonState();
}

class _AlertButtonState extends State<AlertButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.redAccent,
        border: Border.all(width: 5, color: Colors.grey), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), spreadRadius: 15)]
      ),
      width: 160,
      height: 160,
      child: const Icon(
        CupertinoIcons.waveform_path,
        size: 45,
        color: CupertinoColors.white,
      ),
    );
  }
}
