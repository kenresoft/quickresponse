import 'package:quickresponse/main.dart';
import 'package:quickresponse/providers/note_provider.dart';

import '../../widgets/dialogs/html_dialog.dart';
import '../../widgets/display/custom_expansion_card.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  //late InternetConnection internetConnection;
  late TextEditingController _aboutMeController;
  final FocusNode _focusNode = FocusNode();
  late ProfileInfo profileInfo;

  @override
  void initState() {
    super.initState();
    _aboutMeController = TextEditingController(text: note);
    profileInfo = getProfileInfoFromSharedPreferences();
    //internetConnection = InternetConnection();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    //internetConnection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => replace(context, Constants.home),
      child: focus(
        _focusNode,
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
          appBar: CustomAppBar(
            title: const Text('User Account', style: TextStyle(fontSize: 20)),
            leading: const LogoCard(),
            actionTitle: '',
            action2: GestureDetector(
              onTap: () => isSignedIn() ? _showSignOutConfirmationDialog(context, theme) : launchReplace(context, Constants.authentication),
              child: Transform.rotate(angle: pi / 2, child: Icon(CupertinoIcons.share, color: AppColor(theme).navIconSelected)),
            ),
          ),
          body: Center(
            child: Container(
              height: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: theme ? AppColor(theme).white : AppColor(theme).black, borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(color: theme ? AppColor(theme).background : AppColor(theme).backgroundDark, borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: theme ? AppColor(theme).background : AppColor(theme).backgroundDark, borderRadius: BorderRadius.circular(15)),
                      //margin: const EdgeInsets.all(2),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        buildImage(profileInfo, theme),
                        const SizedBox(height: 16),
                        buildCard(CupertinoIcons.person, 'Name', profileInfo.displayName!, theme),
                        const SizedBox(height: 16),
                        buildCard(CupertinoIcons.mail, 'Email', profileInfo.email!, theme),
                        const SizedBox(height: 16),
                        buildPhoneCard(CupertinoIcons.phone, 'Phone', profileInfo.phoneNumber ?? '', theme),
                        const SizedBox(height: 16),
                        buildCard(
                          CupertinoIcons.staroflife,
                          'Profile Status',
                          profileInfo.isComplete.let(
                            (it) => it == true
                                ? 'Complete'
                                : profileInfo.phoneNumber == null
                                    ? 'Not complete\nNo phone number provided'
                                    : 'Not complete',
                          ),
                          theme,
                        ),
                        const SizedBox(height: 16),
                        buildNoteCard(),
                        /*const SizedBox(height: 16),
                        InkWell(
                          onTap: () => launch(context, Constants.settings),
                          child: buildCard(CupertinoIcons.settings, 'Settings', 'View App Settings', theme),
                        ),*/
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => launch(context, Constants.faq),
                          child: buildCard(CupertinoIcons.question_circle, 'FAQ', 'View App Settings', theme),
                        ),
                        const SizedBox(height: 16),

                        InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => const HTMLDialog(
                              htmlAsset1: 'assets/data/quickresponse_policies.html', // Path to your HTML asset file 1
                              htmlAsset2: 'assets/data/quickresponse_terms.html', // Path to your HTML asset file 2
                            ),
                          ),
                          child: buildCard(CupertinoIcons.padlock, 'Terms and Policy', 'View App Privacy Policy & Terms', theme),
                        ),
                        const SizedBox(height: 8),

                        CustomExpansionCard(
                          title: 'About App',
                          content: 'Stay Safe with Quick Response\n'
                              '-------------------------------------\n'
                              'Quick Response is your ultimate emergency companion where you can access a range of emergency and security features.'
                              '\n'
                              'It is designed to help you during emergencies. Explore its features and stay prepared!'
                              '\n\n'
                              'Version: ${1.0}'
                              '\n\n'
                              '© ${DateTime.now().year}, SharpResponse Tech.',
                          subTitle: 'View About App',
                          iconData: CupertinoIcons.device_phone_portrait,
                        ),

                        /*Center(
                          child: ElevatedButton(
                            style: const ButtonStyle(surfaceTintColor: MaterialStatePropertyAll(Colors.white)),
                            onPressed: () => phoneEditDialog(context, profileInfo),
                            child: const Text('Change Phone Number'),
                          ),
                        ),*/
                        const SizedBox(height: 16),
                        // Add current location and app usage summary widgets here
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card buildNoteCard() {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColor(theme).white,
      elevation: 0,
      child: Center(
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            bool isEditing = ref.watch(profileNoteProvider.select((value) => value));
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Take Note',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              leading: GestureDetector(
                onTap: () {
                  if (isEditing) note = _aboutMeController.text;

                  ref.watch(profileNoteProvider.notifier).editNote = !isEditing;
                  _focusNode.requestFocus();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Blink(
                    isNotText: true,
                    child: Icon(
                      isEditing ? CupertinoIcons.check_mark : CupertinoIcons.pencil_ellipsis_rectangle,
                      color: AppColor(theme).navIconSelected,
                      size: 30,
                    ),
                  ),
                ),
              ),
              subtitle: condition(
                isEditing,
                TextField(
                  controller: _aboutMeController,
                  focusNode: _focusNode,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 500,
                  cursorOpacityAnimates: true,
                  cursorWidth: 1,
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (value) {
                    if (isEditing) note = value;
                  },
                ),
                Text(note, style: const TextStyle(fontSize: 16.0)),
              ),
              trailing: InkWell(
                onTap: shareNote,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FaIcon(FontAwesomeIcons.share, size: 20, color: AppColor(theme).navIconSelected),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void shareNote() {
    if (note.isNotEmpty) {
      ///Share.share(note, subject: 'Emergency Alerts - Export');
    } else {
      context.toast('Note is empty!', TextAlign.center, Colors.red.shade300, Colors.white);
    }
  }

  void phoneEditDialog(BuildContext context, ProfileInfo profileInfo) {
    TextEditingController newPhoneNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
          title: Text('Update Phone Number', style: TextStyle(color: AppColor(theme).title)),
          content: SizedBox(
            height: 50,
            child: TextField(
              controller: newPhoneNumberController, // Use TextEditingController here
              decoration: InputDecoration(
                labelText: 'New Phone Number',
                labelStyle: TextStyle(color: AppColor(theme).title_2),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColor(theme).action)),
                //fillColor: AppColor(theme).background,
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                String newPhoneNumber = newPhoneNumberController.text; // Get text from TextEditingController
                if (newPhoneNumber.trim().isNotEmpty) {
                  bool isProfileComplete = newPhoneNumber.isNotEmpty; // Update the logic for isProfileComplete as needed
                  updatePhoneNumberInSharedPreferences(newPhoneNumber, isProfileComplete);
                  updateUserProfile(profileInfo.uid!, {'phoneNumber': newPhoneNumber, 'isComplete': isProfileComplete});
                  setState(() {});
                  Navigator.of(context).pop();
                } else {
                  // Handle empty phone number case if necessary
                  context.toast('Phone can\'t be empty!', TextAlign.center, Colors.red.shade300, Colors.white);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget buildImage(ProfileInfo profileInfo, bool theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: CircleAvatar(
          radius: 60.6,
          backgroundColor: AppColor(theme).alert_2,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: AppColor(theme).white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: profileInfo.photoURL!,
                placeholder: (context, url) => buildIcon,
                errorWidget: (context, url, error) => Icon(CupertinoIcons.exclamationmark_triangle, color: AppColor(theme).action),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get buildIcon => Icon(CupertinoIcons.info, size: 60, color: AppColor(theme).navIconSelected);

  Card buildCard(IconData iconData, String title, String subTitle, bool theme) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColor(theme).white,
      elevation: 0,
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Padding(padding: const EdgeInsets.only(left: 16), child: Icon(iconData, color: AppColor(theme).navIconSelected, size: 30)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1, // Limit to a single line
          ),
          subtitle: Text(subTitle),
        ),
      ),
    );
  }

  Card buildPhoneCard(IconData iconData, String title, String subTitle, bool theme) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColor(theme).white,
      elevation: 0,
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: GestureDetector(
              onTap: () => phoneEditDialog(context, profileInfo),
              child: Blink(isNotText: true, child: Icon(iconData, color: AppColor(theme).navIconSelected, size: 30)),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1, // Limit to a single line
          ),
          subtitle: Text(subTitle),
        ),
      ),
    );
  }

  Future<void> _showSignOutConfirmationDialog(BuildContext context, bool theme) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                BuildContext currentContext = context; // Capture the current context
                Navigator.of(currentContext).pop(); // Use the captured context
                signOut().then((_) {});
                Future(() => launchReplace(currentContext, Constants.authentication));
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
