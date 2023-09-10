import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    home: CustomMessageGeneratorPage(),
  ));
}

class CustomMessage {
  final String id;
  String message;
  final DateTime dateTime;

  CustomMessage({
    required this.id,
    required this.message,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory CustomMessage.fromJson(Map<String, dynamic> json) {
    return CustomMessage(
      id: json['id'],
      message: json['message'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}

class CustomMessageGeneratorPage extends StatefulWidget {
  @override
  _CustomMessageGeneratorPageState createState() => _CustomMessageGeneratorPageState();
}

class _CustomMessageGeneratorPageState extends State<CustomMessageGeneratorPage> {
  final TextEditingController _customMessageController = TextEditingController();
  List<CustomMessage> savedMessages = [];
  String selectedMessage = '';
  late SharedPreferences _prefs;
  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    initPrefs();
    fetchSavedMessages();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchSavedMessages() async {
    final savedMessagesJson = _prefs.getStringList('savedMessages') ?? [];
    setState(() {
      savedMessages = savedMessagesJson.map((json) {
        return CustomMessage.fromJson(jsonDecode(json));
      }).toList();
    });
  }

  Future<void> saveMessage(CustomMessage message) async {
    final savedMessagesJson = savedMessages.map((message) {
      return jsonEncode(message.toJson());
    }).toList();
    await _prefs.setStringList('savedMessages', savedMessagesJson);
  }

  Future<void> deleteMessages(List<String> idsToDelete) async {
    setState(() {
      savedMessages.removeWhere((message) => idsToDelete.contains(message.id));
    });
    await saveMessageListToPrefs(savedMessages);
  }

  Future<void> saveMessageListToPrefs(List<CustomMessage> messages) async {
    final savedMessagesJson = messages.map((message) {
      return jsonEncode(message.toJson());
    }).toList();
    await _prefs.setStringList('savedMessages', savedMessagesJson);
  }

  Future<void> exportMessages() async {
    final messagesJson = savedMessages.map((message) {
      return jsonEncode(message.toJson());
    }).toList();

    final directory = await getExternalStorageDirectory();
    final fileName = 'custom_messages.msg';
    final file = File('${directory!.path}/$fileName');

    await file.writeAsString(jsonEncode(messagesJson));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Messages exported successfully.'),
      ),
    );
  }

  Future<void> importMessages() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['msg'],
    );

    if (result != null && result.files.isNotEmpty) {
      final File file = File(result.files.first.path!);
      final String content = await file.readAsString();

      final List<dynamic> messagesJson = jsonDecode(content);

      final List<CustomMessage> importedMessages = messagesJson.map((json) {
        return CustomMessage.fromJson(json);
      }).toList();

      final List<String> importedIds = importedMessages.map((message) => message.id).toList();
      final List<CustomMessage> updatedMessages = savedMessages.where((message) => !importedIds.contains(message.id)).toList();

      updatedMessages.addAll(importedMessages);

      setState(() {
        savedMessages = updatedMessages;
      });

      await saveMessageListToPrefs(savedMessages);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Messages imported successfully.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Message Generator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Choose from Pre-made Messages:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedMessage.isNotEmpty ? selectedMessage : null,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMessage = newValue ?? '';
                  _customMessageController.text = newValue ?? '';
                });
              },
              items: emergencyMessages.map((String message) {
                return DropdownMenuItem<String>(
                  value: message,
                  child: Text(message),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Or Create Your Own Message:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _customMessageController,
              decoration: InputDecoration(
                labelText: 'Custom Message',
                hintText: 'Type your custom message here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (_customMessageController.text.isNotEmpty) {
                      final newMessage = CustomMessage(
                        id: _uuid.v4(),
                        message: _customMessageController.text,
                        dateTime: DateTime.now(),
                      );

                      final isMessageAlreadySaved = savedMessages.any((message) => message.message == newMessage.message);
                      if (!isMessageAlreadySaved) {
                        setState(() {
                          savedMessages.add(newMessage);
                        });
                        saveMessage(newMessage);
                      } else {
                        // Show a notification that the message is already saved.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('This message is already saved.'),
                          ),
                        );
                      }

                      _customMessageController.clear();
                    }
                  },
                  child: Text('Save Custom Message'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedMessage.isNotEmpty) {
                      final newMessage = CustomMessage(
                        id: _uuid.v4(),
                        message: selectedMessage,
                        dateTime: DateTime.now(),
                      );

                      final isMessageAlreadySaved = savedMessages.any((message) => message.message == newMessage.message);
                      if (!isMessageAlreadySaved) {
                        setState(() {
                          savedMessages.add(newMessage);
                        });
                        saveMessage(newMessage);
                      } else {
                        // Show a notification that the message is already saved.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('This message is already saved.'),
                          ),
                        );
                      }

                      _customMessageController.clear();
                    }
                  },
                  child: Text('Save Selected Message'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Saved Messages:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: savedMessages.length,
              itemBuilder: (context, index) {
                final message = savedMessages[index];
                return ListTile(
                  title: Text(message.message),
                  subtitle: Text(DateFormat.yMMMd().add_Hm().format(message.dateTime)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _customMessageController.text = message.message;
                          setState(() {
                            savedMessages.removeAt(index);
                          });
                          deleteMessages([message.id]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            savedMessages.removeAt(index);
                          });
                          deleteMessages([message.id]);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to edit message screen.
                  },
                );
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: exportMessages,
                  child: Text('Export Messages (.msg)'),
                ),
                ElevatedButton(
                  onPressed: importMessages,
                  child: Text('Import Messages (.msg)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final List<String> emergencyMessages = [
    "I'm in danger, please help!",
    "Emergency, call 911!",
    "I need immediate assistance!",
    "Send help, it's an emergency!",
    "I'm hurt, call an ambulance!",
    "Fire emergency, call the firefighters!",
    "Please come quickly, it's urgent!",
    "Burglary in progress, call the police!",
    "Medical emergency, call for help!",
    "I'm lost and need assistance!",
    "I've been in an accident, call the authorities!",
    "There's a dangerous situation, help!",
    "Call the emergency services, I'm in trouble!",
    "Urgent help required, call now!",
    "This is an emergency situation, please respond!",
  ];

  @override
  void dispose() {
    _customMessageController.dispose();
    super.dispose();
  }
}
