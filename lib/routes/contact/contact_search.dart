import 'package:quickresponse/main.dart';

class ContactSearch extends SearchDelegate<ContactModel> {
  final List<ContactModel> contacts;

  ContactSearch(this.contacts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(CupertinoIcons.clear),
        onPressed: () {
          query = '';
          FocusManager.instance.primaryFocus!.unfocus();
        },
      ),
      const SizedBox(width: 5)
    ];
  }

  @override
  void showResults(BuildContext context) {}

  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: const Icon(CupertinoIcons.chevron_left), onPressed: () => finish(context));

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: theme ? Brightness.light : Brightness.dark,
      fontFamily: FontResoft.sourceSansPro,
      package: FontResoft.package,
      inputDecorationTheme: InputDecorationTheme(
        constraints: const BoxConstraints(maxHeight: 46),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        fillColor: AppColor(theme).white,
        filled: true,
        focusColor: AppColor(theme).white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: AppColor(theme).border)),
        hintStyle: TextStyle(color: AppColor(theme).title),
        labelStyle: TextStyle(color: AppColor(theme).title),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 2,
        iconTheme: IconThemeData(color: AppColor(theme).navIconSelected),
        titleTextStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColor(theme).title),
        centerTitle: true,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ContactModel> suggestionList;
    if (query.isEmpty) {
      suggestionList = contacts;
    } else {
      suggestionList = contacts.where((contact) => contact.name!.toLowerCase().contains(query.toLowerCase()) || contact.phone!.contains(query)).toList();
    }

    return Container(
      color: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
            color: AppColor(theme).white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                suggestionList[index].name ?? 'No name',
                style: TextStyle(color: AppColor(theme).black, fontSize: 16, fontFamily: FontResoft.sourceSansPro, package: FontResoft.package),
              ),
              subtitle: Text(
                suggestionList[index].phone ?? 'No phone',
                style: TextStyle(color: AppColor(theme).black, fontSize: 14, fontFamily: FontResoft.sourceSansPro, package: FontResoft.package),
              ),
              onTap: () => close(context, suggestionList[index]),
            ),
          );
        },
      ),
    );
  }
}
