import 'package:quickresponse/main.dart';

class ChatListScreen extends StatefulWidget {
  final String userId;

  const ChatListScreen({super.key, required this.userId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').where('members', arrayContains: widget.userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // Display a list of chats with their last messages
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              var chatData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String chatId = snapshot.data!.docs[index].id;
              String lastMessage = chatData['last_message'];

              return ListTile(
                title: Text('Chat ID: $chatId'),
                subtitle: Text('Last message: $lastMessage'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId: chatId,
                        userId: widget.userId,
                        receiverId: 'RECEIVER_USER_ID_HERE', // Set the receiver's user ID here
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //launch(context, Constants.userSearchScreen);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewChatScreen(userId: widget.userId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
