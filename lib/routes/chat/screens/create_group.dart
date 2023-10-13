import 'package:quickresponse/main.dart';
import 'package:quickresponse/routes/chat/service.dart';

import '../model.dart';
import 'helper.dart';

class CreateGroupScreen extends StatelessWidget {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController = TextEditingController();
  final TextEditingController _groupIdController = TextEditingController();

  CreateGroupScreen({super.key}); // New controller for manual group ID input

  void _createGroup(String userId) {
    String groupId;
    if (_groupIdController.text.isEmpty) {
      groupId = generateRandomGroupId(); // Generate random group ID
    } else {
      groupId = _groupIdController.text; // Use manual group ID if provided
    }

    String groupName = _groupNameController.text;
    String groupDescription = _groupDescriptionController.text;
    Group newGroup = Group(
      groupId: groupId,
      groupName: groupName,
      groupDescription: groupDescription,
      adminId: userId,
      members: [userId],
      adminIds: [userId],
    );
    createGroup(newGroup); // Call Firestore function to create a new group
  }

  @override
  Widget build(BuildContext context) {
    String userId = getCurrentUserId(); // Get the current user's ID

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => launch(context, '/cs'), child: const Text('Create Group')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(labelText: 'Group Name'),
            ),
            TextField(
              controller: _groupDescriptionController,
              decoration: const InputDecoration(labelText: 'Group Description'),
            ),
            TextField(
              controller: _groupIdController,
              decoration: const InputDecoration(labelText: 'Group ID (Optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createGroup(userId),
              child: const Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
