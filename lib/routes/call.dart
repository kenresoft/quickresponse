import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/constants.dart';

import '../data/constants/colors.dart';
import '../data/constants/density.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColor.background),
      body: Container(
          color: AppColor.alertBorder,
          child: Center(
            child: Column(children: [
              0.2.dpH(dp).spY,
              Icon(Icons.ac_unit, color: AppColor.white, size: 40),
              Text('112', style: TextStyle(fontSize: 70, color: AppColor.white, fontWeight: FontWeight.w500)),
              Text('Calling...', style: TextStyle(fontSize: 18, color: AppColor.white)),
              0.25.dpH(dp).spY,
              Text('Who needs help?', style: TextStyle(fontSize: 25, color: AppColor.white, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 120,
                width: 310,
                child: CarouselSlider.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    log("$itemIndex : $pageViewIndex");
                    return Center(
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
                ),
              ),
            ]),
          )),
    );
  }
}
