import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/firebase/firebase_chat.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userId;
  final String receiverId; // Add receiverId

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.userId,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getMessagesStream('abc'),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Display chat messages using ListView.builder
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    var messageData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    String messageText = messageData['text'];
                    String senderId = messageData['sender_id'];

                    // Customize message display based on sender (e.g., different colors for own messages)
                    bool isOwnMessage = senderId == widget.userId;

                    return MessageBubble(
                      message: messageText,
                      isOwnMessage: isOwnMessage,
                    );
                  },
                );
              },
            ),
          ),
          // Text input and send button
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(hintText: 'Type a message...'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Implement your message sending function here
  void sendMessage() async {
    String text = messageController.text.trim();
    try {
      // Create a new message document
      final CollectionReference messagesCollection = FirebaseFirestore.instance.collection('chats').doc(widget.chatId).collection('messages');

      await messagesCollection.add({
        'text': text,
        'sender_id': widget.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the 'last_message' field in the chat document
      await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({'last_message': text});

      // Clear the message input field

      if (text.isNotEmpty) {
        createMessage(widget.chatId, widget.userId, text);
        messageController.clear();
      }
    } catch (e) {
      // Handle any errors here
      print('Error sending message: $e');
    }
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isOwnMessage;

  const MessageBubble({Key? key, required this.message, required this.isOwnMessage}) : super(key: key);

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
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

String _formatTimestamp(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate();
  final String timeString = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  return timeString;
}

