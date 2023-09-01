import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  const BlinkingText(
    this.data, {
    super.key,
    this.style,
    this.blink = true,
    this.delay = false,
  });

  final String data;
  final TextStyle? style;
  final bool blink;
  final bool delay;

  @override
  State<BlinkingText> createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    if (widget.delay && mounted) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: widget.blink ? _controller.value : 1,
            child: Text(
              widget.data,
              style: widget.style,
            ),
          );
        },
      ),
    );
  }
}
