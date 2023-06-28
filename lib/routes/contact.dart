import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

import '../data/constants/colors.dart';
import '../data/constants/density.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            0.05.dpH(dp).spY,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Icon(Icons.arrow_back, color: AppColor.navIconSelected),
              ),
              Text(
                'Contacts',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppColor.title),
                textAlign: TextAlign.center,
              ),
              Row(children: [
                Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.title),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.delete_forever_outlined, color: AppColor.navIconSelected),
              ]),
            ]),
            0.01.dpH(dp).spY,
          ]),
        ),
      ),
    );
  }
}
