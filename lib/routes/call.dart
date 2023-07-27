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
              0.15.dpH(dp).spY,
              Icon(Icons.ac_unit, color: AppColor.white, size: 40),
              Text('112', style: TextStyle(fontSize: 70, color: AppColor.white, fontWeight: FontWeight.w500)),
              Text('Calling...', style: TextStyle(fontSize: 18, color: AppColor.white)),
              0.15.dpH(dp).spY,
              Text('Who needs help?', style: TextStyle(fontSize: 25, color: AppColor.white, fontWeight: FontWeight.w600)),
              Expanded(
                child: SizedBox(
                  width: 0.9.dpW(dp),
                  child: CarouselSlider.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                      log("$itemIndex : $pageViewIndex");
                      return Center(
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              right: 0,
                              bottom: 0,
                              //width: 100,
                              //height: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(Constants.profile),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.3,
                      height: 100,
                      initialPage: 0,
                      enlargeFactor: 0.6,
                    ),
                  ),
                ),
              )
            ]),
          )),
    );
  }
}
