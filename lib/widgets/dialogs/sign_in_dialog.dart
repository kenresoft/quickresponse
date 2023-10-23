import 'package:quickresponse/main.dart';

class SignInDialog extends StatefulWidget {
  const SignInDialog({super.key, required this.action});

  final VoidCallback action;

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        isButtonDisabled = false;
        return true;
      },
      child: Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          InkWell(
            onTap: () => _signInCallback(context, () => widget.action()),
            child: Card(
              elevation: 1,
              color: AppColor(theme).white,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Row(children: [
                  SvgPicture.asset(Constants.google),
                  const SizedBox(width: 10),
                  const Text('To Continue..\nSign In with Google', style: TextStyle(fontSize: 20)),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      isButtonDisabled = true;
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        return user;
      }
      return null; // User canceled Google Sign-In
    } catch (error) {
      'Error signing in with Google: $error'.log;
      return null; // Handle error as needed
    }
  }

  void _signInCallback(BuildContext context, VoidCallback action) {
    Navigator.pop(context);
    signInWithGoogle().then(
      (user) {
        if (user != null) {
          saveUserProfileToFirestore(user).then((value) {
            user.log;
            action();
            isButtonDisabled = false;
          }).error(context);
          uid = user.uid;
        }
        isButtonDisabled = false;
      },
    );
  }
}

extension Er on Future {
  Future error(BuildContext context) {
    return catchError((error) {
      context.toast(error);
    });
  }
}
