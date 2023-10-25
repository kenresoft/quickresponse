import 'package:quickresponse/main.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // Handle error
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              // No available cameras
              return const Center(child: Text('No camera found on the device.'));
            }

            // Initialize the CameraController with the first available camera
            return CameraPreviewWidget(camera: snapshot.data!.first);
          } else {
            // Loading indicator while waiting for the camera to be available
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
