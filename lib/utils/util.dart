import 'package:carousel_slider/carousel_slider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickresponse/imports.dart';

class Util {
  Util._();

  static Widget loadFuture<T>(
    Future<T> future,
    void Function(Object data) data,
    Widget Function(T? data) child,
  ) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          if (result != null) {
            data(result);
          } else {
            data('Null data returned.');
          }
          return child(result);
        } else if (snapshot.hasError) {
          data('Error: ${snapshot.error}');
          return const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  static Widget loadStream<T>(
    Stream<T> stream,
    //void Function(Object data) data,
    Widget Function(T? data) child,
  ) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        T? result;
        if (snapshot.hasData) {
          result = snapshot.data;
          if (result != null) {
            //data(result);
            return child(result);
          } else {
            //data('Null data returned.');
            return const Toast('Null data returned.', show: true);
          }
        } else if (snapshot.hasError) {
          //data('Error: ${snapshot.error}');
          return Toast('Error: ${snapshot.error}', show: true);
        } else {
          return child(result);
        }
      },
    );
  }

  static Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted || statuses[Permission.microphone] != PermissionStatus.granted || statuses[Permission.storage] != PermissionStatus.granted) {
      // Handle permission denied scenarios
      'Camera or storage permission is not granted.'.log;
    }
  }

  static lockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static unlockOrientation() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static String formatCategory(String category) {
    // Split the category into words
    List<String> words = category.split('_');

    // Capitalize the first letter of each word and join them back
    String formattedCategory = words.map((word) {
      return word.substring(0, 1).toUpperCase() + word.substring(1);
    }).join(' ');

    return formattedCategory;
  }
}

sendMessage(String phoneNumber, String message, {int? simSlot}) async {
  var result = await BackgroundSms.sendMessage(phoneNumber: phoneNumber, message: message, simSlot: simSlot);
  if (result == SmsStatus.sent) {
    "Sent".log;
  } else {
    "Failed".log;
  }
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

Widget buildContactsCarousel(String userId, {required Function() onTap, required CarouselController buttonCarouselController}) {
  return CarouselSlider.builder(
    itemCount: 3,
    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
      ///"$itemIndex : $pageViewIndex".log;
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

void handleSOS([String? msg, int? count]) {
  final newEmergencyAlert = EmergencyAlert.autoIncrement(
    type: EmergencyAlert.getAlertTypeFromCustomMessage(msg ?? sosMessage),
    dateTime: DateTime.now(),
    location: 'Latitude: $latitude, Longitude: $longitude',
    details: 'From ${getProfileInfoFromSharedPreferences().displayName}',
    customMessage: msg.let((it) => it == 'travel_alarm' ? 'Alarm count is $count' : sosMessage) ?? sosMessage,
    hasLocationData: latitude != 0 && longitude != 0,
  );

  // H: SEND SOS FROM HERE

  var alerts = emergencyAlerts;
  alerts.add(newEmergencyAlert);
  emergencyAlerts = alerts;
}
