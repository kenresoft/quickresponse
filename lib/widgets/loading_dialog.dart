import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

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
