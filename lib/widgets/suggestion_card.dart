import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 80,
            child: Text(
              text,
              maxLines: 2,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
           Expanded(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.redAccent,
                ),
                30.spX,
                 const Icon(
                  CupertinoIcons.group,
                  color: Colors.grey,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
