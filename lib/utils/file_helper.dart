import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickresponse/imports.dart';
import 'package:quickresponse/utils/extensions.dart';

import '../data/constants/styles.dart';
import '../providers/settings/prefs.dart';

class FileHelper {
  static String getTempFilePath(String fileName) {
    final directory = Directory.systemTemp;
    return '${directory.path}/$fileName';
  }

  static Future<String?> saveImageFile(String sourceFilePath, String fileName) async {
    try {
      final appDirectory = await getExternalStorageDirectory();
      final imageDirectory = Directory('${appDirectory?.path}/contact_images');

      // Create the directory if it doesn't exist
      if (!imageDirectory.existsSync()) {
        imageDirectory.createSync(recursive: true);
      }

      final targetFilePath = '${imageDirectory.path}/$fileName';
      final targetFile = File(targetFilePath);

      // Delete the existing file if it exists
      if (targetFile.existsSync()) {
        targetFile.deleteSync();
      }

      final sourceFile = File(sourceFilePath);

      // Copy the source file to the target directory
      await sourceFile.copy(targetFilePath);

      // Delete the source file after copying
      sourceFile.deleteSync();

      return targetFilePath;
    } catch (e) {
      'Error saving image file: $e'.log;
      return null;
    }
  }

  static String generateUniqueFileName(String phoneNumber) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$phoneNumber-$timestamp.jpg'; // Use .jpg or the appropriate file extension
  }
}

Widget profilePicture(String? targetFile, {double? size, bool isLoading = false, bool overlay = false, Color? borderColor}) {
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor ?? AppColor(theme).text, width: 2.0),
          ),
          child: targetFile == null
              ? Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    FontAwesomeIcons.person, // Display a default icon if no image is selected
                    size: size != null ? size + size - 5 : 90,
                    color: AppColor(theme).navIconSelected,
                  ),
                )
              : CircleAvatar(radius: size ?? 50, backgroundImage: FileImage(File(targetFile))),
        ),
        overlay ? Icon(CupertinoIcons.camera, size: 48, color: AppColor(theme).white) : const SizedBox(),
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    ),
  );
}

extension FileManager on Directory {
  Future<String> mkdir(name) async {
    final Directory currentDirectory = Directory('$path/$name');

    if (await currentDirectory.exists()) {
      'Directory already exists: ${currentDirectory.path}'.log;
      return currentDirectory.path;
    } else {
      try {
        var directory = await currentDirectory.create(recursive: true);
        'Directory created: ${currentDirectory.path}'.log;
        return directory.path;
      } catch (e) {
        'Error creating directory: $e'.log;
        return path;
      }
    }
  }
}
