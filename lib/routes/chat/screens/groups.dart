import 'package:quickresponse/routes/chat/helper.dart';
import 'package:quickresponse/main.dart';
import '../model.dart';
import '../service.dart';
import 'group_chat.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final TextEditingController _groupIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        leading: Icon(CupertinoIcons.increase_quotelevel, color: AppColor(theme).navIconSelected),
        title: const Text('Groups', style: TextStyle(fontSize: 20)),
        actionTitle: '',
      ),
      body: StreamBuilder<List<Group>>(
        stream: getGroups(), // Stream of groups from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading indicator while data is being fetched
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No groups available.');
          } else {
            List<Group> groups = snapshot.data!;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                Group group = groups[index];
                bool isAdmin = group.adminId == getCurrentUserId();
                bool isGroupMember = group.members.contains(getCurrentUserId());

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: AppColor(theme).white,
                    elevation: 0,
                    child: ListTile(
                      title: Text(group.groupName),
                      subtitle: Text(group.groupDescription),
                      trailing: isAdmin
                          ? GestureDetector(
                              onTap: () {
                                // Handle admin logic to accept join requests
                                _handleJoinRequests(group);
                              },
                              child: Text('${group.joinRequests?.length ?? 0} Requests'))
                          : null,
                      onTap: () {
                        if (isGroupMember) {
                          // If user is a group member, navigate to the GroupChatScreen directly
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GroupChatScreen(groupId: group.groupId, userId: getCurrentUserId())),
                          );
                        } else {
                          if (isAdmin) {
                            // TODO:
                          } else {
                            // Non-admin user needs to enter group ID to join
                            _showJoinGroupDialog(group);
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _handleJoinRequests(Group group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join Requests'),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: group.joinRequests?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                String requesterId = group.joinRequests![index]; // Get the requester's ID
                return ListTile(
                  title: Text(requesterId),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          // Accept the join request
                          _acceptJoinRequest(group, requesterId);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Reject the join request
                          _rejectJoinRequest(group, requesterId);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _acceptJoinRequest(Group group, String requesterId) {
    // Implement logic to accept the join request
    // Add requesterId to group.members
    group.members.add(requesterId);

    // Remove requesterId from joinRequests list
    group.joinRequests?.remove(requesterId);

    // Update the group in the database
    updateGroup(group);

    // Optionally, you can notify the requester about the acceptance
  }

  void _rejectJoinRequest(Group group, String requesterId) {
    // Implement logic to reject the join request
    // Remove requesterId from joinRequests list
    group.joinRequests?.remove(requesterId);

    // Update the group in the database
    updateGroup(group);

    // Optionally, you can notify the requester about the rejection
  }

  Future<void> _showJoinGroupDialog(Group group) async {
    bool joinRequestSent = false;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Join Group'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _groupIdController,
                    decoration: const InputDecoration(hintText: 'Group ID'),
                  ),
                  ElevatedButton(
                    onPressed: joinRequestSent
                        ? null
                        : () async {
                            String enteredGroupId = _groupIdController.text.trim();
                            if (enteredGroupId.isNotEmpty && enteredGroupId == group.groupId) {
                              setState(() {
                                joinRequestSent = true;
                              });

                              // Send join request to the group
                              await sendJoinRequest(group.groupId, getCurrentUserId());

                              // Show a confirmation dialog
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Join Request Sent'),
                                    content: const Text('Your join request has been sent to the group admin.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop(); // Close the join group dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Incorrect group ID entered, show an error message
                              // For now, just close the dialog
                              Navigator.of(context).pop();
                            }
                          },
                    child: const Text('Join'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

/*Future<void> _showJoinGroupDialog(Group group) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Group ID'),
          content: TextField(
            controller: _groupIdController,
            decoration: const InputDecoration(hintText: 'Group ID'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Join'),
              onPressed: () {
                String enteredGroupId = _groupIdController.text.trim();
                if (enteredGroupId.isNotEmpty && enteredGroupId == group.groupId) {
                  // User entered correct group ID, navigate to GroupChatScreen
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupChatScreen(groupId: group.groupId, userId: getCurrentUserId())),
                  );
                } else {
                  // Incorrect group ID entered, show an error message or handle accordingly
                  // For now, just close the dialog
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }*/
}
