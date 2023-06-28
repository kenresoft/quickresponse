import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/model/contact.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/routes/appbar.dart';
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
      appBar: const Appbar(title: 'Contacts', actionTitle: 'Add', actionIcon: Icons.add) as AppBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ContactSearchBar(
          contacts: contacts,
          onSelected: (String value) {
            launch(context, Constants.contactDetails);
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigator(currentIndex: 2),
    );
  }
}
