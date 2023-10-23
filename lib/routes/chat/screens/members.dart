import 'package:quickresponse/main.dart';

import '../model.dart';
import '../service.dart';

class GroupMembersScreen extends StatefulWidget {
  final String groupId;
  final String currentUserId;

  const GroupMembersScreen({super.key, required this.groupId, required this.currentUserId});

  @override
  _GroupMembersScreenState createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  late Group _group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        leading: Icon(CupertinoIcons.increase_quotelevel, color: AppColor(theme).navIconSelected),
        title: const Text('Group Members', style: TextStyle(fontSize: 20)),
        actionTitle: '',
        actionIcon: null,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 16),
        child: StreamBuilder<Group>(
          stream: getGroup(widget.groupId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('Group not found.');
            } else {
              _group = snapshot.data!;
              bool isAdmin = _group.adminIds.contains(widget.currentUserId);
              bool isMainAdmin = _group.adminId.contains(widget.currentUserId);

              // Sort the members: current user first, followed by the main admin, then others.
              List<String> sortedMembers = [];
              sortedMembers.add(widget.currentUserId); // Add the current user first.

              if (!isMainAdmin) {
                // If the current user is an admin, add the main admin next.
                sortedMembers.add(_group.adminId);
              }

              // Add other members.
              sortedMembers.addAll(_group.members.where((member) => member != widget.currentUserId && member != _group.adminId));

              return isAdmin ? _buildAdminUI(sortedMembers) : _buildMemberUI(sortedMembers);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAdminUI(List<String> sortedMembers) {
    return ListView.builder(
      itemCount: sortedMembers.length,
      itemBuilder: (context, index) {
        String memberId = sortedMembers[index];
        Future<ProfileInfo?> memberProfileInfo = getUserProfileInfo(memberId);

        return FutureBuilder<ProfileInfo?>(
          future: memberProfileInfo,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // Handle the case when the user profile could not be fetched
              return const ListTile(title: Text('Unknown User.'));
            } else if (!snapshot.hasData || snapshot.data?.uid == null) {
              // Handle the case when the user profile could not be found
              return const SizedBox();
            } else {
              ProfileInfo memberInfo = snapshot.data!;
              bool isMainAdmin = _group.adminId == memberId;
              bool isAdmin = _group.adminIds.contains(memberId);
              bool isMainAdminUser = _group.adminId == widget.currentUserId;
              bool isAdminUser = _group.adminIds.contains(widget.currentUserId);

              return Card(
                elevation: 0,
                color: AppColor(theme).white,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 70,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Row(children: [
                      buildImage(memberInfo),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 100,
                        child: Text(maxLines: 3, overflow: TextOverflow.ellipsis, memberInfo.displayName ?? 'Unknown User....', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      if (isMainAdminUser)
                        if (!isMainAdmin && !isAdmin) IconButton(icon: const Icon(CupertinoIcons.person_add, color: Colors.green), onPressed: () => _addAdmin(memberId)),
                      if (!isMainAdmin && !isAdmin) IconButton(icon: const Icon(CupertinoIcons.xmark_rectangle, color: Colors.red), onPressed: () => _removeMember(memberId)),
                      if (!isMainAdmin && isAdmin) IconButton(icon: const Icon(CupertinoIcons.xmark_rectangle, color: Colors.red), onPressed: () => _removeMember(memberId)),
                      Text(isAdmin ? 'Admin   ' : 'Member', style: TextStyle(color: isMainAdmin ? Colors.red : Colors.blue, fontWeight: isMainAdmin ? FontWeight.bold : null)),
                    ])
                  ]),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildMemberUI(List<String> sortedMembers) {
    return Column(
      children: [
        const Text('Only admins can manage group members.'),
        Expanded(
          child: ListView.builder(
            itemCount: sortedMembers.length,
            itemBuilder: (context, index) {
              String memberId = sortedMembers[index];
              Future<ProfileInfo?> memberProfileInfo = getUserProfileInfo(memberId);

              return FutureBuilder<ProfileInfo?>(
                future: memberProfileInfo,
                builder: (context, snapshot) {
                  // Handle the case when the user profile could not be fetched
                  if (snapshot.hasError) {
                    // Handle the case when the user profile could not be fetched
                    return const ListTile(title: Text('Unknown User.'));
                  } else if (!snapshot.hasData || snapshot.data?.uid == null) {
                    // Handle the case when the user profile could not be found
                    return const SizedBox();
                  } else {
                    ProfileInfo memberInfo = snapshot.data!;
                    bool isMainAdmin = _group.adminId == memberId;
                    bool isAdmin = _group.adminIds.contains(memberId);
                    bool isAdminUser = _group.adminIds.contains(widget.currentUserId);

                    return Card(
                      elevation: 0,
                      color: AppColor(theme).white,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 70,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Row(children: [
                            buildImage(memberInfo),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 125,
                              child: Text(maxLines: 3, overflow: TextOverflow.ellipsis, memberInfo.displayName ?? 'Unknown User....', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            Text(isAdmin ? 'Admin   ' : 'Member', style: TextStyle(color: isMainAdmin ? Colors.red : Colors.blue, fontWeight: isMainAdmin ? FontWeight.bold : null)),
                          ])
                        ]),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _addAdmin(String memberId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Admin'),
          content: const Text('Are you sure you want to make this member an admin?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add Admin'),
              onPressed: () async {
                // Add the member as an admin
                await addGroupAdmin(widget.groupId, memberId);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeMember(String memberId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Member'),
          content: const Text('Are you sure you want to remove this member from the group?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () async {
                // Remove the member from the group
                await removeGroupMember(widget.groupId, memberId);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
