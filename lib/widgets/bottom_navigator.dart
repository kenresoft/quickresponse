import 'package:bottom_nav/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/providers/page_provider.dart';

import '../data/constants/colors.dart';
import '../data/constants/constants.dart';
import '../main.dart';
import '../providers/providers.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        var page = ref.watch(pageProvider.select((value) => value));
        return BottomNav(
          height: 68,
          // Attention: limit maximum height
          padding: const EdgeInsets.all(25).copyWith(top: 5, bottom: 10),
          onTap: (index) {
            ref.watch(tabProvider.notifier).setTab = index;
            if (index == 0) {
              replace(context, Constants.home);
              ref.watch(pageProvider.notifier).setPage = page..add(Constants.home);
            } else if (index == 1) {
              replace(context, Constants.contactDetails);
            } else if (index == 2) {
              replace(context, Constants.contacts);
            } else if (index == 3) {
              replace(context, Constants.mapScreen);
            }
          },
          iconSize: 23,
          labelSize: 0,
          backgroundColor: AppColor.white,
          color: AppColor.navIcon,
          colorSelected: AppColor.navIconSelected,
          indexSelected: currentIndex /*ref.watch(tabProvider.select((value) => value))*/,
          items: const [
            BottomNavItem(label: '', child: Icons.cabin),
            BottomNavItem(label: '', child: Icons.health_and_safety_outlined),
            BottomNavItem(label: '', child: Icons.sensor_occupied),
            BottomNavItem(label: '', child: Icons.sentiment_satisfied),
          ],
        );
      },
    );
  }
}
