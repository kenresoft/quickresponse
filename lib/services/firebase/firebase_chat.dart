import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_profile.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> createMessage(String chatId, String senderId, String text) async {
  try {
    final CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages').doc(chatId).collection('messages');

    await messagesCollection.add({
      'sender_id': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(), // Server timestamp
    });
  } catch (e) {
    // Handle any errors here
    print('Error creating message: $e');
  }
}

Stream<QuerySnapshot>  getMessagesStream(String chatId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: false) // Change to true if you want latest messages first
      .snapshots();
}

Future<void> createChat(String chatId, List<String> members) async {
  try {
    final CollectionReference chatsCollection = FirebaseFirestore.instance.collection('chats');

    await chatsCollection.doc(chatId).set({
      'members': members,
      'last_message': '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    // Handle any errors here
    print('Error creating chat: $e');
  }
}

Future<DocumentSnapshot?> getChatMetadata(String chatId) async {
  try {
    final DocumentReference chatDocument = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return await chatDocument.get();
  } catch (e) {
    // Handle any errors here
    print('Error getting chat metadata: $e');
    return null;
  }
}

Future<Stream<QuerySnapshot>> getMessages(String userId, String receiverId) async {
  final user = await getProfileInfoFromSharedPreferences();
  String chatId = generateChatId(userId, receiverId); // Generate a chatId based on userIds

  if (user.uid == userId) {
    return _firestore.collection('chats').doc(chatId).collection('messages').orderBy('timestamp').snapshots();
  } else {
    return _firestore.collection('chats').doc(chatId).collection('messages').orderBy('timestamp').snapshots();
  }
}

String generateChatId(String userId1, String userId2) {
  List<String> users = [userId1, userId2];
  users.sort(); // Sort user IDs to ensure consistency
  return "${users[0]}_${users[1]}"; // You can customize the chatId format if needed
}

Future<void> updateMessage(String userId, String receiverId, String messageId, Map<String, dynamic> updatedMessageData) async {
  await _firestore.collection('chats').doc('chatId').collection('chat').doc(receiverId).collection('messages').doc(messageId).update(updatedMessageData);
}

Future<void> deleteMessage(String userId, String receiverId, String messageId) async {
  await _firestore.collection('chats').doc('chatId').collection('chat').doc(receiverId).collection('messages').doc(messageId).delete();
}
