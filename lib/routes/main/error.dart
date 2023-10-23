import 'package:flutter/material.dart';

import '../../data/constants/constants.dart';
import '../../data/constants/styles.dart';
import '../../providers/settings/prefs.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, this.error}) : super(key: key);

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Constants.appName)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(children: [
            Text(
              'Sorry, an error was encountered!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: AppColor(theme).action,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              error ?? 'Unknown',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: AppColor(theme).text,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
