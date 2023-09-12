import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/model/contact.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/utils/top_level.dart';
import 'package:quickresponse/widgets/appbar.dart';
import 'package:quickresponse/widgets/contact_searchbar.dart';

import '../data/constants/colors.dart';
import '../providers/page_provider.dart';
import '../utils/density.dart';
import '../widgets/bottom_navigator.dart';

class Contacts extends ConsumerStatefulWidget {
  const Contacts({super.key});

  @override
  ConsumerState<Contacts> createState() => _ContactsState();
}

class _ContactsState extends ConsumerState<Contacts> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
      child: focus(
        _focusNode,
        Scaffold(
          backgroundColor: AppColor.background,
          appBar: appBar(
            title: const Text('Contacts', style: TextStyle(fontSize: 20)),
            leading: const Icon(CupertinoIcons.increase_quotelevel),
            actionTitle: 'Add',
            actionIcon: Icons.add,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ContactSearchBar(
              contacts: contacts,
              focusNode: _focusNode,
              onSelected: (Contact value) {
                launch(context, Constants.contactDetails, value);
              },
            ),
          ),
          bottomNavigationBar: const BottomNavigator(currentIndex: 2),
        ),
      ),
    );
  }
}
