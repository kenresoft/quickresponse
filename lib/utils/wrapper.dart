import 'package:quickresponse/imports.dart';

part '../utils/top_level.dart';

class Wrapper {
  Wrapper();

  /// ---- LOAD/SAVE CONTACT TO STORAGE
// Function to load contacts from SharedPreferences
  List<ContactModel> _loadContactsFromPrefs() {
    final jsonContacts = SharedPreferencesService.getString('contacts');
    if (jsonContacts != null) {
      return _contactsFromJson(jsonContacts);
    }
    return [];
  }

// Function to save the JSON string to SharedPreferences
  void _saveContactsToPrefs(List<ContactModel> contacts) {
    final jsonContacts = _contactsToJson(contacts);
    SharedPreferencesService.setString('contacts', jsonContacts);
  }

  void _clearContactsPref() {
    SharedPreferencesService.remove('contacts');
  }

  /// ---- JSON CONVERTERS
// Function to convert a list of contacts to a JSON string
  String _contactsToJson(List<ContactModel> contacts) {
    final contactList = contacts.map((contact) {
      return {
        'name': contact.name,
        'relationship': contact.relationship,
        'phone': contact.phone,
        'age': contact.age,
        'height': contact.height,
        'weight': contact.weight,
        'imageFile': contact.imageFile,
      };
    }).toList();
    return jsonEncode(contactList);
  }

// Function to convert the JSON string back into a list of contacts
  List<ContactModel> _contactsFromJson(String json) {
    final contactList = jsonDecode(json) as List;
    return contactList.map((contactMap) {
      return ContactModel(
        name: contactMap['name'],
        relationship: contactMap['relationship'],
        phone: contactMap['phone'],
        age: contactMap['age'],
        height: contactMap['height'],
        weight: contactMap['weight'],
        imageFile: contactMap['imageFile'],
      );
    }).toList();
  }

  /// ---- SHARED PREFERENCE SETUP

  void _updateContactInPrefs(ContactModel contactToDelete) {
    final existingContacts = _loadContactsFromPrefs();
    existingContacts.removeWhere((contact) => contact.name == contactToDelete.name && contact.phone == contactToDelete.phone);

    _saveContactsToPrefs(existingContacts);
  }

  void _deleteContactAndUpdatePrefs(ContactModel contactToDelete) {
    final existingContacts = _loadContactsFromPrefs();

    // Find the index of the contact to be deleted based on a unique identifier (e.g., phone number).
    final index = existingContacts.indexWhere((contact) => contact.phone == contactToDelete.phone);

    if (index != -1) {
      // Remove the contact from the existing contacts list.
      existingContacts.removeAt(index);

      // Save the updated contacts list to SharedPreferences.
      _saveContactsToPrefs(existingContacts);
    }
  }

  void _updateEditedContactInPrefs(ContactModel updatedContact) {
    final existingContacts = _loadContactsFromPrefs();

    // Find the index of the contact to be updated based on a unique identifier (e.g., phone number).
    final index = existingContacts.indexWhere((contact) => contact.phone == updatedContact.phone);
    if (index != -1) {
      // Replace the existing contact with the updated contact.
      existingContacts[index] = updatedContact;

      // Save the updated contacts list to SharedPreferences.
      _saveContactsToPrefs(existingContacts);
    }
  }
}
