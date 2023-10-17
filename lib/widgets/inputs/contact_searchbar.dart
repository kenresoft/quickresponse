/*
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:quickresponse/utils/wrapper.dart';

import '../data/constants/styles.dart';
import '../data/constants/constants.dart';
import '../data/model/contact.dart';
import '../utils/density.dart';

class ContactSearchBar extends ConsumerStatefulWidget {
  final Function(ContactModel) onSelected;
  final FocusNode focusNode;

  const ContactSearchBar({
    Key? key,
    required this.onSelected,
    required this.focusNode,
  }) : super(key: key);

  @override
  ConsumerState<ContactSearchBar> createState() => _ContactSearchBarState();
}

class _ContactSearchBarState extends ConsumerState<ContactSearchBar> {
  final TextEditingController _controller = TextEditingController();
  String _searchTerm = '';
  List<ContactModel> _filteredContacts = [];
  List<ContactModel> _kContacts = [];
  late Future<List<ContactModel>> _contacts;

  @override
  void initState() {
    super.initState();
    _contacts = loadContacts();
    _searchTerm = _controller.text;
    //_filteredContacts = _contacts;
    */
/*_controller.addListener(() {
      setState(() {
        _searchTerm = _controller.text;
        _filteredContacts = _contacts.where((contact) => contact.toLowerCase().contains(_searchTerm.toLowerCase())).toList();
      });
    });*//*

  }

  @override
  void dispose() {
    super.dispose();
  }

  void _deleteContact(int index) {
    setState(() {
      _filteredContacts.removeAt(index);
      _kContacts = _filteredContacts;
    });
    setContacts(_kContacts);
    //ref.watch(contactModelProvider.notifier).setContact(_filteredContacts);
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return ;
  }
}
*/
