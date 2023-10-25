import 'package:quickresponse/main.dart';

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

class CustomMessageGeneratorPage extends ConsumerStatefulWidget {
  const CustomMessageGeneratorPage({super.key});

  @override
  ConsumerState<CustomMessageGeneratorPage> createState() => _CustomMessageGeneratorPageState();
}

class _CustomMessageGeneratorPageState extends ConsumerState<CustomMessageGeneratorPage> {
  final TextEditingController _customMessageController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> key = GlobalKey<ScaffoldMessengerState>();
  List<CustomMessage> savedMessages = [];
  String selectedMessage = '';
  final Uuid _uuid = const Uuid();
  (int, CustomMessage)? editMessage;
  bool isEditMode = false;
  final FocusNode _focusNode = FocusNode();
  bool isWheelOpen = false;

  void toggleWheel() {
    setState(() {
      isWheelOpen = !isWheelOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    final textFieldDirection = ref.watch(textFieldDirectionProvider.select((value) => value));
    if (savedMessages.isEmpty) {
      SharedPreferencesService.remove('sosMessage');
    }
    return WillPopScope(
      onWillPop: () async {
        if (isEditMode && editMessage != null) {
          ScaffoldX(sKey: key).toast('Edit Mode is ON!', TextAlign.center, Colors.amber);
          return false;
        } else {
          return true;
        }
      },
      child: ScaffoldX(
        focusNode: _focusNode,
        sKey: key,
        backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
        appBar: CustomAppBar(
          leadingColor: AppColor(theme).navIconSelected,
          title: const Text('SOS Message Generator', style: TextStyle(fontSize: 20)),
          actionTitle: '',
          actionIcon: null,
        ),
        onPressed1: () => exportMessages(),
        onPressed2: () => importMessages(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            const Text('Choose from Pre-made Messages:', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 50,
              decoration: BoxDecoration(color: AppColor(theme).white, border: Border.all(color: AppColor(theme).border), borderRadius: BorderRadius.circular(40)),
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all<Color>(AppColor(theme).alert_1),
                ),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      elevation: 0,
                      dropdownColor: AppColor(theme).white,
                      borderRadius: BorderRadius.circular(12),
                      underline: Container(),
                      style: TextStyle(color: AppColor(theme).alert_2, fontSize: 16, fontFamily: FontResoft.sourceSansPro, package: FontResoft.package),
                      menuMaxHeight: 450,
                      hint: Text(
                        'Select Message',
                        style: TextStyle(color: AppColor(theme).black, fontSize: 16, fontFamily: FontResoft.sourceSansPro, package: FontResoft.package),
                      ),
                      iconSize: 30,
                      value: selectedMessage.isNotEmpty ? selectedMessage : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          if (isEditMode && editMessage != null) {
                            savedMessages.insert(editMessage!.$1, editMessage!.$2);
                            _customMessageController.clear();
                            editMessage = null;
                            isEditMode = false;
                          } else {
                            selectedMessage = newValue ?? '';
                            _customMessageController.text = newValue ?? '';
                          }
                        });
                      },
                      // H: CONSTANTS
                      items: Constants.emergencyMessages.map((String message) {
                        return DropdownMenuItem<String>(
                          value: message,
                          child: Text(message),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Or Create Your Own Message:', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 70,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: TextField(
                  maxLength: 100,
                  maxLines: textFieldDirection == TextFieldDirection.vertical ? 2 : 1,
                  focusNode: _focusNode,
                  controller: _customMessageController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                    fillColor: AppColor(theme).white,
                    filled: true,
                    focusColor: AppColor(theme).white,
                    prefixIconColor: AppColor(theme).navIconSelected,
                    suffixIconColor: AppColor(theme).navIconSelected,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: AppColor(theme).border)),
                    hintText: 'Type your custom message here',
                    suffixIcon: GestureDetector(
                      onTap: isEditMode
                          ? () => setState(() {
                                if (editMessage != null) {
                                  savedMessages.insert(editMessage!.$1, editMessage!.$2);
                                  _customMessageController.clear();
                                  editMessage = null;
                                  isEditMode = false;
                                } else {
                                  _customMessageController.clear();
                                }
                              })
                          : null,
                      child: const Icon(Icons.clear, size: 20),
                    ),
                  ),
                ),
              ),
            ),
            // H: SAVE CUSTOM MESSAGE BUTTON
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
              SizedBox(
                width: 0.4.dpW(dp),
                child: OutlinedButton(
                  style: ButtonStyle(side: MaterialStatePropertyAll(BorderSide(color: AppColor(theme).alert_1))),
                  onPressed: () {
                    if (savedMessages.length < maxMessageAllowed) {
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
                            editMessage = null;
                            isEditMode = false;
                          });
                          saveMessage(newMessage);
                        } else {
                          // Show a notification that the message is already saved.
                          ScaffoldX(sKey: key).toast('This message is already saved.', TextAlign.center, Colors.blue);
                        }

                        _customMessageController.clear();
                      }
                    } else {
                      // Show a message indicating the maximum limit has been reached.
                      ScaffoldX(sKey: key).toast('Maximum limit of $maxMessageAllowed messages reached.', TextAlign.center, Colors.redAccent);
                    }
                  },
                  child: const Text('Save Custom Message', textAlign: TextAlign.center),
                ),
              ),
              // H: SAVE SELECTED MESSAGE BUTTON
              SizedBox(
                width: 0.4.dpW(dp),
                child: OutlinedButton(
                  style: ButtonStyle(side: MaterialStatePropertyAll(BorderSide(color: AppColor(theme).alert_1))),
                  onPressed: () {
                    if (savedMessages.length < maxMessageAllowed) {
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
                            selectedMessage = ''; // Reset selected message
                            editMessage = null;
                            isEditMode = false;
                          });
                          saveMessage(newMessage);
                        } else {
                          // Show a notification that the message is already saved.
                          ScaffoldX(sKey: key).toast('This message is already saved.', TextAlign.center, Colors.blue);
                        }

                        _customMessageController.clear();
                      }
                    } else {
                      // Show a message indicating the maximum limit has been reached.
                      ScaffoldX(sKey: key).toast('Maximum limit of $maxMessageAllowed messages reached.', TextAlign.center, Colors.redAccent);
                    }
                  },
                  child: const Text('Save Selected Message', textAlign: TextAlign.center),
                ),
              ),
            ]),
            const SizedBox(height: 16.0),
            const Text('Saved Messages:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: savedMessages.length,
                itemBuilder: (context, index) {
                  final message = savedMessages[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                    color: AppColor(theme).white,
                    elevation: 0,
                    child: ListTile(
                      title: Text(message.message),
                      subtitle: Text(DateFormat.yMMMd().add_Hm().format(message.dateTime)),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: Icon(CupertinoIcons.pencil, color: AppColor(theme).title),
                          onPressed: !isEditMode
                              ? () {
                                  _customMessageController.text = message.message;
                                  setState(() {
                                    isEditMode = true;
                                    editMessage = (index, message);
                                    savedMessages.removeAt(index);
                                  });
                                  deleteMessages([message.id]);
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(CupertinoIcons.delete_simple, size: 18, color: AppColor(theme).navIconSelected),
                          onPressed: () {
                            showDeleteConfirmationDialog(context, index, message, theme);
                          },
                        ),
                      ]),
                      onTap: () {
                        // Navigate to edit message screen.
                      },
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customMessageController.dispose();
    super.dispose();
  }

  bool isOverlayVisible = false;

  void toggleOverlay() {
    setState(() {
      isOverlayVisible = !isOverlayVisible;
    });
  }

  Future<void> initPrefs() async {
    fetchSavedMessages();
  }

  void fetchSavedMessages() {
    final savedMessagesJson = SharedPreferencesService.getStringList('savedMessages') ?? [];

    if (savedMessagesJson.isEmpty) {
      // Handle the case when there are no saved messages
      ScaffoldX(sKey: key).toast('No messages', TextAlign.center, Colors.blue);
      return;
    }
    if (savedMessagesJson.length > maxMessageAllowed) {
      savedMessagesJson.removeRange(0, savedMessagesJson.length - maxMessageAllowed);
    }

    setState(() {
      savedMessages = savedMessagesJson.map((jsonString) {
        try {
          // Parse each JSON string into a CustomMessage
          final json = jsonDecode(jsonString);
          return CustomMessage.fromJson(json);
        } catch (e) {
          // Handle any JSON parsing errors
          'Error parsing saved message: $e'.log;
          fetchBackupMessages();
          return CustomMessage(
            id: '',
            message: 'Invalid Message', // You can customize this error message
            dateTime: DateTime.now(),
          );
        }
      }).toList();
    });
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context, int index, CustomMessage message, bool theme) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
          title: const Text('Confirm Deletion'),
          content: const SingleChildScrollView(
            child: ListBody(children: <Widget>[
              Text('Are you sure you want to delete this message?'),
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  savedMessages.removeAt(index);
                });
                deleteMessages([message.id]);

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchBackupMessages() async {
    final savedMessagesJson = SharedPreferencesService.getStringList('savedMessages') ?? [];
    savedMessagesJson.log;
    final List<dynamic> messagesJson = jsonDecode(savedMessagesJson.toString());
    messagesJson.log;
    setState(() {
      savedMessages = messagesJson.map((json) {
        return CustomMessage.fromJson(jsonDecode(json));
      }).toList();
    });
  }

  String cleanContent(String content) {
    // Remove the escaped double quotes
    content = content.replaceAll('\\"', '"');
    content = content.replaceAll('\\\\', '\\');
    // Remove the first line from the content
    final lines = LineSplitter.split(content).skip(1);
    content = lines.join('\n');
    // Remove special characters using a regular expression
    content = content.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
    content = content.replaceAll('"{', '{');
    content = content.replaceAll('}"', '}');
    return content;
  }

  void saveMessage(CustomMessage message) async {
    final savedMessagesJson = savedMessages.map((message) {
      return jsonEncode(message.toJson());
    }).toList();
    SharedPreferencesService.setStringList('savedMessages', savedMessagesJson);
  }

  void deleteMessages(List<String> idsToDelete) {
    setState(() {
      savedMessages.removeWhere((message) => idsToDelete.contains(message.id));
    });
    saveMessageListToPrefs(savedMessages);
  }

  void saveMessageListToPrefs(List<CustomMessage> messages) async {
    final savedMessagesJson = messages.map((message) {
      return jsonEncode(message.toJson());
    }).toList();
    SharedPreferencesService.setStringList('savedMessages', savedMessagesJson);
  }

  Future<void> exportMessages() async {
    final messagesJson = savedMessages.map((message) {
      return jsonEncode(message.toJson());
    }).toList();

    final directory = await getExternalStorageDirectory();
    const fileName = 'emg_messages.qrs';
    final file = File('${directory!.path}/$fileName');
    await file.writeAsString(Constants.fileComment + jsonEncode(messagesJson));

    ScaffoldX(sKey: key).toast('Messages exported successfully to: ${file.path}', TextAlign.center, Colors.green);
  }

  Future<void> importMessages() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: "Select a .qrs file",
    );

    if (result != null && result.files.isNotEmpty) {
      final File file = File(result.files.first.path!);
      final String filePath = file.path;
      final String fileName = filePath.split('/').last;

      if (!fileName.endsWith('.qrs')) {
        ScaffoldX(sKey: key).toast('Invalid file extension. Please select a .qrs file.', TextAlign.center, Colors.redAccent);
        return;
      }

      try {
        String content = await file.readAsString();
        content = cleanContent(content);
        final List<dynamic> messagesJson = jsonDecode(content);

        final List<CustomMessage> importedMessages = messagesJson.map((json) {
          return CustomMessage.fromJson(json);
        }).toList();

        final List<String> importedIds = importedMessages.map((message) => message.id).toList();
        final List<CustomMessage> updatedMessages = savedMessages.where((message) => !importedIds.contains(message.id)).toList();

        updatedMessages.addAll(importedMessages);

        setState(() {
          savedMessages = updatedMessages;
          selectedMessage = ''; // Reset selected message
        });

        saveMessageListToPrefs(savedMessages);

        ScaffoldX(sKey: key).toast('Messages imported successfully.', TextAlign.center, Colors.green);
      } catch (e) {
        'Error importing messages: $e'.log;
        ScaffoldX(sKey: key).toast('Error importing messages. Please check the file format.', TextAlign.center, Colors.redAccent);
      }
    }
  }
}
