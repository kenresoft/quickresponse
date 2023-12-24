import 'package:quickresponse/main.dart';

Widget bottomNavigator(BuildContext context, int currentIndex) {
  //Future(() => setState(() => theme = theme));
  return Container(
    height: 69,
    color: AppColor(theme).white,
    child: BottomNavigationBar(
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
      backgroundColor: Colors.transparent,
      elevation: 0,
      unselectedItemColor: AppColor(theme).navIcon,
      unselectedLabelStyle: TextStyle(color: AppColor(theme).navIcon, height: 2),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(color: AppColor(theme).navIconSelected),
      selectedItemColor: AppColor(theme).navIconSelected,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index case 0) {
          replace(context, Constants.home);
        } else if (index case 1) {
          replace(context, Constants.travellersAlarm);
        } else if (index case 2) {
          replace(context, Constants.contacts);
        } else if (index case 3) {
          replace(context, Constants.history);
        } else if (index case 4) {
          replace(context, Constants.settings);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.house), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.drop_triangle), label: 'Emergency'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.phone_badge_plus), label: 'Contacts'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.clock), label: 'History'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
      ],
    ),
  );
}

/*
import 'package:bottom_nav/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/providers/page_provider.dart';

import '../data/constants/constants.dart';
import '../data/constants/styles.dart';
import '../main.dart';
import '../providers/providers.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        var page = ref.watch(pageProvider.select((value) => value));
        return BottomNav(
          height: 74,
          // Attention: limit maximum height
          padding: const EdgeInsets.all(25).copyWith(top: 5, bottom: 10),
          onTap: (index) {
            ref.watch(tabProvider.notifier).setTab = index;

/final contacts = ref.watch(contactModelProvider.select((value) => value));
            if (currentIndex == 2 && contacts != null) {
              setContacts(contacts!);
            }

            if (index == 0) {
              replace(context, Constants.home);
              ref.watch(pageProvider.notifier).setPage = page..add(Constants.home);
            } else if (index == 1) {
              replace(context, Constants.travellersAlarm);
              //replace(context, Constants.alarm);
            } else if (index == 2) {
              replace(context, Constants.contacts);
            } else if (index == 3) {
              replace(context, Constants.history);
              //replace(context, Constants.mapScreen);
            } else if (index == 4) {
              replace(context, Constants.settings);
            }
          },
          iconSize: 23,
          labelSize: 12,
          //backgroundColor: AppColor(theme).nav,
          color: AppColor(theme).navIcon,
          colorSelected: AppColor(theme).navIconSelected,
          indexSelected: widget.currentIndex */
/*ref.watch(tabProvider.select((value) => value))*/ /*
,
          items: const [
            BottomNavItem(label: 'Home', child: CupertinoIcons.house),
            BottomNavItem(label: 'Emergency', child: CupertinoIcons.drop_triangle),
            BottomNavItem(label: 'Contacts', child: CupertinoIcons.phone_badge_plus),
            BottomNavItem(label: 'History', child: CupertinoIcons.clock),
            BottomNavItem(label: 'Settings', child: CupertinoIcons.settings),
          ],
        );
      },
    );
  }
}
*/
