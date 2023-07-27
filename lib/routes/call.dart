import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

import '../data/constants/colors.dart';
import '../data/constants/density.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
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
              Expanded(child: ListView.builder(
                itemBuilder: (context, i) {
                  return Card();
                },
              ))
            ]),
          )),
    );
  }
}
