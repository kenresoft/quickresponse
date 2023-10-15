import 'package:quickresponse/main.dart';
class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
  TextEditingController phoneNumberController = TextEditingController();
  List<String> phoneNumbersToSearch = ['123456'];
  List<String> matchingUserIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                hintText: 'Enter phone number to search',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: searchUsersByPhoneNumbers,
            child: const Text('Search Users'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: matchingUserIds.length,
              itemBuilder: (BuildContext context, int index) {
                String userId = matchingUserIds[index];
                return ListTile(
                  title: Text('User ID: $userId'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> getDocumentIdsFromCollection(String collectionName) async {
    List<String> documentIds = [];
    QuerySnapshot querySnapshot = await _collectionReference.get();
    context.toast(querySnapshot.docs);

    try {
      for (var doc in querySnapshot.docs.log) {
        // Add the document ID to the list
        doc.log;
        documentIds.add(doc.id.log);
        doc.id.log;
      }
    } catch (e) {
      print("Error getting document IDs: $e");
    }

    return documentIds;
  }

  Future<List<String>> searchUsersByPhoneNumbers() async {
    List<String> matchingUserUIDs = [];
    //var pr = await getProfileInfoFromSharedPreferences();
    List<String> userDocumentIds = await getDocumentIdsFromCollection('users');

    try {
      for (var user in userDocumentIds) {
        context.toast('- $user - ');
        QuerySnapshot querySnapshot = await _collectionReference.doc(user).collection('profile').where('phoneNumber', isEqualTo: '123456').get();
        if (querySnapshot.docs.isNotEmpty) {
          context.toast('isNotEmpty');
          matchingUserUIDs.add(user);
        }
        context.toast(' - $user - ${querySnapshot.docs}');
      }
      //}

      // matchingUserUIDs now contains the UIDs of users with matching phone numbers
      return matchingUserUIDs;
    } catch (e) {
      // Handle any errors here
      print('Error searching for users by phone numbers: $e');
      return matchingUserUIDs;
    }
  }
/*void searchUsers() async {
    String phoneNumberToSearch = phoneNumberController.text.trim();
    if (phoneNumberToSearch.isNotEmpty) {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('/users')
          .get();

      List<String> matchingIds = [];

      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        String uid = userSnapshot.id;
        String userPhoneNumber = userData['profile']['profileInfo']['phoneNumber'];

        if (userPhoneNumber == phoneNumberToSearch) {
          matchingIds.add(uid);
        }
      }

      setState(() {
        matchingUserIds = matchingIds;
      });
    }
  }*/
}
