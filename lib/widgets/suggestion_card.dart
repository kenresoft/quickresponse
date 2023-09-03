import 'package:background_sms/background_sms.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/utils/density.dart';

import '../data/model/contact.dart';
import '../routes/call.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    super.key,
    required this.text,
    this.verticalMargin,
    this.horizontalMargin,
    this.contact,
  });

  final String text;
  final double? verticalMargin;
  final double? horizontalMargin;
  final Contact? contact;

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return GestureDetector(
      onTap: () => initSetup(contact),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: verticalMargin ?? 0, horizontal: horizontalMargin ?? 8),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: 0.3.dpW(dp).spaceX(
                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  0.13.dpH(dp).spaceX(
                        Text(
                          text,
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.title_2),
                        ),
                      ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Icon(
                      Icons.arrow_forward,
                      size: 15,
                      color: AppColor.action,
                    ),
                    //0.15.dpW(dp).spX,
                    Icon(
                      CupertinoIcons.group,
                      color: AppColor.navIcon,
                    ),
                  ])
                ]),
              ),
        ),
      ),
    );
  }

  Future<void> initSetup(Contact? contact) async {
    getPermission() async {
      return await [Permission.sms].request();
    }

    Future<bool> isPermissionGranted() async => await Permission.sms.status.isGranted;

    Future<bool?> supportCustomSim() async => await BackgroundSms.isSupportCustomSim;

    if (await isPermissionGranted()) {
      if ((await supportCustomSim())!) {
        sendMessage(contact?.phone ?? '1', "Hello", simSlot: 1);
      } else {
        sendMessage("09xxxxxxxxx", "Hello");
      }
    } else {
      getPermission();
    }
  }
}
