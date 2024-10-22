import 'package:path/path.dart' as path;
import 'package:quickresponse/main.dart';
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
  late AudioRecorder _audioRecorder;
  bool _isCapturingImage = false;
  bool _isRecordingVideo = false;
  bool _isRecordingAudio = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _audioRecorder = AudioRecorder();
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
      'Error initializing camera: $e'.log;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
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
                  onVideoRecord: () => _startVideoRecording(),
                  onAudioRecord: () => _startRecordingAudio(),
                  properties: CallProperties(
                    isCapturingImage: _isCapturingImage,
                    isRecordingVideo: _isRecordingVideo,
                    isRecordingAudio: _isRecordingAudio,
                  ),
                  videoTimer: _videoTimer,
                  audioTimer: _audioTimer,
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

  Timer? _videoTimer;
  Timer? _audioTimer;

  void _startVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      try {
        _controller.startVideoRecording();
        setState(() {
          _isRecordingVideo = true;
        });

        // Start a timer for 10 seconds
        _videoTimer = Timer(Duration(seconds: videoRecordLength), () {
          _videoTimer.log;
          _stopRecording();
        });
      } catch (e) {
        e.log;
      }
    } else {
      _stopRecording();
    }
  }

  void _stopRecording() async {
    if (_controller.value.isRecordingVideo) {
      try {
        // Cancel the timer if it's active
        _videoTimer?.cancel();

        // Ensure that the device's camera gallery directory exists
        final Directory? galleryDir = await getExternalStorageDirectory();
        final String? storagePath = await galleryDir?.mkdir("videos");

        // Create a unique filename for the image based on the current timestamp
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String videoFileName = 'VID_$timestamp.mp4';

        // Construct the complete image path
        final String videoPath = path.join(storagePath!, videoFileName);

        XFile video = await _controller.stopVideoRecording();

        // Copy the picture to the desired path
        final File videoFile = File(video.path);
        await videoFile.copy(videoPath);

        setState(() => _isRecordingVideo = false);

        //await upload(videoFile, videoFileName, 'videos');
      } catch (e) {
        e.log;
      }
    }
  }

  void _takePicture() async {
    if (!_controller.value.isTakingPicture) {
      try {
        // Ensure that the device's camera gallery directory exists
        final Directory? directory = await getExternalStorageDirectory();
        final String storagePath = await directory!.mkdir("images");

        // Create a unique filename for the image based on the current timestamp
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String imageFileName = 'IMG_$timestamp.jpg';

        // Construct the complete image path
        final String imagePath = path.join(storagePath, imageFileName);

        // Take the picture
        XFile picture = await _controller.takePicture();
        Future(() => setState(() => _isCapturingImage = true));

        // Copy the picture to the desired path
        final File pictureFile = File(picture.path);
        await pictureFile.copy(imagePath);

        setState(() => _isCapturingImage = false);

        //await upload(pictureFile, imageFileName, 'images');
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

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: audioPath,
        );
        setState(() {
          _isRecordingAudio = true;
          _audioPath = audioPath;
        });

        // Start a timer for 10 seconds
        _audioTimer = Timer(const Duration(seconds: 10), () {
          _audioTimer.log;
          _stopRecordingAudio();
        });

        //await upload(File(audioPath), audioFileName, 'audios');
      } catch (e) {
        e.log;
      }
    } else {
      _stopRecordingAudio();
    }
  }

  void _stopRecordingAudio() async {
    if (_isRecordingAudio) {
      try {
        // Cancel the timer if it's active
        _audioTimer?.cancel();

        await _audioRecorder.stop();
        setState(() => _isRecordingAudio = false);
      } catch (e) {
        e.log;
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

/*Future<void> upload(File file, String fileName, String folder) async {
    var profile = await getProfileInfoFromSharedPreferences();
    String url = await uploadFileToStorage(file, "media/${profile.uid}/$folder/", fileName);
    await addMediaMetadataToFirestore("${profile.uid}", folder, url, fileName);
  }*/
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
