import 'package:quickresponse/main.dart';

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
  late List<ContactModel> _contacts;
  SortOrder _sortOrder = SortOrder.ascending;
  int _contactCount = 0;
  File? mImageFile;

  @override
  void initState() {
    super.initState();
    _contacts = loadContacts();

    // You can also update _filteredContacts with the initial data from SharedPreferences
    setState(() {
      _filteredContacts = _contacts;
      _kContacts = _filteredContacts;
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
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
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
      deleteContact(contactToDelete);
      deleteFirebaseContact(userId: uid, phoneNumber: contactToDelete.phone!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    _contactCount = _kContacts.length;

    return WillPopScope(
      onWillPop: () async {
        launch(context, Constants.home);
        return false;
      },
      child: focus(
        _focusNode,
        Scaffold(
          backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
          appBar: CustomAppBar(
            title: const Text('Contacts', style: TextStyle(fontSize: 20)),
            leading: const LogoCard(),
            actionTitle: 'ADD',
            actionIcon: Icons.add,
            onActionClick: () {
              if (_contactCount < 5) {
                launch(context, Constants.contactsPage);
              } else {
                context.toast('Contact Limit Reached.\nYou cannot add more than 5 contacts.', TextAlign.center, AppColor(theme).alert_1);
              }
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Flexible(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      textAlign: TextAlign.center,
                      autofillHints: _kContacts.map((e) => e.name!),
                      maxLines: textFieldDirection == TextFieldDirection.vertical ? 2 : 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        fillColor: AppColor(theme).white,
                        filled: true,
                        focusColor: AppColor(theme).white,
                        prefixIconColor: AppColor(theme).navIconSelected,
                        suffixIconColor: AppColor(theme).navIconSelected,
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: AppColor(theme).border)),
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
                  IconButton(icon: const Icon(CupertinoIcons.sort_down, size: 24), onPressed: _sortContacts),
                ]),
              ),
              0.025
                  .dpH(dp)
                  .spY,
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredContacts.length,
                  itemBuilder: (context, index) {
                    //FileHelper.file(_filteredContacts[index].imageFile).then((file) => mImageFile = file);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                      color: AppColor(theme).white,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [
                            profilePicture(_filteredContacts[index].imageFile, size: 25),
                            //const Image(image: ExactAssetImage(Constants.moon), height: 50),
                            0.02
                                .dpW(dp)
                                .spX,
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              SizedBox(
                                width: dp.width - 218,
                                child: Text(_filteredContacts[index].name ?? 'Name not defined', style: TextStyle(fontWeight: FontWeight.w600, color: AppColor(theme).black)),
                              ),
                              Text(_filteredContacts[index].phone?.trim() ?? 'No phone', style: TextStyle(fontSize: 13, color: AppColor(theme).alert_2)),
                              Text(_filteredContacts[index].relationship ?? '-', style: TextStyle(fontSize: 13, color: AppColor(theme).black)),
                              Text(_filteredContacts[index].age.let((it) => it ?? '-').toString(), style: TextStyle(fontSize: 13, color: AppColor(theme).black)),
                            ]),
                          ]),
                          InkWell(
                            onTap: () => launch(context, Constants.editContactPage, _filteredContacts[index]),
                            splashColor: AppColor(theme).overlay,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(padding: const EdgeInsets.all(14), child: Icon(CupertinoIcons.pen, size: 18, color: AppColor(theme).navIconSelected)),
                          ),
                          InkWell(
                            onTap: () => _deleteContact(index),
                            splashColor: AppColor(theme).overlay,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(padding: const EdgeInsets.all(14), child: Icon(CupertinoIcons.delete_simple, size: 18, color: AppColor(theme).navIconSelected)),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
          bottomNavigationBar: bottomNavigator(context, 2),
        ),
      ),
    );
  }
}

enum SortOrder { ascending, descending }
