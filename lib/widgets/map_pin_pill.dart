import 'package:flutter/material.dart';

import '../data/model/pin_pill_info.dart';

class MapPinPillComponent extends StatefulWidget {
  final double pinPillPosition;
  final PinInformation currentlySelectedPin;

  const MapPinPillComponent({
    super.key,
    required this.pinPillPosition,
    required this.currentlySelectedPin,
  });

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: widget.pinPillPosition + 40,
      right: 0,
      left: 0,
      duration: const Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.all(20),
          height: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(left: 10),
                child: ClipOval(child: Image.asset(widget.currentlySelectedPin.avatarPath, fit: BoxFit.cover)),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.currentlySelectedPin.locationName, style: TextStyle(color: widget.currentlySelectedPin.labelColor)),
                      Text('Latitude: ${widget.currentlySelectedPin.location.latitude.toString()}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Longitude: ${widget.currentlySelectedPin.location.longitude.toString()}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(widget.currentlySelectedPin.pinPath, width: 50, height: 50),
              )
            ],
          ),
        ),
      ),
    );
  }
}
