import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/widgets/alert_button.dart';

import '../data/constants/colors.dart';
import '../data/constants/density.dart';
import '../widgets/suggestion_card.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  CarouselController buttonCarouselController = CarouselController();
  bool isContactTap = false;

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return WillPopScope(
      onWillPop: () {
        log('message');
        setState(() {
          isContactTap = false;
        });
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: AppColor.text,
        appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColor.text),
        body: Container(
          color: AppColor.text,
          child: Center(
            child: Column(children: [
              0.12.dpH(dp).spY,
              Icon(Icons.ac_unit, color: AppColor.white, size: 40),
              Text('112', style: TextStyle(fontSize: 70, color: AppColor.white, fontWeight: FontWeight.w500)),
              Text('Calling...', style: TextStyle(fontSize: 18, color: AppColor.white)),
              0.23.dpH(dp).spY,
              Text('Who needs help?', style: TextStyle(fontSize: 25, color: AppColor.white, fontWeight: FontWeight.w600)),
              0.03.dpH(dp).spY,
              SizedBox(
                height: 120,
                width: 310,
                child: isContactTap ? buildSuggestionAlertMessage(dp) : buildContactsCarousel(),
              ),
              0.07.dpH(dp).spY,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  buildIconButton(Icons.camera_alt, 22),
                  const AlertButton(
                    height: 70,
                    width: 70,
                    borderWidth: 2,
                    shadowWidth: 10,
                    iconSize: 25,
                    showSecondShadow: false,
                    iconData: Icons.call_end,
                  ),
                  buildIconButton(Icons.volume_down_alt, 27),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  ListView buildSuggestionAlertMessage(Density dp) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return const SuggestionCard(text: 'He had an accident', verticalMargin: 15, horizontalMargin: 5);
      },
    );
  }

  IconButton buildIconButton(IconData iconData, double size) {
    return IconButton.filled(
      onPressed: () {},
      icon: Icon(iconData, size: size),
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(AppColor.title),
        fixedSize: const MaterialStatePropertyAll(Size.square(58)),
      ),
    );
  }

  CarouselSlider buildContactsCarousel() {
    return CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        log("$itemIndex : $pageViewIndex");
        return GestureDetector(
          onTap: () {
            setState(() {
              isContactTap = true;
            });
          },
          child: Center(
            child: Column(children: [
              Stack(
                children: [
                  AnimatedPositioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    duration: const Duration(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(Constants.profile),
                    ),
                  ),
                ],
              ),
              Text('$itemIndex', style: TextStyle(fontSize: 18, color: AppColor.white)),
            ]),
          ),
        );
      },
      carouselController: buttonCarouselController,
      options: CarouselOptions(
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        viewportFraction: 0.35,
        aspectRatio: 1.0,
        enlargeFactor: 0.5,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
      ),
    );
  }
}
