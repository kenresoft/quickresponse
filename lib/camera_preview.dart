import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickresponse/routes/call.dart';
import 'package:quickresponse/utils/file_helper.dart';
import 'package:record/record.dart';

class CameraPreviewWidget extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewWidget({super.key, required this.camera});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late XFile? _recordedVideo;
  bool _isCapturingImage = false;
  bool _isRecordingVideo = false;
  bool _isRecordingAudio = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.camera, ResolutionPreset.ultraHigh);
    _controller.setFlashMode(FlashMode.always);
    _controller.setFocusMode(FocusMode.auto);

    _initializeControllerFuture = _controller.initialize();

    try {
      await _initializeControllerFuture;
    } catch (e) {
      // Handle camera initialization error
      print('Error initializing camera: $e');
    }
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.microphone] != PermissionStatus.granted ||
        statuses[Permission.storage] != PermissionStatus.granted) {
      // Handle permission denied scenarios
      print('Camera or storage permission is not granted.');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // Handle error
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            // Show camera preview
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: CameraPreview(
                _controller,
                child: Call(
                  onImageCapture: () => _takePicture(),
                  onVideoRecord: () => _startRecording(),
                  onAudioRecord: () => _startRecordingAudio(),
                  properties: CallProperties(
                    isCapturingImage: _isCapturingImage,
                    isRecordingVideo: _isRecordingVideo,
                    isRecordingAudio: _isRecordingAudio,
                  ),
                ),
              ),
            );
          } else {
            // Loading indicator while waiting for the camera to be ready
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _startRecording() async {
    if (!_controller.value.isRecordingVideo) {
      try {
        _controller.startVideoRecording();
        setState(() => _isRecordingVideo = true);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      _stopRecording();
    }
  }

  void _stopRecording() async {
    if (_controller.value.isRecordingVideo) {
      try {
        // Ensure that the device's camera gallery directory exists
        final Directory? galleryDir = await getExternalStorageDirectory();
        final String? storagePath = await galleryDir?.mkdir("videos");

        // Create a unique filename for the image based on the current timestamp
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String imageFileName = 'VID_$timestamp.mp4';

        // Construct the complete image path
        final String videoPath = path.join(storagePath!, imageFileName);

        XFile video = await _controller.stopVideoRecording();
        setState(() => _isRecordingVideo = false);
        // Copy the picture to the desired path
        final File videoFile = File(video.path);
        await videoFile.copy(videoPath);
      } catch (e) {
        print(e);
      }
    }
  }

  void _takePicture() async {
    if (!_controller.value.isTakingPicture) {
      try {
        // Ensure that the device's camera gallery directory exists
        final Directory? directory = await getExternalStorageDirectory();
        final String storagePath = await directory!.mkdir("pictures");

        // Create a unique filename for the image based on the current timestamp
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String imageFileName = 'IMG_$timestamp.jpg';

        // Construct the complete image path
        final String imagePath = path.join(storagePath, imageFileName);

        // Take the picture
        XFile picture = await _controller.takePicture();
        setState(() => _isCapturingImage = true);

        // Copy the picture to the desired path
        final File pictureFile = File(picture.path);
        await pictureFile.copy(imagePath);
        setState(() => _isRecordingVideo = false);
        // Do something with the picture (e.g., show preview, save to database, etc.)
      } catch (e) {
        print('Error taking picture: $e');
      }
    }
  }

  void _startRecordingAudio() async {
    if (!_isRecordingAudio) {
      try {
        final Directory? directory = await getExternalStorageDirectory();
        final String storagePath = await directory!.mkdir("audios");
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String audioFileName = 'AUD_$timestamp.wav';
        final String audioPath = path.join(storagePath, audioFileName);

        await Record().start(
          path: audioPath,
          encoder: AudioEncoder.wav,
          bitRate: 128000,
          samplingRate: 44100,
        );
        setState(() {
          _isRecordingAudio = true;
          _audioPath = audioPath;
        });
      } catch (e) {
        print(e);
      }
    } else {
      _stopRecordingAudio();
    }
  }

  void _stopRecordingAudio() async {
    if (_isRecordingAudio) {
      try {
        await Record().stop();
        setState(() => _isRecordingAudio = false);
      } catch (e) {
        print(e);
      }
    }
  }

  void _playLastAudio() async {
    if (_audioPath != null) {
      // Play the recorded audio using your preferred audio player
    }
  }

  void _pickImageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // Do something with the picked image (e.g., show preview, save, etc.)
  }
}

class CallProperties {
  const CallProperties({
    required this.isCapturingImage,
    required this.isRecordingVideo,
    required this.isRecordingAudio,
  });

  final bool isCapturingImage;
  final bool isRecordingVideo;
  final bool isRecordingAudio;
}
