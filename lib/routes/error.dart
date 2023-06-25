import 'package:flutter/material.dart';

import '../data/constants/constants.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Constants.appName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Sorry, an error was encountered!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              color: Colors.deepPurple.shade200,
            ),
          ),
        ),
      ),
    );
  }
}
