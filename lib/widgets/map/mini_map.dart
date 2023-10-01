import 'package:flutter/material.dart';
import 'package:quickresponse/data/model/contact.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/widgets/inputs/alert_button.dart';

import '../../data/constants/constants.dart';
import '../../routes/map/location_map.dart';

class MiniMap extends StatelessWidget {
  const MiniMap({
    super.key,
    required this.contact,
    required this.showButton,
  });

  final ContactModel contact;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          const SizedBox(
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: LocationMap(disableWidgets: true),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              height: showButton ? 54 : 0,
              child: AlertButton(
                height: 54,
                width: 54,
                borderWidth: 3,
                shadowWidth: 7,
                iconSize: 24,
                showSecondShadow: false,
                onPressed: () => launch(context, Constants.camera, contact),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
