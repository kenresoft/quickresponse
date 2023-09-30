import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/model/profile_info.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/services/connectivity_service.dart';
import 'package:quickresponse/services/firebase/firebase_profile.dart';
import 'package:quickresponse/utils/wrapper.dart';

import '../../data/constants/styles.dart';
import '../../providers/providers.dart';
import '../../providers/settings/date_format.dart';
import '../../widgets/appbar.dart';
import '../../widgets/html_dialog.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  Future<ProfileInfo?> _loadProfileInfo() async {
    if (FirebaseAuth.instance.currentUser case var user?) {
      return await fetchUserProfile(user.uid);
    }
    return null;
  }

  late InternetConnection internetConnection;

  @override
  void initState() {
    super.initState();
    //internetConnection = InternetConnection();
  }

  @override
  void dispose() {
    //internetConnection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider.select((value) => value));
    final selectedDateFormat = ref.watch(dateFormatProvider.select((value) => value));
    final selectedTimeFormat = ref.watch(timeFormatProvider.select((value) => value));
    return Scaffold(
      backgroundColor: theme ? appColor.background : appColor.backgroundDark,
      appBar: appBar(
        title: const Text('User Profile', style: TextStyle(fontSize: 20)),
        leading: Icon(CupertinoIcons.increase_quotelevel, color: appColor.navIconSelected),
        actionTitle: '',
        action2: GestureDetector(
          onTap: () => _showSignOutConfirmationDialog(context),
          child: Transform.rotate(angle: pi / 2, child: Icon(CupertinoIcons.share, color: appColor.navIconSelected)),
        ),
      ),
      body: Center(
        child: FutureBuilder<ProfileInfo?>(
          future: _loadProfileInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            }

            ProfileInfo? profileInfo = snapshot.data;
            return Container(
              height: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: theme ? appColor.white : appColor.black, borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(color: theme ? appColor.background : appColor.backgroundDark, borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color:  theme ? appColor.background : appColor.backgroundDark, borderRadius: BorderRadius.circular(15)),
                      //margin: const EdgeInsets.all(2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildImage(),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.person, 'Name', profileInfo!.displayName!, theme),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.mail, 'Email', profileInfo.email!, theme),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.phone, 'Phone', profileInfo.phoneNumber!, theme),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.staroflife, 'Profile Status', profileInfo.isComplete.toString(), theme),
                          const SizedBox(height: 16),
                          buildCard(
                              CupertinoIcons.time,
                              'Last Signed In',
                              '${formatDateTime(
                                ref,
                                profileInfo.timestamp!.toDate(),
                                selectedDateFormat,
                              )} ${formatTime(
                                ref,
                                profileInfo.timestamp!.toDate(),
                                selectedTimeFormat,
                              )}',
                              theme),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () => launch(context, Constants.settings),
                            child: buildCard(CupertinoIcons.settings, 'Settings', 'View App Settings', theme),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => const HTMLDialog(
                                htmlAsset1: 'assets/data/quickresponse_policies.html', // Path to your HTML asset file 1
                                htmlAsset2: 'assets/data/quickresponse_terms.html', // Path to your HTML asset file 2
                              ),
                            ),
                            child: buildCard(CupertinoIcons.padlock, 'Terms and Policy', 'View App Privacy Policy & Terms', theme),
                          ),
                          const SizedBox(height: 16),

                          Center(
                            child: ElevatedButton(
                              style: const ButtonStyle(surfaceTintColor: MaterialStatePropertyAll(Colors.white)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String newPhoneNumber = '';
                                    return AlertDialog(
                                      surfaceTintColor: Colors.white,
                                      title: Text('Update Phone Number', style: TextStyle(color: appColor.title)),
                                      content: TextField(
                                        onChanged: (value) => newPhoneNumber = value,
                                        decoration: InputDecoration(
                                          labelText: 'New Phone Number',
                                          labelStyle: TextStyle(color: appColor.title_2),
                                          filled: true,
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: appColor.action)),
                                          fillColor: appColor.background,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                                        TextButton(
                                          onPressed: () {
                                            updateUserProfile(profileInfo.uid!, {'phoneNumber': newPhoneNumber}).then(
                                              (value) {},
                                            );
                                            //connectivityCheck;
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          child: const Text('Update'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text('Change Phone Number'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Add current location and app usage summary widgets here
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildImage() {
    return Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: FutureBuilder<ProfileInfo?>(
          future: getProfileInfoFromSharedPreferences(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user != null && user.photoURL != null) {
              return ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.photoURL!,
                  placeholder: (context, url) => buildIcon,
                  errorWidget: (context, url, error) => Icon(CupertinoIcons.exclamationmark_triangle, color: appColor.action),
                ),
              );
            } else {
              return buildIcon;
            }
          },
        ),
      ),
    );
  }

  Widget get buildIcon => Icon(CupertinoIcons.info, size: 60, color: appColor.navIconSelected);

  Card buildCard(IconData iconData, String title, String subTitle, bool theme) {
    return Card(
      margin: EdgeInsets.zero,
      color: theme ? appColor.white : appColor.black,
      elevation: 0,
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Padding(padding: const EdgeInsets.only(left: 16), child: Icon(iconData, color: appColor.navIconSelected, size: 30)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1, // Limit to a single line
          ),
          subtitle: Text(subTitle),
        ),
      ),
    );
  }
}

Future<void> _showSignOutConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Sign out the user here
              signOut();
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('Sign Out'),
          ),
        ],
      );
    },
  );
}
