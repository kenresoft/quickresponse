import 'dart:async';

import 'package:background_sms/background_sms.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/constants/constants.dart';
import '../../data/constants/styles.dart';
import '../../data/model/contact.dart';
import '../../providers/settings/prefs.dart';
import '../../utils/extensions.dart';
import '../../utils/util.dart';
import '../../widgets/inputs/alert_button.dart';
import '../../widgets/screens/suggestion_card.dart';
import '../camera/camera_preview.dart';

class Call extends StatefulWidget {
  const Call({
    super.key,
    this.onImageCapture,
    this.onVideoRecord,
    this.onAudioRecord,
    this.properties,
    this.videoTimer,
  });

  final GestureTapCallback? onImageCapture;
  final GestureTapCallback? onVideoRecord;
  final GestureTapCallback? onAudioRecord;
  final CallProperties? properties;
  final String? videoTimer;

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  CarouselController buttonCarouselController = CarouselController();
  bool isContactTap = false;
  bool shouldHide = false;
  double x = 0, y = 0;

  @override
  void initState() {
    super.initState();
    Util.lockOrientation();
  }

  @override
  void dispose() {
    Util.unlockOrientation();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
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
    final contact = GoRouterState.of(context).extra as ContactModel?;

    final dp = Density.init(context);
    return WillPopScope(
      onWillPop: () {
        if (isContactTap) {
          setState(() {
            isContactTap = false;
          });
          return Future(() => false);
        } else {
          return Future(() => true);
        }
      },
      child: Scaffold(
        backgroundColor: shouldHide ? AppColor(theme).black : Colors.transparent,
        body: Center(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            0.05.dpH(dp).spY,
            GestureDetector(
              onTap: () => setState(() {
                shouldHide = !shouldHide;
              }),
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(widget.videoTimer!),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => shouldHide = !shouldHide),
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(shouldHide ? CupertinoIcons.eye_slash : CupertinoIcons.eye, color: AppColor(theme).white, size: 22),
                ),
              ),
            ),
            0.08.dpH(dp).spY,
            Icon(CupertinoIcons.phone_arrow_up_right, color: AppColor(theme).white, size: 40),
            0.05.dpH(dp).spY,
            Text('Want to call emergency number?', style: TextStyle(fontSize: 16, color: AppColor(theme).white)),
            0.05.dpH(dp).spY,
            /*Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              EmergencyCard(
                child: SizedBox(
                    width: dp.width - 80, child: Blink(data: contact?.phone ?? '112', align: TextAlign.center, style: TextStyle(fontSize: 55, color: AppColor(theme).action, fontWeight: FontWeight.w500))),
              ),
              0.05.dpW(dp).spX,
              contact?.phone == null
                  ? EmergencyCard(
                      child: Blink(data: '911', style: TextStyle(fontSize: 55, color: AppColor(theme).action_2, fontWeight: FontWeight.w500), delay: true),
                    )
                  : const SizedBox(),
            ]),*/
            /*0.10.dpH(dp).spY,
            Text('Who needs help?', style: TextStyle(fontSize: 25, color: AppColor(theme).white, fontWeight: FontWeight.w600)),
            0.03.dpH(dp).spY,
            SizedBox(
              height: 120,
              width: 310,
              child: isContactTap
                  ? buildSuggestionAlertMessage(dp, contact)
                  : buildContactsCarousel('userId', onTap: () {
                      setState(() {
                        isContactTap = true;
                      });
                    }, buttonCarouselController: buttonCarouselController),
            ),
            0.07.dpH(dp).spY,*/
            0.5.dpH(dp).spY,
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
}

ListView buildSuggestionAlertMessage(Density dp, ContactModel? contact) {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: 6,
    itemBuilder: (BuildContext context, int index) {
      return SuggestionCard(text: 'He had an accident', contact: contact, verticalMargin: 15, horizontalMargin: 5);
    },
  );
}

IconButton buildIconButton(IconData iconData, double size, {Function()? onPressed}) {
  return IconButton.filled(
    onPressed: onPressed,
    icon: Icon(iconData, size: size),
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(AppColor(theme).overlay),
      fixedSize: const MaterialStatePropertyAll(Size.square(58)),
    ),
  );
}

Widget buildContactsCarousel(String userId, {required Function() onTap, required CarouselController buttonCarouselController}) {
  return CarouselSlider.builder(
    itemCount: 3,
    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
      "$itemIndex : $pageViewIndex".log;
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
            Text('$itemIndex', style: TextStyle(fontSize: 18, color: AppColor(theme).white)),
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
