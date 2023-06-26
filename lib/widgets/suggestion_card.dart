import 'package:flutter/material.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Text(text),
        const Row(
          children: [
            Icon(Icons.construction_outlined),
            Icon(Icons.construction_outlined),
          ],
        )
      ]),
    );
  }
}
