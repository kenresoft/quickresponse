import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/data/model/profile_info.dart';
import 'package:quickresponse/services/connectivity_service.dart';
import 'package:quickresponse/services/firebase/firebase_profile.dart';
import 'package:quickresponse/utils/wrapper.dart';

import '../../data/constants/colors.dart';
import '../../providers/settings/date_format.dart';
import '../../widgets/appbar.dart';

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
    final selectedDateFormat = ref.watch(dateFormatProvider.select((value) => value));
    final selectedTimeFormat = ref.watch(timeFormatProvider.select((value) => value));
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: appBar(
        title: const Text('User Profile', style: TextStyle(fontSize: 20)),
        leading: Icon(CupertinoIcons.increase_quotelevel, color: AppColor.navIconSelected),
        actionTitle: '',
        //actionIcon: CupertinoIcons.share,
        action2: Transform.rotate(angle: pi / 2, child: Icon(CupertinoIcons.share, color: AppColor.navIconSelected)),
        onActionClick: () => signOut(),
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(color: AppColor.background, borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: AppColor.background, borderRadius: BorderRadius.circular(15)),
                      //margin: const EdgeInsets.all(2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildImage(),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.person, 'Name:', profileInfo!.displayName!),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.mail, 'Email:', profileInfo.email!),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.phone, 'Phone:', profileInfo.phoneNumber!),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.staroflife, 'Profile Status:', profileInfo.isComplete.toString()),
                          const SizedBox(height: 16),
                          buildCard(
                              CupertinoIcons.time,
                              'Last Signed In:',
                              '${formatDateTime(
                                ref,
                                profileInfo.timestamp!.toDate(),
                                selectedDateFormat,
                              )} ${formatTime(
                                ref,
                                profileInfo.timestamp!.toDate(),
                                selectedTimeFormat,
                              )}'),
                          const SizedBox(height: 16),
                          buildCard(CupertinoIcons.settings, 'Settings', 'View App Settings'),
                          const SizedBox(height: 16),
                          buildCard(Icons.person, 'Phone:', profileInfo.phoneNumber!),
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
                                      title: const Text('Update Phone Number'),
                                      content: TextField(
                                        onChanged: (value) => newPhoneNumber = value,
                                        decoration: InputDecoration(labelText: 'New Phone Number', filled: true, border: OutlineInputBorder(), fillColor: AppColor.overlay),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('Cancel'),
                                        ),
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
                  errorWidget: (context, url, error) => Icon(CupertinoIcons.exclamationmark_triangle, color: AppColor.action),
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

  Widget get buildIcon => const Icon(CupertinoIcons.info, size: 60);

  Card buildCard(IconData iconData, String title, String subTitle) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColor.whiteTransparent,
      elevation: 0,
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Padding(padding: const EdgeInsets.only(left: 16), child: Icon(iconData, color: AppColor.navIconSelected, size: 30)),
          title: Text(
            title,
            style: TextStyle(color: AppColor.title, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1, // Limit to a single line
          ),
          subtitle: Text(subTitle),
        ),
      ),
    );
  }
}
