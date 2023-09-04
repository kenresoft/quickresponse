import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/data/constants/constants.dart';

import '../utils/density.dart';
import '../data/model/contact.dart';

class ContactSearchBar extends StatefulWidget {
  final List<Contact> contacts;
  final Function(Contact) onSelected;

  const ContactSearchBar({Key? key, required this.contacts, required this.onSelected}) : super(key: key);

  @override
  State<ContactSearchBar> createState() => _ContactSearchBarState();
}

class _ContactSearchBarState extends State<ContactSearchBar> {
  final TextEditingController _controller = TextEditingController();
  String _searchTerm = '';
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _searchTerm = _controller.text;
    _filteredContacts = widget.contacts;
    /*_controller.addListener(() {
      setState(() {
        _searchTerm = _controller.text;
        _filteredContacts = widget.contacts.where((contact) => contact.toLowerCase().contains(_searchTerm.toLowerCase())).toList();
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              autofillHints: widget.contacts.map((e) => e.name!),
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
                  _filteredContacts = widget.contacts.where((contact) => contact.name!.toLowerCase().contains(_searchTerm.toLowerCase())).toList();
                });
              },
            ),
          ),
          0.025.dpH(dp).spY,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.onSelected(_filteredContacts[index]);
                  },
                  child: Card(
                    color: AppColor.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(children: [
                          const Image(image: ExactAssetImage(Constants.moon), height: 50),
                          0.02.dpW(dp).spX,
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(_filteredContacts[index].name ?? 'Name not defined', style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(_filteredContacts[index].relationship ?? 'Undefined', style: const TextStyle(fontSize: 13)),
                          ]),
                        ]),
                        Icon(Icons.arrow_forward, size: 15, color: AppColor.navIconSelected)
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
