import 'package:bottom_nav/bottom_nav.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/widgets/suggestion_card.dart';

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
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          10.spY,

          // 1
          const Row(
            children: [
              Image(
                image: ExactAssetImage(Constants.tech),
                height: 24,
                width: 24,
              ),
              Column(
                children: [],
              )
            ],
          ),

          // 2
          const Text('Emergency help needed?', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),

          // 3
          const Text('Just hold the button to call', style: TextStyle(fontSize: 20)),

          // 4
          const AlertButton(),

          // 5
          const Text('Not sure what to do?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          // 6
          const Text('Pick the subject to chat'),

          // 7
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return const SuggestionCard(text: 'He had an accident');
            },
          ),

          10.spY,

          // 8
        ]),
      ),
      bottomNavigationBar: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return BottomNav(
            labelStyle: const TextStyle(color: Colors.deepPurple),
            height: 78,
            // Attention: limit maximum height
            padding: const EdgeInsets.all(25).copyWith(top: 5, bottom: 5),
            backgroundSelected: Colors.blue.shade900,
            divider: null,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            onTap: (index) => ref.watch(tabProvider.notifier).setTab = index,
            iconSize: 23,
            labelSize: 20,
            backgroundColor: Colors.deepPurple.withOpacity(0.5),
            color: Colors.white.withOpacity(0.5),
            colorSelected: Colors.deepPurple,
            indexSelected: ref.watch(tabProvider.select((value) => value)),
            items: const [
              BottomNavItem(label: 'Home', child: CupertinoIcons.home),
              BottomNavItem(label: 'Book', child: CupertinoIcons.book),
              BottomNavItem(label: 'Bubble', child: CupertinoIcons.bubble_left),
              BottomNavItem(label: 'Bookmark', child: CupertinoIcons.bookmark),
            ],
          );
        },
      ),
    );
  }
}
