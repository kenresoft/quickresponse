import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/model/contact.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/widgets/appbar.dart';
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
      appBar: appBar(title: 'Contacts', actionTitle: 'Add', actionIcon: Icons.add),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ContactSearchBar(
          contacts: contacts,
          onSelected: (Contact value) {
            launch(context, Constants.contactDetails, value);
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigator(currentIndex: 2),
    );
  }
}
