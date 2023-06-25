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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ],
      ),
    );
  }
}
