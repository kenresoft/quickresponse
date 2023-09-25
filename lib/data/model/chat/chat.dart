import 'chat_message.dart';

class Chat {
  final String chatId;
  final List<Message> messages;

  Chat({
    required this.chatId,
    required this.messages,
  });
}
