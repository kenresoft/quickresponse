import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRequest {
  String requestId;
  String senderId;
  String receiverId;
  String status;
  DateTime timestamp;

  ChatRequest({
    required this.requestId,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.timestamp,
  });

  factory ChatRequest.fromMap(Map<String, dynamic> data, String documentId) {
    return ChatRequest(
      requestId: documentId,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: data['status'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
