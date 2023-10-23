import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:quickresponse/imports.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/contact.dart';
import '../providers/settings/date_time_format.dart';
import '../providers/settings/prefs.dart';

part '../utils/top_level.dart';

class Wrapper {
  Wrapper();

  /// ---- LOAD/SAVE CONTACT TO STORAGE
// Function to load contacts from SharedPreferences
  Future<List<ContactModel>> _loadContactsFromPrefs() async {
    final jsonContacts = await _loadContactsJsonFromPrefs();
    if (jsonContacts != null) {
      return _contactsFromJson(jsonContacts);
    }
    return [];
  }

// Function to save the JSON string to SharedPreferences
  Future<void> _saveContactsToPrefs(List<ContactModel> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonContacts = _contactsToJson(contacts);
    await prefs.setString('contacts', jsonContacts);
  }

  Future<void> _clearContactsPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('contacts');
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
// Function to retrieve the JSON string from SharedPreferences
  Future<String?> _loadContactsJsonFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('contacts');
  }

  /// ---- UPDATE

  Future<void> _updateContactInPrefs(ContactModel contactToDelete) async {
    final existingContacts = await _loadContactsFromPrefs();
    existingContacts.removeWhere((contact) => contact.name == contactToDelete.name && contact.phone == contactToDelete.phone);

    await _saveContactsToPrefs(existingContacts);
  }

  Future<void> _deleteContactAndUpdatePrefs(ContactModel contactToDelete) async {
    final existingContacts = await _loadContactsFromPrefs();

    // Find the index of the contact to be deleted based on a unique identifier (e.g., phone number).
    final index = existingContacts.indexWhere((contact) => contact.phone == contactToDelete.phone);

    if (index != -1) {
      // Remove the contact from the existing contacts list.
      existingContacts.removeAt(index);

      // Save the updated contacts list to SharedPreferences.
      await _saveContactsToPrefs(existingContacts);
    }
  }

  Future<void> _updateEditedContactInPrefs(ContactModel updatedContact) async {
    final existingContacts = await _loadContactsFromPrefs();

    // Find the index of the contact to be updated based on a unique identifier (e.g., phone number).
    final index = existingContacts.indexWhere((contact) => contact.phone == updatedContact.phone);
    if (index != -1) {
      // Replace the existing contact with the updated contact.
      existingContacts[index] = updatedContact;

      // Save the updated contacts list to SharedPreferences.
      await _saveContactsToPrefs(existingContacts);
    }
  }
}
