import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/constants.dart';

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
          30.spaceY(),

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
          const Text('Emergency help...'),

          // 3
          const Text('Just hold the button to call'),

          // 4
          const AlertButton(),

          // 5
          const Text(''),

          // 6
          const Text(''),

          // 7
          /*ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return const SuggestionCard();
            },
          ),*/

          // 8
        ]),
      ),
      bottomNavigationBar: BottomNav(
      labelStyle: const TextStyle(fontStyle: FontStyle.italic),
      height: 82,
      padding: const EdgeInsets.all(25).copyWith(top: 5, bottom: 5),
      backgroundSelected: Colors.blue.shade900,
      divider: const Divider(height: 0),
      borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      onTap: (index) => buildNavSwitch(index, context, widget.ref),
      iconSize: 23,
      labelSize: 20,
      backgroundColor: Colors.white.withOpacity(0.2),
      color: Colors.white.withOpacity(0.5),
      colorSelected: Colors.white,
      indexSelected: widget.ref.watch(tabProvider.select((value) => value)),
      items: const [
        BottomNavItem(label: 'Home', child: CupertinoIcons.home),
        BottomNavItem(label: 'Book', child: CupertinoIcons.book),
        BottomNavItem(label: 'Bubble', child: CupertinoIcons.bubble_left),
        BottomNavItem(label: 'Bookmark', child: CupertinoIcons.bookmark),
      ],
    ),
    );
  }
}
