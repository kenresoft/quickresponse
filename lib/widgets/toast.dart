import 'package:flutter/material.dart';

class Toast extends StatelessWidget {
  const Toast({super.key, required this.show});

  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: show ? 25 : -100,
      right: 0,
      left: 0,
      duration: const Duration(milliseconds: 300),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(50),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 20,
                offset: Offset.zero,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
          child: const Center(
            child: Text("Current location not available!", textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
