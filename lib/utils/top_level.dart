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

Future<void> saveContact(ContactModel selectedContact) async {
  // Load the existing contacts from SharedPreferences
  final existingContacts = await Wrapper()._loadContactsFromPrefs();

  // Add the selected contact to the existing contacts
  existingContacts.add(selectedContact);

  // Save the updated contacts list to SharedPreferences
  await Wrapper()._saveContactsToPrefs(existingContacts);
}

Future<void> saveContacts(List<ContactModel> contacts) async {
  await Wrapper()._saveContactsToPrefs(contacts);
}

Future<void> setContacts(List<ContactModel> contacts) async {
  await Wrapper()._clearContactsPref();
  await Wrapper()._saveContactsToPrefs(contacts);
}

Future<List<ContactModel>> loadContacts() async {
  return await Wrapper()._loadContactsFromPrefs();
}

Future<void> updateContact(ContactModel contactModel) async {
  Wrapper()._updateContactInPrefs(contactModel);
}

Future<void> updateEditedContact(ContactModel contactModel) async {
  Wrapper()._updateEditedContactInPrefs(contactModel);
}

