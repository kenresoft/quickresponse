import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String groupId;
  String groupName;
  String groupDescription;
  String adminId;
  List<String> members;
  List<String>? joinRequests; // List of user IDs requesting to join the group
  List<String> adminIds; // List of admin user IDs

  Group({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.adminId,
    required this.members,
    this.joinRequests,
    required this.adminIds,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    groupId: json['groupId'],
    groupName: json['groupName'],
    groupDescription: json['groupDescription'],
    adminId: json['adminId'],
    members: (json['members'] as List).cast<String>(),
    joinRequests: (json['joinRequests'] as List?)?.cast<String>(),
    adminIds: (json['adminIds'] as List).cast<String>(), // Parse adminIds from JSON
  );

  Map<String, dynamic> toJson() => {
    'groupId': groupId,
    'groupName': groupName,
    'groupDescription': groupDescription,
    'adminId': adminId,
    'members': members,
    'joinRequests': joinRequests,
    'adminIds': adminIds, // Include adminIds in JSON representation
  };
}


class Chat {
  String chatId;
  String groupId;
  String senderId;
  String message;
  Timestamp timestamp;

  Chat({
    required this.chatId,
    required this.groupId,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatId: json['chatId'],
        groupId: json['groupId'],
        senderId: json['senderId'],
        message: json['message'],
        timestamp: Timestamp.fromDate(DateTime.parse(json['timestamp'])),
      );

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'groupId': groupId,
        'senderId': senderId,
        'message': message,
        'timestamp': timestamp,
      };
}

/*class Chat {
  String chatId;
  String groupId;
  String senderId;
  String message;
  Timestamp timestamp;

  Chat({
    required this.chatId,
    required this.groupId,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    chatId: json['chatId'],
    groupId: json['groupId'],
    senderId: json['senderId'],
    message: json['message'],
    timestamp: json['timestamp'], // No need to parse here, assuming it's a Timestamp from Firestore
  );

  Map<String, dynamic> toJson() => {
    'chatId': chatId,
    'groupId': groupId,
    'senderId': senderId,
    'message': message,
    'timestamp': timestamp, // No need to format here, assuming it's a Timestamp
  };
}*/
