import 'dart:developer';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/data/model/contact.dart';
import 'package:quickresponse/widgets/contact_searchbar.dart';

import '../data/constants/colors.dart';
import '../data/constants/density.dart';
import '../widgets/bottom_navigator.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = Contact.contactList;
    final dp = Density.init(context);
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: const Text('Contacts'),
        titleTextStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColor.title),
        centerTitle: true,
        actions: [
          Row(children: [
            Text(
              'Add',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.navIconSelected),
              textAlign: TextAlign.center,
            ),
            2.spX,
            Icon(
              Icons.add,
              color: AppColor.navIconSelected,
              size: 18,
            ),
            20.spX
          ])
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ContactSearchBar(
          contacts: contacts,
          onSelected: (String value) {
            log(value);
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigator(currentIndex: 2),
    );
  }
}
