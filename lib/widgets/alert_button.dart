import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/colors.dart';

class AlertButton extends StatefulWidget {
  const AlertButton({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  State<AlertButton> createState() => _AlertButtonState();
}

class _AlertButtonState extends State<AlertButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(widget.width, widget.height)),
          gradient: AppColor.alert,
          border: Border.all(width: 8, color: Colors.grey),
          boxShadow: [
            const BoxShadow(color: Colors.white, spreadRadius: 3),
            BoxShadow(color: Colors.white.withOpacity(0.8), offset: const Offset(0, -20), blurRadius: 5),
            BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(10, 20), blurRadius: 5),
            BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(10, 0), blurRadius: 5),
            BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(-10, 10), blurRadius: 5),
            BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(-10, 0), blurRadius: 5),
            BoxShadow(color: Colors.black.withOpacity(0.03), spreadRadius: 15),
          ]),
      width: widget.width,
      height: widget.height,
      child: const Icon(
        CupertinoIcons.waveform_path,
        size: 45,
        color: CupertinoColors.white,
      ),
    );
  }
}
