import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontresoft/fontresoft.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/services/firebase/firebase_profile.dart';

import '../../data/constants/styles.dart';
import '../../data/model/contact.dart';
import '../../main.dart';
import '../../providers/contacts_provider.dart';
import '../../providers/settings/prefs.dart';
import '../../services/firebase/firebase_contact.dart';
import '../../utils/wrapper.dart';
import '../../widgets/screens/appbar.dart';
import '../../widgets/screens/overlay_scaffold.dart';
import 'contact_search.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  TextEditingController searchController = TextEditingController();
  List<ContactModel> contacts = [];
  List<ContactModel> filteredContacts = [];
  GlobalKey<ScaffoldMessengerState>? key = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _fetchContactFromDevice();
    filteredContacts = contacts;
    searchController.addListener(() => _searchContacts(searchController.text));
  }

  void _searchContacts(String query) {
    setState(() {
      filteredContacts = contacts.where((contact) {
        final nameMatches = contact.name!.toLowerCase().contains(query.toLowerCase());
        final phoneNumberMatches = contact.phone!.toLowerCase().contains(query.toLowerCase());
        return nameMatches || phoneNumberMatches;
      }).toList();
    });
  }

  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
      filteredContacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*sKey: key,
      onPressed1: () => _fetchContactFromDevice(),*/
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        title: const Text('Contacts', style: TextStyle(fontSize: 20)),
        leading: const Icon(CupertinoIcons.increase_quotelevel),
        actionTitle: 'Search',
        actionIcon: CupertinoIcons.search,
        onActionClick: () {
          _searchForContact(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: filteredContacts.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
              color: AppColor(theme).white,
              elevation: 0,
              child: ListTile(
                title: Text(
                  filteredContacts[index].name ?? 'No name',
                  style: TextStyle(color: AppColor(theme).black, fontSize: 16, fontFamily: FontResoft.sourceSansPro, package: FontResoft.package),
                ),
                subtitle: Text(
                  filteredContacts[index].phone ?? 'No phone',
                  style: TextStyle(color: AppColor(theme).black, fontSize: 14, fontFamily: FontResoft.sourceSansPro, package: FontResoft.package),
                ),
                onTap: () {
                  saveContact(filteredContacts[index]);
                  addFirebaseContact(
                    userId: uid,
                    name: filteredContacts[index].name!,
                    phoneNumber: filteredContacts[index].phone!,
                  );

                  replace(context, Constants.contacts);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<ContactModel?> _fetchContactFromDevice() async {
    final PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      final Iterable<Contact> deviceContacts = await ContactsService.getContacts(
        withThumbnails: false,
        iOSLocalizedLabels: false,
        androidLocalizedLabels: false,
        photoHighResolution: false,
      );

      if (deviceContacts.isNotEmpty) {
        final newContacts = deviceContacts.map(
          (contact) {
            return ContactModel(
              name: contact.displayName ?? 'No Name',
              phone: contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? 'No Phone Number' : 'No Phone Number',
            );
          },
        ).toList();

        setState(() {
          contacts.clear();
          contacts.addAll(newContacts);
          filteredContacts = contacts;
        });
      } else {
        // No contacts found
        ScaffoldX(sKey: key).toast('No Contacts Found');
      }
    } else {
      // Handle the case where the user denies permission
      // You might want to display a message or request permission again
      ScaffoldX(sKey: key).toast('Permission Denied. \nPlease grant permission to access contacts.');
    }

    return null;
  }

  void _searchForContact(BuildContext context) {
    showSearch(
      context: context,
      delegate: ContactSearch(contacts),
    ).then((selectedContact) {
      if (selectedContact != null) {
        ref.watch(contactModelProvider.notifier).addContact(selectedContact);
        saveContact(selectedContact);
        addFirebaseContact(userId: uid, name: selectedContact.name!, phoneNumber: selectedContact.phone!);
        replace(context, Constants.contacts);
      }
    });
  }
}

class ContactDetailPage extends StatelessWidget {
  final ContactModel contact;

  const ContactDetailPage(this.contact, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${contact.name}'),
            Text('Phone Number: ${contact.phone}'),
            //Text('Phone Number: ${contact.phone}'),
          ],
        ),
      ),
    );
  }
}
