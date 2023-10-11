import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class NewChatScreen extends StatefulWidget {
  final String userId;

  const NewChatScreen({super.key, required this.userId});

  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> selectedContacts = []; // Store selected contact IDs
  List<DocumentSnapshot> searchResults = []; // Store search results

// Function to search for contacts
// /users/userId/emergencyContacts/contact
/*  void searchContacts(String query) async {
    final CollectionReference userContactsCollection = FirebaseFirestore.instance.collection('users/${widget.userId}/emergencyContacts');

    final QuerySnapshot querySnapshot = await userContactsCollection.where('name', isGreaterThanOrEqualTo: query).where('name', isLessThanOrEqualTo: '$query\uf8ff').get();

    setState(() {
      searchResults = querySnapshot.docs;
    });
  }

  // Function to toggle contact selection
  void toggleContactSelection(String contactId) {
    setState(() {
      if (selectedContacts.contains(contactId)) {
        selectedContacts.remove(contactId);
      } else {
        selectedContacts.add(contactId);
      }
    });
  }*/

  // Function to create a new chat with selected contacts
  void _createChat() async {
    //if (selectedContacts.isNotEmpty) {
    try {
      //String selectedContactUserId = selectedContacts.first; // Assuming you select only one contact

      // Sort user IDs to ensure consistency
      List<String> sortedUserIds = [widget.userId, 'selectedContactUserId']..sort();

      // Create a unique chat ID based on sorted user IDs
      String uniqueChatId = 'abc'; /*sortedUserIds.join('_');*/

      // Check if a chat with the selected contact already exists
      final DocumentSnapshot chatSnapshot = await FirebaseFirestore.instance.collection('chats').doc(uniqueChatId).get();

      if (chatSnapshot.exists) {
        // If a chat already exists, navigate to the existing chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: uniqueChatId,
              userId: widget.userId,
              receiverId: 'selectedContactUserId', // Pass the receiver's user ID
            ),
          ),
        );
      } else {
        // If no chat exists, create a new chat
        final DocumentReference newChatRef = FirebaseFirestore.instance.collection('chats').doc(uniqueChatId);

        Map<String, dynamic> chatData = {
          'members': sortedUserIds,
          'last_message': '',
          'timestamp': FieldValue.serverTimestamp(),
        };

        await newChatRef.set(chatData);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: uniqueChatId,
              userId: widget.userId,
              receiverId: 'selectedContactUserId', // Pass the receiver's user ID
            ),
          ),
        );
      }
    } catch (e) {
      print('Error creating/navigating to chat: $e');
    }
  }

/*  void _createChat() async {
    if (selectedContacts.isNotEmpty) {
      try {
        // Sort the selected contact IDs to ensure consistency
        selectedContacts.sort();

        // Create a new chat document in Firestore
        final DocumentReference newChatRef = FirebaseFirestore.instance.collection('chats').doc();

        // Prepare the chat data
        Map<String, dynamic> chatData = {
          'members': [widget.userId, ...selectedContacts],
          'last_message': '',
          'timestamp': FieldValue.serverTimestamp(),
        };

        // Set the chat data in the Firestore document
        await newChatRef.set(chatData);

        // Navigate to the ChatScreen with the chat ID and user IDs
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: newChatRef.id,
              userId: widget.userId,
              // Pass selectedContacts if you need them in the ChatScreen
              selectedContacts: selectedContacts,
            ),
          ),
        );
      } catch (e) {
        // Handle any errors here
        print('Error creating chat: $e');
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                //searchContacts(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search for contacts...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                var contactData = searchResults[index].data() as Map<String, dynamic>;
                String contactId = searchResults[index].id;
                String contactName = contactData['name'];

                return ListTile(
                  title: Text(contactName),
                  trailing: selectedContacts.contains(contactId) ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                  onTap: () {
                    //toggleContactSelection(contactId);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createChat,
        child: const Icon(Icons.check),
      ),
    );
  }
}
