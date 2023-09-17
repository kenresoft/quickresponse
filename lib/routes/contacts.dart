import 'dart:io';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/model/contact.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:quickresponse/widgets/appbar.dart';

import '../data/constants/colors.dart';
import '../providers/page_provider.dart';
import '../utils/density.dart';
import '../utils/file_helper.dart';
import '../utils/wrapper.dart';
import '../widgets/bottom_navigator.dart';

class Contacts extends ConsumerStatefulWidget {
  const Contacts({super.key});

  @override
  ConsumerState<Contacts> createState() => _ContactsState();
}

class _ContactsState extends ConsumerState<Contacts> {
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _controller = TextEditingController();
  String _searchTerm = '';
  List<ContactModel> _filteredContacts = [];
  List<ContactModel> _kContacts = [];
  late Future<List<ContactModel>> _contacts;
  SortOrder _sortOrder = SortOrder.ascending;
  bool _isLoading = false; // Add this variable to track loading state
  int _contactCount = 0;
  File? mImageFile;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _startLoading(); // Start loading when initializing
    _contacts = loadContacts().whenComplete(() {
      _stopLoading(); // Stop loading when data is fetched
    });

    // You can also update _filteredContacts with the initial data from SharedPreferences
    _contacts.then((contacts) {
      setState(() {
        _filteredContacts = contacts;
        _kContacts = _filteredContacts;
      });
    });

    _searchTerm = _controller.text;
  }

  void _sortContacts() {
    setState(() {
      if (_sortOrder == SortOrder.ascending) {
        _filteredContacts.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        _sortOrder = SortOrder.descending;
      } else {
        _filteredContacts.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
        _sortOrder = SortOrder.ascending;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    saveContacts(_kContacts);
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _removeContact(index);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _removeContact(int index) {
    setState(() {
      final contactToDelete = _filteredContacts[index];
      _filteredContacts.removeAt(index);
      _kContacts = _filteredContacts;
      updateContact(contactToDelete);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final contacts = ContactModel.contactList;
    final dp = Density.init(context);
    final page = ref.watch(pageProvider.select((value) => value));
    _contactCount = _kContacts.length;

    return WillPopScope(
      onWillPop: () async {
        bool isLastPage = page.isEmpty;
        if (isLastPage) {
          setContacts(_kContacts);
          launch(context, Constants.home);
          return false;
          //return (await showAnimatedDialog(context))!;
        } else {
          setContacts(_kContacts);
          launch(context, page.last);
          ref.watch(pageProvider.notifier).setPage = page..remove(page.last);
          return true;
        }
      },
      child: focus(
        _focusNode,
        Scaffold(
          backgroundColor: AppColor.background,
          appBar: appBar(
            title: const Text('Contacts', style: TextStyle(fontSize: 20)),
            leading: const Icon(CupertinoIcons.increase_quotelevel),
            actionTitle: 'ADD',
            actionIcon: Icons.add,
            onActionClick: () {
              if (_contactCount < 5) {
                launch(context, Constants.contactsPage);
              } else {
                context.toast('Contact Limit Reached.\nYou cannot add more than 5 contacts.', TextAlign.center, AppColor.alert_1);
              }
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _controller,
                          textAlign: TextAlign.center,
                          autofillHints: _kContacts.map((e) => e.name!),
                          decoration: InputDecoration(
                            fillColor: AppColor.white,
                            filled: true,
                            focusColor: AppColor.white,
                            prefixIconColor: AppColor.navIconSelected,
                            suffixIconColor: AppColor.navIconSelected,
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: AppColor.action)),
                            hintText: 'Search',
                            prefixIcon: const Icon(CupertinoIcons.search, size: 20),
                            suffixIcon: const Icon(CupertinoIcons.mic, size: 20),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchTerm = value;
                              _filteredContacts = _kContacts.where((contact) => contact.name!.toLowerCase().contains(_searchTerm.toLowerCase())).toList();
                            });
                          },
                        ),
                      ),
                      Row(children: [const SizedBox(width: 15), Text(_sortOrder != SortOrder.ascending ? 'ASC ' : 'DESC')]),
                      IconButton(
                        icon: const Icon(CupertinoIcons.sort_down, size: 24),
                        onPressed: _sortContacts,
                      ),
                    ],
                  ),
                ),
                0.025.dpH(dp).spY,
                _isLoading // Display loading indicator based on the loading state
                    ? const Center(child: CircularProgressIndicator()) // Use CircularProgressIndicator or any other loading indicator
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredContacts.length,
                          itemBuilder: (context, index) {
                            /*_contactCount = ref.watch(contactCountProvider.select((value) => value));
                            if (_contactCount != _filteredContacts.length) {
                              Future(() => ref.watch(contactCountProvider.notifier).setCurrent = _filteredContacts.length);
                            }*/
                            //FileHelper.file(_filteredContacts[index].imageFile).then((file) => mImageFile = file);
                            return GestureDetector(
                              onTap: () {
                                launch(context, Constants.contactDetails, _filteredContacts[index]);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                                color: AppColor.white,
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Row(children: [
                                      profilePicture(_filteredContacts[index].imageFile, size: 25),
                                      //const Image(image: ExactAssetImage(Constants.moon), height: 50),
                                      0.02.dpW(dp).spX,
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(_filteredContacts[index].name ?? 'Name not defined', style: const TextStyle(fontWeight: FontWeight.w600)),
                                        Text(_filteredContacts[index].phone ?? 'Undefined', style: const TextStyle(fontSize: 13)),
                                      ]),
                                    ]),
                                    InkWell(
                                      onTap: () => _deleteContact(index),
                                      splashColor: AppColor.overlay,
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child: Icon(CupertinoIcons.delete_simple, size: 18, color: AppColor.navIconSelected),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavigator(currentIndex: 2),
        ),
      ),
    );
  }
}

enum SortOrder { ascending, descending }
