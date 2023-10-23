import 'package:flutter/material.dart';

/*
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Loading'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 10),
          Text('Fetching your current location...'),
          // Text('Please wait while we fetch your current location.'),
        ],
      ),
      backgroundColor: Colors.white,
      icon: Icon(
        Icons.location_searching,
        color: Colors.green,
      ),
    );
  }
}

*/

class LoadingDialog {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.0),
            Text('Loading...'),
          ]),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the loading dialog
  }
}
