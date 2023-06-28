import 'package:bottom_nav/bottom_nav.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/constants/density.dart';
import 'package:quickresponse/widgets/suggestion_card.dart';

import '../main.dart';
import '../providers/providers.dart';
import '../widgets/alert_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            0.05.dpH(dp).spY,

            // 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: buildRow(),
            ),
            0.04.dpH(dp).spY,

            // 2
            0.7.dpW(dp).spaceX(Text(
              'Emergency help needed?',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColor.title),
              textAlign: TextAlign.center,
            )),
            0.01.dpH(dp).spY,

            // 3
            Text('Just hold the button to call', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: AppColor.text)),
            0.05.dpH(dp).spY,

            // 4
            const AlertButton(height: 190, width: 185),
            0.08.dpH(dp).spY,

            // 5
            Text('Not sure what to do?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.title)),

            // 6
            Text('Pick the subject to chat', style: TextStyle(fontSize: 16, color: AppColor.text)),
            0.03.dpH(dp).spY,

            // 7
            .12.dpH(dp).spaceY(ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return const SuggestionCard(text: 'He had an accident');
                })),

            0.03.dpH(dp).spY,

            // 8
          ]),
        ),
      ),
      bottomNavigationBar: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return BottomNav(
            height: 68,
            // Attention: limit maximum height
            padding: const EdgeInsets.all(25).copyWith(top: 5, bottom: 10),
            onTap: (index) {
              ref.watch(tabProvider.notifier).setTab = index;
              if (index == 0) {
                launch(context, Constants.home);
              } else if (index == 1) {
                launch(context, Constants.dashboard);
              } else if (index == 2) {
                launch(context, Constants.contact);
              }
            },
            iconSize: 23,
            labelSize: 0,
            backgroundColor: Colors.white,
            color: AppColor.navIcon,
            colorSelected: AppColor.navIconSelected,
            indexSelected: ref.watch(tabProvider.select((value) => value)),
            items: const [
              BottomNavItem(label: '', child: Icons.cabin),
              BottomNavItem(label: '', child: Icons.health_and_safety_outlined),
              BottomNavItem(label: '', child: Icons.sensor_occupied),
              BottomNavItem(label: '', child: Icons.sentiment_satisfied),
            ],
          );
        },
      ),
    );
  }

  Row buildRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        const Image(
          image: ExactAssetImage(Constants.tech),
          height: 45,
          width: 45,
        ),
        Column(children: [
          Text(
            'Hi Susan!',
            style: TextStyle(fontSize: 15, color: AppColor.text),
          ),
          Text(
            'Complete profile',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.action),
          ),
        ])
      ]),
      Row(children: [
        Column(children: [
          Text(
            'Ludwika Waryn...',
            style: TextStyle(fontSize: 15, color: AppColor.text),
          ),
          Text(
            'See your location',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.action),
          ),
        ]),
        Icon(Icons.location_on_rounded, color: AppColor.action),
      ]),
    ]);
  }
}
