import 'package:flutter/material.dart';

class LocationDialog extends StatelessWidget {
  const LocationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enable Location Service'),
      content: const Text('We need your location to provide you with the best possible experience.'),
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.location_on,
        color: Colors.green,
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Navigate to the system settings page for location.
            Navigator.of(context).pop();
          },
          child: const Text('Go to Settings'),
        ),
        TextButton(
          onPressed: () {
            // Close the dialog.
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
