import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../data/constants/colors.dart';
import '../../data/constants/constants.dart';
import '../../data/model/contact.dart';
import '../../main.dart';
import '../../services/firebase/firebase_contact.dart';
import '../../services/firebase/firebase_profile.dart';
import '../../utils/file_helper.dart';
import '../../utils/wrapper.dart';
import '../../widgets/appbar.dart';

// ... (other imports and constants)

class EditContactPage extends StatefulWidget {
  final ContactModel contact;

  const EditContactPage({super.key, required this.contact});

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController nameController;
  late TextEditingController relationshipController;
  late TextEditingController phoneController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  String? imageFile; // Added to hold the selected image file
  File? mImageFile;
  bool isLoading = false; // Define the isLoading variable

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    relationshipController = TextEditingController(text: widget.contact.relationship ?? '');
    phoneController = TextEditingController(text: widget.contact.phone);
    ageController = TextEditingController(text: widget.contact.age?.toString() ?? '');
    heightController = TextEditingController(text: widget.contact.height?.toString() ?? '');
    weightController = TextEditingController(text: widget.contact.weight?.toString() ?? '');
    // Set the initial value of imageFile based on the widget.contact
    imageFile = widget.contact.imageFile;
  }

  @override
  void dispose() {
    nameController.dispose();
    relationshipController.dispose();
    phoneController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Widget _customTextField(TextEditingController controller, String labelText, TextInputType keyboardType, String hintText, IconData? prefixIcon) {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          Icon(prefixIcon ?? Icons.edit, color: AppColor.navIconSelected),
          const SizedBox(width: 10), // Add spacing between icon and text field
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                fillColor: AppColor.white,
                filled: true,
                focusColor: AppColor.white,
                prefixIcon: null,
                // Remove the default prefix icon
                suffixIcon: Icon(
                  CupertinoIcons.check_mark_circled, // You can change this to the desired Cupertino icon
                  color: AppColor.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: AppColor.text),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: AppColor.text),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to pick an image file
  Future<void> pickImageFile() async {
    setState(() {
      isLoading = true; // Set isLoading to true when loading starts
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      PlatformFile file = result.files.single;
      final uniqueFileName = FileHelper.generateUniqueFileName(phoneController.text);

      // Compress the image before saving it
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path!,
        FileHelper.getTempFilePath(uniqueFileName),
        quality: 20,
      );

      final savedFilePath = await FileHelper.saveImageFile(compressedFile!.path, uniqueFileName);

      // Delete the previous image file if it exists
      if (imageFile != null) {
        final previousFile = File(imageFile!);
        if (previousFile.existsSync()) {
          previousFile.deleteSync();
        }
      }

      setState(() {
        imageFile = savedFilePath;
        isLoading = false; // Set isLoading to false when loading is complete
      });
    } else {
      setState(() {
        isLoading = false; // Set isLoading to false if the user canceled image picking
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //FileHelper.file(widget.contact.imageFile).then((file) => mImageFile = file);
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: appBar(
        title: const Text('Edit Contact', style: TextStyle(fontSize: 20)),
        actionTitle: 'SAVE',
        actionIcon: CupertinoIcons.checkmark_seal,
        onActionClick: () {
          saveEditedContact();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 0,
          color: AppColor.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: pickImageFile,
                    child: imageFile == null
                        ? profilePicture(widget.contact.imageFile, isLoading: isLoading) // Use the initial image if imageFile is null
                        : profilePicture(imageFile!, isLoading: isLoading, overlay: true),
                  ),
                  const SizedBox(height: 80),
                  _customTextField(nameController, 'Name', TextInputType.text, 'Enter name', CupertinoIcons.person),
                  const SizedBox(height: 20),
                  _customTextField(relationshipController, 'Relationship', TextInputType.text, 'Enter relationship', CupertinoIcons.dot_radiowaves_left_right),
                  const SizedBox(height: 20),
                  _customTextField(phoneController, 'Phone', TextInputType.phone, 'Enter phone', CupertinoIcons.phone),
                  const SizedBox(height: 20),
                  _customTextField(ageController, 'Age', TextInputType.number, 'Enter age', CupertinoIcons.time),
                  const SizedBox(height: 20),
                  _customTextField(heightController, 'Height (cm)', TextInputType.number, 'Enter height', CupertinoIcons.resize_v),
                  const SizedBox(height: 20),
                  _customTextField(weightController, 'Weight (kg)', TextInputType.number, 'Enter weight', CupertinoIcons.lab_flask),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveEditedContact() {
    final String editedName = nameController.text;
    final String editedRelationship = relationshipController.text;
    final String editedPhone = phoneController.text;
    final int? editedAge = int.tryParse(ageController.text);
    final int? editedHeight = int.tryParse(heightController.text);
    final int? editedWeight = int.tryParse(weightController.text);

    final updatedContact = ContactModel(
      name: editedName,
      relationship: editedRelationship,
      phone: editedPhone,
      age: editedAge,
      height: editedHeight,
      weight: editedWeight,
      imageFile: imageFile, // Pass the selected image to the ContactModel
    );

    updateEditedContact(updatedContact);
    getProfileInfoFromSharedPreferences().then(
      (profileInfo) => updateFirebaseContact(
        userId: profileInfo.uid!,
        name: updatedContact.name!,
        phoneNumber: updatedContact.phone!,
        relationship: updatedContact.relationship!,
        age: updatedContact.age.toString(),
      ),
    );
    // After saving, you can use Navigator.pop() to return to the previous screen,
    // passing the updated contact as a result.
    //Navigator.pop(context, updatedContact);
    replace(context, Constants.contactDetails, updatedContact);
  }
}
