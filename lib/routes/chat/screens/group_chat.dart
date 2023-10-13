import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickresponse/main.dart';

import '../../../data/model/chat/chat.dart' as c;
import '../model.dart';
import '../service.dart';
import 'helper.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String userId;

  const GroupChatScreen({super.key, required this.groupId, required this.userId});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => launch(context, '/m', (widget.groupId, widget.userId)), child: const Text('Group Chat')),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('groups').doc(widget.groupId).collection('chats').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    var messageData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    String messageText = messageData['message'];
                    String senderId = messageData['senderId'];
                    Timestamp timestamp = messageData['timestamp'] as Timestamp;
                    bool isOwnMessage = senderId == widget.userId;

                    return MessageBubble(
                      message: messageText,
                      isOwnMessage: isOwnMessage,
                      time: _formatTimestamp(timestamp),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      Chat chatMessage = Chat(
        chatId: generateRandomMessageId(widget.userId),
        groupId: widget.groupId,
        senderId: widget.userId,
        message: messageText,
        timestamp: Timestamp.now(),
      );
      createChatMessage(chatMessage);
      _messageController.clear();
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final String timeString = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return timeString;
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isOwnMessage;
  final String time;

  const MessageBubble({super.key, required this.message, required this.isOwnMessage, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isOwnMessage ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
