import 'package:quickresponse/main.dart';
import 'model.dart';

Future<void> createGroup(Group group) async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('groups').doc(group.groupId).set(group.toJson());
}

Stream<List<Group>> getGroups() {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('groups').snapshots().map((querySnapshot) => querySnapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
}

/*Stream<List<Group>> getGroups() {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('groups').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final members = data['members'] != null ? (data['members'] as List).cast<String>() : [];
      final joinRequests = data['joinRequests'] != null ? (data['joinRequests'] as List).cast<String>() : [];

      return Group.fromJson(data..['members'] = members..['joinRequests'] = joinRequests);
    }).toList();
  });
}*/

// Get a group by ID
Future<Group?> getGroupById(String groupId) async {
  final firestore = FirebaseFirestore.instance;
  final groupDoc = await firestore.collection('groups').doc(groupId).get();
  if (groupDoc.exists) {
    return Group.fromJson(groupDoc.data() as Map<String, dynamic>);
  } else {
    return null;
  }
}

// Update a group
Future<void> updateGroup(Group group) async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('groups').doc(group.groupId).update(group.toJson());
}

// Delete a group
Future<void> deleteGroup(String groupId) async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('groups').doc(groupId).delete();
}

// Create a new chat message
Future<void> createChatMessage(Chat chat) async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('groups').doc(chat.groupId).collection('chats').doc(chat.chatId).set(chat.toJson());
}

// Get all chat messages in a group
Stream<List<Chat>> getChatMessagesByGroupId(String groupId) async* {
  final firestore = FirebaseFirestore.instance;
  final chatMessagesStream = firestore.collection('groups').doc(groupId).collection('chats').snapshots();
  await for (final chatMessagesSnapshot in chatMessagesStream) {
    yield chatMessagesSnapshot.docs.map((chatMessageDoc) => Chat.fromJson(chatMessageDoc.data())).toList();
  }
}

// Get a chat message by ID
Future<Chat?> getChatMessageById(String groupId, String chatId) async {
  final firestore = FirebaseFirestore.instance;
  final chatMessageDoc = await firestore.collection('groups').doc(groupId).collection('chats').doc(chatId).get();
  if (chatMessageDoc.exists) {
    return Chat.fromJson(chatMessageDoc.data() as Map<String, dynamic>);
  } else {
    return null;
  }
}

Future<void> sendJoinRequest(String groupId, String userId) async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('groups').doc(groupId).update({
    'joinRequests': FieldValue.arrayUnion([userId]),
  });
}

Future<ProfileInfo?> getUserProfileInfo(String uid) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).collection('profile').doc('profileInfo').get();

    if (userSnapshot.exists) {
      // User profile exists, parse the data and return a ProfileInfo object
      return ProfileInfo.fromJson(userSnapshot.data()!);
    } else {
      // User profile does not exist
      return null;
    }
  } catch (e) {
    // Handle any errors that occurred during the fetch operation
    'Error fetching user profile: $e'.log;
    return null;
  }
}

Stream<Group> getGroup(String groupId) {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('groups').doc(groupId).snapshots().map(
        (doc) => Group.fromJson(doc.data() as Map<String, dynamic>),
      );
}

Future<void> addGroupAdmin(String groupId, String memberId) async {
  await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
    'adminIds': FieldValue.arrayUnion([memberId]),
  });
}

Future<void> removeGroupMember(String groupId, String memberId) async {
  await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
    'members': FieldValue.arrayRemove([memberId]),
  });
}
