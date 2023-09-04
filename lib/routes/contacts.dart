import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/model/contact.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/widgets/appbar.dart';
import 'package:quickresponse/widgets/contact_searchbar.dart';

import '../data/constants/colors.dart';
import '../utils/density.dart';
import '../providers/page_provider.dart';
import '../widgets/bottom_navigator.dart';
import '../widgets/exit_dialog.dart';

class Contacts extends ConsumerWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final contacts = Contact.contactList;
    final dp = Density.init(context);
    final page = ref.watch(pageProvider.select((value) => value));
    return WillPopScope(
      onWillPop: () async {
        bool isLastPage = page.isEmpty;
        if (isLastPage) {
          launch(context, Constants.home);
          return false;
          //return (await showAnimatedDialog(context))!;
        } else {
          launch(context, page.last);
          ref.watch(pageProvider.notifier).setPage = page..remove(page.last);
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: appBar(title: const Text('Contacts'), actionTitle: 'Add', actionIcon: Icons.add),
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
      ),
    );
  }
}
