import 'dart:developer';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:quickresponse/data/model/contact.dart';
import 'package:quickresponse/widgets/mini_map.dart';

import '../data/constants/colors.dart';
import '../data/constants/constants.dart';
import '../data/constants/density.dart';
import '../main.dart';
import '../providers/location_providers.dart';
import '../widgets/alert_button.dart';
import '../widgets/appbar.dart';
import '../widgets/arrow_divider.dart';

class ContactDetails extends ConsumerStatefulWidget {
  const ContactDetails({super.key});

  @override
  ConsumerState<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends ConsumerState<ContactDetails> {
  final ScrollController _scrollController = ScrollController();
  bool _bottomSheetVisible = false;
  List<Placemark>? placemarks;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        setState(() {
          _bottomSheetVisible = true;
        });
      } else {
        setState(() {
          _bottomSheetVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contact = GoRouterState.of(context).extra as Contact;
    final dp = Density.init(context);

    final location = ref.watch(positionProvider.select((value) => value!));
    log('Pos: $location');
    getPlacemarks(location);

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: appBar(title: const Text('Contacts'), actionTitle: 'Delete', actionIcon: CupertinoIcons.trash),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Card(
          elevation: 0,
          color: AppColor.white,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Center(
                child: Column(children: [
                  0.02.dpH(dp).spY,
                  const Image(image: ExactAssetImage(Constants.moon), height: 70),
                  0.001.dpH(dp).spY,
                  Text(contact.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(contact.relationship, style: const TextStyle(fontSize: 13)),
                  0.02.dpH(dp).spY,

                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      buildTableLeft('Age:', CupertinoIcons.calendar, Colors.green, '28', 'years'),
                      // Vertical Divider
                      Container(height: 100, width: 1.5, color: AppColor.divider),
                      buildTableRight('Blood Type:', CupertinoIcons.drop, Colors.red, '0Rh', '+'),
                    ]),
                  ),

                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      buildTableLeft('Height:', Icons.height, Colors.blue, '172', 'cm'),
                      // Vertical Divider
                      Container(height: 100, width: 1.5, color: AppColor.divider),
                      buildTableRight('Weight:', Icons.scale, Colors.purple, '77', 'kg'),
                    ]),
                  ),

                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  0.03.dpH(dp).spY,

                  /// Section 2
                  const Text('Allergies and Reactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('Food:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.text)),
                  0.02.dpH(dp).spY,

                  /// Table 2
                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  buildRow(dp, Icons.apple, Colors.red, 'Apples:', 'Rush'),
                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  buildRow(dp, Icons.nights_stay_outlined, Colors.yellow, 'Banana:', 'Temperature, Blush'),
                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  buildRow(dp, Icons.noise_aware_outlined, Colors.brown, 'Nuts:', 'Shortness of breath'),
                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  0.03.dpH(dp).spY,

                  Text('Plants:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.text)),
                  0.02.dpH(dp).spY,

                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  buildRow(dp, Icons.energy_savings_leaf_outlined, Colors.green, 'Grass', 'Watery runny nose'),
                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  buildRow(dp, Icons.eco_outlined, Colors.blue, 'Adder', 'Conjunctivitis'),
                  // Horizontal Divider
                  Container(width: double.infinity, height: 1.5, color: AppColor.divider),
                  0.03.dpH(dp).spY,

                  /// MAP
                  const Text('Current Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('${placemarks?.last.street}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.text)),
                  0.02.dpH(dp).spY,
                  const MiniMap(),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        height: _bottomSheetVisible ? 0 : 90,
        decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.zero, boxShadow: [
          BoxShadow(color: AppColor.black, offset: const Offset(0, 10), blurRadius: 20),
        ]),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Image(image: ExactAssetImage(Constants.moon), height: 50),
              const Text('This is the bottom sheet'),
              GestureDetector(
                onLongPress: () => launch(context, Constants.call),
                child: AlertButton(height: 55, width: 53, borderWidth: 2, shadowWidth: 9, iconSize: 30, onPressed: () {  },),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Stack buildRow(Density dp, IconData icon, Color color, String food, String reaction) {
    return Stack(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Icon(icon, color: color),
          0.02.dpW(dp).spX,
          Text(food, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.text)),
        ]),
        0.16.dpW(dp).spX,
        Text(reaction, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.text), textAlign: TextAlign.start),
      ]),
      Row(children: [
        0.35.dpW(dp).spX,
        SizedBox(height: 40, width: 8, child: CustomPaint(painter: ArrowDivider())),
      ]),
    ]);
  }

  Expanded buildTableRight(String title, IconData icon, Color color, String valueA, String valueB) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.text, fontSize: 18)),
            Icon(icon, color: color, size: 18),
          ]),
          Row(
            children: [
              Text(valueA, style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.black, fontSize: 40)),
              1.spX,
              Text(valueB, style: TextStyle(fontWeight: FontWeight.w800, color: AppColor.black, fontSize: 16))
            ],
          ),
        ]),
      ),
    );
  }

  Expanded buildTableLeft(String title, IconData icon, Color color, String valueA, String valueB) {
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.text, fontSize: 18)),
            Icon(icon, color: color, size: 18),
          ]),
        ),
        Row(
          children: [
            Text(valueA, style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.black, fontSize: 40)),
            Text(valueB, style: TextStyle(fontWeight: FontWeight.w800, color: AppColor.black, fontSize: 16))
          ],
        ),
      ]),
    );
  }

  Future<void> getPlacemarks(Position position) async {
    placemarks = await GeocodingPlatform.instance.placemarkFromCoordinates(position.latitude, position.longitude);
  }
}
