
import 'dart:ui';

import 'package:quickresponse/main.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome to Quick Response!',
      'description': 'Quick Response is your ultimate emergency companion. Sign in to access a wide range of emergency and security features.',
      'tip': 'Emergency Tip 1',
    },
    {
      'title': 'Stay Safe with Quick Response',
      'description': 'Our app is designed to help you during emergencies. Sign in now to explore its features and stay prepared.',
      'tip': 'Emergency Tip 2',
    },
    {
      'title': 'Title for Page 3',
      'description': 'Description for Page 3. Add your content here.',
      'tip': 'Security Tip 3',
    },
    {
      'title': 'Title for Page 4',
      'description': 'Description for Page 4. Add your content here.',
      'tip': 'Security Tip 4',
    },
  ];

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: CustomAppBar(
        title: const Text('Sign In', style: TextStyle(fontSize: 20)),
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: AppColor(theme).blend(const Image(image: ExactAssetImage(Constants.logo)), AppColor(theme).background),
        ),
        actionTitle: '',
        actionIcon: AppColor(theme).blend(const Icon(CupertinoIcons.person_crop_circle_badge_plus), AppColor(theme).black),
        onActionClick: () {
          context.toast('Authenticate to access the app');
        },
      ),*/
      body: Stack(
        children: [
          // Background Image with Blur
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(Constants.logo2, fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust blur intensity
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5), // Adjust opacity
            ),
          ),
          Column(
            children: [
              // PageView Carousel
              Expanded(
                child: PageView.builder(
                  itemCount: pages.length,
                  controller: PageController(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return _buildPage(page['title']!, page['description']!, page['tip']!);
                  },
                ),
              ),
              // Page Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? AppColor(theme).navIconSelected : AppColor(theme).black,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              // Sign-in Button
              ElevatedButton(
                onPressed: () => _signInCallback(context),
                child: const Text('Sign in with Google'),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ],
      ),
    );
  }

  void _signInCallback(BuildContext context) {
    signInWithGoogle().then(
      (user) {
        if (user != null) {
          saveUserProfileToFirestore(user).then((value) {
            user.log;
            launchReplace(context, Constants.home);
          }).error(context);
          uid = user.uid;
        }
      },
    );
  }

  Widget _buildPage(String title, String description, String tip) {
    return Container(
      child: Card(
        elevation: 0,
        color: Colors.white.withOpacity(0.7), // Adjust opacity as needed
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                leading: Image.asset(
                  Constants.logo, // Replace with your image path
                  width: 32.0, // Adjust image size as needed
                  height: 32.0,
                ),
                title: Text(tip),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

