import 'dart:developer';

import 'package:background_sms/background_sms.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_sms/flutter_sms.dart';

/*import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';*/
//import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickresponse/camera_preview.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:quickresponse/widgets/alert_button.dart';

//import 'package:sms_advanced/sms_advanced.dart';

import '../data/constants/colors.dart';
import '../data/constants/density.dart';
import '../data/model/contact.dart';
import '../widgets/suggestion_card.dart';

class Call extends StatefulWidget {
  const Call({
    super.key,
    this.onImageCapture,
    this.onVideoRecord,
    this.onAudioRecord,
    this.properties,
  });

  final GestureTapCallback? onImageCapture;
  final GestureTapCallback? onVideoRecord;
  final GestureTapCallback? onAudioRecord;
  final CallProperties? properties;

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  CarouselController buttonCarouselController = CarouselController();
  bool isContactTap = false;

  @override
  void initState() {
    super.initState();
  }

  //_sendMessage(String number) async {
  //await FlutterPhoneDirectCaller.callNumber(number);

  //this._currentUuid = _uuid.v4();
/*    CallKitParams params = const CallKitParams(
        id: '1a2b3c4d' */ /*this._currentUuid*/ /*,
        nameCaller: 'Hien Nguyen',
        handle: '0123456789',
        type: 1,
        extra: <String, dynamic>{'userId': '1a2b3c4d'},
        ios: IOSParams(handleType: 'generic')
    );
    await FlutterCallkitIncoming.startCall(params);*/

  /*StreamBuilder<PhoneState>(
      initialData: PhoneState.nothing(),
      stream: PhoneState.stream,
      builder: (context, a) {
        return SizedBox();
      },
    );*/

  //}

  @override
  Widget build(BuildContext context) {
    final contact = GoRouterState.of(context).extra as Contact?;

    final dp = Density.init(context);
    return WillPopScope(
      onWillPop: () {
        log('message');
        setState(() {
          isContactTap = false;
        });
        return Future(() => true);
      },
      child: Scaffold(
        body: Center(
          child: Column(children: [
            0.01.dpH(dp).spY,
            Icon(Icons.visibility, color: AppColor.white, size: 22),
            0.12.dpH(dp).spY,
            Icon(Icons.ac_unit, color: AppColor.white, size: 40),
            Text(contact?.phone ?? '112', style: TextStyle(fontSize: 65, color: AppColor.white, fontWeight: FontWeight.w500)),
            Text('Calling...', style: TextStyle(fontSize: 18, color: AppColor.white)),
            0.23.dpH(dp).spY,
            Text('Who needs help?', style: TextStyle(fontSize: 25, color: AppColor.white, fontWeight: FontWeight.w600)),
            0.03.dpH(dp).spY,
            SizedBox(
              height: 120,
              width: 310,
              child: isContactTap
                  ? buildSuggestionAlertMessage(dp)
                  : buildContactsCarousel(
                      onTap: () {
                        setState(() {
                          initSetup(contact);
                          isContactTap = true;
                        });
                      },
                      buttonCarouselController: buttonCarouselController),
            ),
            0.07.dpH(dp).spY,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                buildIconButton(
                  widget.properties!.isRecordingVideo ? Icons.play_arrow_outlined : Icons.video_collection_outlined,
                  22,
                  onPressed: widget.onVideoRecord,
                ),
                AlertButton(
                  height: 70,
                  width: 70,
                  borderWidth: 2,
                  shadowWidth: 10,
                  iconSize: 25,
                  showSecondShadow: false,
                  iconData: Icons.camera_alt,
                  //iconData: widget.properties!.isCapturingImage ? Icons.play_arrow_outlined : Icons.call_end,
                  onPressed: widget.onImageCapture /*finish(context)*/,
                ),
                buildIconButton(
                  widget.properties!.isRecordingAudio ? Icons.play_arrow_outlined : Icons.audiotrack_outlined,
                  22,
                  onPressed: widget.onAudioRecord,
                ),
              ]),
            ),
          ]),
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

ListView buildSuggestionAlertMessage(Density dp) {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: 6,
    itemBuilder: (BuildContext context, int index) {
      return const SuggestionCard(text: 'He had an accident', verticalMargin: 15, horizontalMargin: 5);
    },
  );
}

IconButton buildIconButton(IconData iconData, double size, {Function()? onPressed}) {
  return IconButton.filled(
    onPressed: onPressed,
    icon: Icon(iconData, size: size),
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(AppColor.overlay),
      fixedSize: const MaterialStatePropertyAll(Size.square(58)),
    ),
  );
}

Widget buildContactsCarousel({required Function() onTap, required CarouselController buttonCarouselController}) {
  return CarouselSlider.builder(
    itemCount: 3,
    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
      log("$itemIndex : $pageViewIndex");
      return GestureDetector(
        onTap: () {
          onTap();
        },
        child: Center(
          child: Column(children: [
            Stack(
              children: [
                AnimatedPositioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  duration: const Duration(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(Constants.profile),
                  ),
                ),
              ],
            ),
            Text('$itemIndex', style: TextStyle(fontSize: 18, color: AppColor.white)),
          ]),
        ),
      );
    },
    carouselController: buttonCarouselController,
    options: CarouselOptions(
      enableInfiniteScroll: false,
      enlargeCenterPage: true,
      viewportFraction: 0.35,
      aspectRatio: 1.0,
      enlargeFactor: 0.5,
      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
    ),
  );
}

sendMessage(String phoneNumber, String message, {int? simSlot}) async {
  var result = await BackgroundSms.sendMessage(phoneNumber: phoneNumber, message: message, simSlot: simSlot);
  if (result == SmsStatus.sent) {
    "Sent".log;
  } else {
    "Failed".log;
  }
}
