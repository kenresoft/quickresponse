import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/colors.dart';

class AlertButton extends StatefulWidget {
  const AlertButton({
    super.key,
    required this.height,
    required this.width,
    required this.borderWidth,
    required this.shadowWidth,
    required this.iconSize,
    this.showSecondShadow = true,
    this.iconData,
    required this.onPressed,
    this.delay,
  });

  final double height;
  final double width;
  final double borderWidth;
  final double shadowWidth;
  final double iconSize;
  final bool showSecondShadow;
  final IconData? iconData;
  final Function() onPressed;
  final Duration? delay;

  @override
  State<AlertButton> createState() => _AlertButtonState();
}

class _AlertButtonState extends State<AlertButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(widget.width, widget.height)),
            gradient: AppColor.alert,
            border: Border.all(width: widget.borderWidth, color: Colors.grey),
            boxShadow: [
              const BoxShadow(color: Colors.white, spreadRadius: 3),
              widget.showSecondShadow ? BoxShadow(color: Colors.white.withOpacity(0.8), offset: const Offset(0, -20), blurRadius: 5) : const BoxShadow(),
              widget.showSecondShadow ? BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(10, 20), blurRadius: 5) : const BoxShadow(),
              BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(10, 0), blurRadius: 5),
              widget.showSecondShadow ? BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(-10, 10), blurRadius: 5) : const BoxShadow(),
              BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(-10, 0), blurRadius: 5),
              BoxShadow(color: Colors.black.withOpacity(0.03), spreadRadius: widget.shadowWidth),
            ]),
        width: widget.width,
        height: widget.height,
        child: Icon(
          widget.iconData ?? CupertinoIcons.waveform_path,
          size: widget.iconSize,
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}
