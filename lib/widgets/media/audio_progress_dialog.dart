import 'package:flutter/material.dart';

class AudioProgressDialog extends StatelessWidget {
  final Stream<Duration?> positionStream;

  const AudioProgressDialog({super.key, required this.positionStream});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Audio Playing'),
            StreamBuilder<Duration?>(
              stream: positionStream,
              builder: (context, snapshot) {
                var position = snapshot.data ?? Duration.zero;
                return Text('Position: ${position.inSeconds} seconds');
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<Duration?>(
              stream: positionStream,
              builder: (context, snapshot) {
                var position = snapshot.data ?? Duration.zero;
                var duration = const Duration(seconds: 60);
                var progress = position.inMilliseconds / duration.inMilliseconds;
                return LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
