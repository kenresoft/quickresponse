import 'package:flutter/material.dart';

import '../routes/location_map.dart';

class MiniMap extends StatelessWidget {
  const MiniMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 300,
      child: LocationMap(),
    );
  }
}
