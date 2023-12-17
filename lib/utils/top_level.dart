part of 'wrapper.dart';

GestureDetector focus(FocusNode focusNode, Widget child) {
  return GestureDetector(
    onTap: () {
      // When the user taps outside, remove the focus from the text input
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    },
    child: child,
  );
}

void saveContact(ContactModel selectedContact, VoidCallback callback) {
  // Load the existing contacts from SharedPreferences
  var existingContacts = Wrapper()._loadContactsFromPrefs();
  /*for (var element in existingContacts) {
    if (element.phone == selectedContact.phone!.replaceAll(' ', '')) {
      callback();
      return;
    }
  }*/

  // Add the selected contact to the existing contacts
  existingContacts.add(selectedContact);
  /*existingContacts = existingContacts.map((element) {
    var e = element;
    e.phone?.replaceAll(' ', '');
    return e;
  }).toList();*/
  // Save the updated contacts list to SharedPreferences
  Wrapper()._saveContactsToPrefs(existingContacts);
  addFirebaseContact(userId: uid, name: selectedContact.name!, phoneNumber: selectedContact.phone!.replaceAll(' ', '-'));
}

void updateContact(ContactModel contact) async {
  Wrapper()._updateEditedContactInPrefs(contact);
}

List<ContactModel> loadContacts() {
  return Wrapper()._loadContactsFromPrefs();
}

void deleteContact(ContactModel contactModel) {
  Wrapper()._deleteContactAndUpdatePrefs(contactModel);
}

Future<void> signOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  try {
    await auth.signOut();
    await googleSignIn.disconnect();
    clearSharedPreferences();
  } catch (e) {
    "Error signing out: $e".log;
  }
}

Future<void> clearSharedPreferences() async {
  var themeCache = theme;
  await SharedPreferencesService.clear();
  theme = themeCache;
}

bool isSignedIn() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  if (user != null && uid != 'No uid') return true;
  return false;
}

String generateRandomId({int length = 20}) {
  const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

String getDayOfWeek(DateTime date) {
  const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  return days[date.weekday - 1];
}

String getMonth(DateTime date) {
  const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return months[date.month - 1];
}

String date() {
  DateTime now = DateTime.now();
  String formattedDate = '${getDayOfWeek(now)}, ${getMonth(now)} ${now.day}, ${now.year}';
  return formattedDate;
}

Timestamp timestampFromDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return Timestamp.fromDate(date);
}

String dateFromTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  String formattedDate = '${getDayOfWeek(date)}, ${getMonth(date)} ${date.day}, ${date.year}';
  return formattedDate;
}

// Helper method to format the time based on the selected time separator
String formatTime(DateTime dateTime, TimeFormatOption formatOption) {
  return switch (formatOption) {
    TimeFormatOption.format12Hours => DateFormat('hh${timeSeparator}mm${timeSeparator}ss a').format(dateTime),
    TimeFormatOption.format24Hours => DateFormat('HH${timeSeparator}mm${timeSeparator}ss').format(dateTime),
    //_ => DateFormat('hh${timeSeparator}mm a').format(dateTime) // Default format (12-hour)
  };
}

String formatDate(DateTime dateTime, DateFormatOption formatOption) {
  return switch (formatOption) {
    DateFormatOption.format1 => DateFormat('MM${dateSeparator}dd${dateSeparator}yyyy').format(dateTime),
    DateFormatOption.format2 => DateFormat('dd${dateSeparator}MMM${dateSeparator}yyyy').format(dateTime),
    DateFormatOption.format3 => DateFormat('yyyy${dateSeparator}MM${dateSeparator}dd').format(dateTime),
    DateFormatOption.format4 => DateFormat('EEE, M${dateSeparator}d${dateSeparator}y').format(dateTime),
    DateFormatOption.format5 => DateFormat('EEEE, M${dateSeparator}d${dateSeparator}y').format(dateTime),
    _ => DateFormat('MM${dateSeparator}dd${dateSeparator}yyyy').format(dateTime) // Default format
  };
}
