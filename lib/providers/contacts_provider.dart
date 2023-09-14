import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/contact.dart';

final contactModelProvider = StateNotifierProvider<ContactModelNotifier, List<ContactModel>>((ref) {
  return ContactModelNotifier();
});

class ContactModelNotifier extends StateNotifier<List<ContactModel>> {
  ContactModelNotifier() : super([]);

  // Function to add a contact to the list
  void addContact(ContactModel contact) {
    state = [...state, contact];
  }

  void setContact(List<ContactModel> contact) {
    state = contact;
  }
}

/*class ContactCountNotifier extends StateNotifier<int> {
  ContactCountNotifier() : super(0);

  void increment() {
    if (state < 10) {
      state++;
    }
  }

  void decrement() {
    if (state > 0) {
      state--;
    }
  }

  set setCurrent(int count) => state = count;
}

final contactCountProvider = StateNotifierProvider<ContactCountNotifier, int>((ref) {
  return ContactCountNotifier();
});*/
