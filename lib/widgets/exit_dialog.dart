import 'package:flutter/material.dart';

import '../data/constants/colors.dart';

/// EXIT DIALOG
Future<bool?> showAnimatedDialog(BuildContext context) async {
  Color? extractedColor = Color.lerp(AppColor.alert.colors.first, AppColor.alert.colors.last, 0.5) ?? AppColor.title;
  return await showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: extractedColor,
              child: const Icon(
                Icons.exit_to_app, // Replace with your IconData
                size: 40, // Adjust the icon size as needed
                color: Colors.white, // Adjust the icon color as needed
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Exit App?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Are you sure you want to exit?',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Exit'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
