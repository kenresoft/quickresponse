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
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        leading: Icon(CupertinoIcons.captions_bubble, color: AppColor(theme).navIconSelected),
        title: GestureDetector(child: const Text('Group Chat', style: TextStyle(fontSize: 20))),
        actionTitle: 'Participants',
        onActionClick: () => launch(context, '/m', (widget.groupId, widget.userId)),
        //actionIcon: CupertinoIcons.person_3_fill,
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('groups').doc(widget.groupId).collection('chats').orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No messages available.'));
              }

              // Extract chat messages from snapshot
              List<Map<String, dynamic>> messages = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

              // Group chat messages by date
              Map<String, List<Map<String, dynamic>>> groupedMessages = groupChatMessagesByDate(messages);

              return ListView.separated(
                reverse: true,
                physics: const ClampingScrollPhysics(),
                itemCount: groupedMessages.length,
                separatorBuilder: (context, index) => Divider(color: AppColor(theme).overlay, thickness: 1),
                itemBuilder: (context, index) {
                  String formattedDate = groupedMessages.keys.elementAt(index);
                  List<Map<String, dynamic>> messagesForDate = groupedMessages[formattedDate]!;

                  return Column(
                    children: [
                      // Display date as a header
                      Container(
                        decoration: BoxDecoration(color: AppColor(theme).overlay.withAlpha(30), borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(8),
                        child: Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      // Display chat messages for the date
                      ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: messagesForDate.length,
                        itemBuilder: (context, index) {
                          var messageData = messagesForDate[index];
                          String messageText = messageData['message'];
                          String senderId = messageData['senderId'];
                          Timestamp timestamp = messageData['timestamp'] as Timestamp;
                          bool isOwnMessage = senderId == widget.userId;

                          String? nextSenderId;
                          if (index < messagesForDate.length - 1) {
                            nextSenderId = messagesForDate[index + 1]['senderId'];
                          }

                          return FutureBuilder<ProfileInfo?>(
                            future: getUserProfileInfo(senderId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                // Handle the case when the user profile could not be fetched
                                return const ListTile(title: Text('Unknown User.'));
                              } else if (!snapshot.hasData || snapshot.data?.uid == null) {
                                // Handle the case when the user profile could not be found
                                return const SizedBox();
                              } else {
                                ProfileInfo memberInfo = snapshot.data!;
                                // Build your MessageBubble widget here using messageData
                                return MessageBubble(
                                  message: messageText,
                                  isOwnMessage: isOwnMessage,
                                  sender: memberInfo,
                                  time: _formatTimestamp(timestamp),
                                  previousSenderId: nextSenderId,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            margin: EdgeInsets.zero,
            color: AppColor(theme).white,
            elevation: 0,
            child: ListTile(
              subtitle: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 5,
                //maxLines: textFieldDirection == TextFieldDirection.vertical ? 2 : 1,
                //maxLength: 500,
                cursorOpacityAnimates: true,
                cursorWidth: 1,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  fillColor: AppColor(theme).white,
                  filled: true,
                  focusColor: AppColor(theme).white,
                  prefixIconColor: AppColor(theme).navIconSelected,
                  suffixIconColor: AppColor(theme).navIconSelected,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColor(theme).alertBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColor(theme).navIconSelected)),
                ),
              ),
              trailing: IconButton(icon: Icon(CupertinoIcons.square_arrow_right, color: AppColor(theme).navIconSelected), onPressed: _sendMessage),
            ),
          ),
        ),
      ]),
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
    //final String timeString = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return formatTime(dateTime, timeFormat);
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final ProfileInfo sender;
  final bool isOwnMessage;
  final String time;
  final String? previousSenderId;

  const MessageBubble({super.key, required this.message, required this.sender, required this.isOwnMessage, required this.time, required this.previousSenderId});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5).copyWith(left: isOwnMessage ? 120 : 10, right: !isOwnMessage ? 120 : 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(color: isOwnMessage ? Colors.red.shade300 /*AppColor(theme).bubble_1*/ : Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Visibility(
            visible: previousSenderId != sender.uid,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(width: 20, height: 20, child: buildImage(sender)),
              const SizedBox(width: 5),
              Text(trim(getFirstName(sender.displayName!), 25), style: TextStyle(color: isOwnMessage ? Colors.red.shade900 : Colors.grey.shade900 /*Colors.white60*/, fontWeight: FontWeight.bold)),
            ]),
          ),
          Text(message, style: TextStyle(color: AppColor(theme).black)),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(color: Colors.white /*Colors.white54*/, fontSize: 12)),
        ]),
      ),
    );
  }
}

Map<String, List<Map<String, dynamic>>> groupChatMessagesByDate(List<Map<String, dynamic>> messages) {
  Map<String, List<Map<String, dynamic>>> groupedMessages = {};

  for (var message in messages) {
    Timestamp timestamp = message['timestamp'] as Timestamp;
    DateTime messageDate = timestamp.toDate();
    String formattedDate = formatDate(messageDate, dateFormat);

    if (!groupedMessages.containsKey(formattedDate)) {
      groupedMessages[formattedDate] = [];
    }

    groupedMessages[formattedDate]!.add(message);
  }

  return groupedMessages;
}
