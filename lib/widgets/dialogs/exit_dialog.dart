import 'package:flutter/material.dart';

import '../../data/constants/styles.dart';

/// EXIT DIALOG
Future<bool?> showExitDialog(BuildContext context, bool theme) async {
  Color? extractedColor = Color.lerp(AppColor(theme).alertMix.colors.first, AppColor(theme).alertMix.colors.last, 0.5) ?? AppColor(theme).title;
  return await showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(
            radius: 51.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50.0,
              backgroundColor: extractedColor,
              child: const Icon(Icons.exit_to_app, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16.0),
          Text('Exit App?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: AppColor(theme).title)),
          const SizedBox(height: 8.0),
          Text('Are you sure you want to exit?', style: TextStyle(fontSize: 16.0, color: AppColor(theme).title_2)),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Exit')),
            ],
          ),
        ]),
      ),
    ),
  );
}
