import 'package:quickresponse/main.dart';

class Call extends StatefulWidget {
  const Call({
    super.key,
    this.onImageCapture,
    this.onVideoRecord,
    this.onAudioRecord,
    this.properties,
    this.videoTimer,
    this.audioTimer,
  });

  final GestureTapCallback? onImageCapture;
  final GestureTapCallback? onVideoRecord;
  final GestureTapCallback? onAudioRecord;
  final CallProperties? properties;
  final Timer? videoTimer;
  final Timer? audioTimer;

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  bool isContactTap = false;
  bool shouldHide = false;
  late Timer _timer; // Timer object for updating the video timer
  int _elapsedSeconds = videoRecordLength;
  bool ticking = false;

  String status = '';

  bool isRecordingAudio = false;
  bool isRecordingVideo = false;

  @override
  void initState() {
    super.initState();
    Util.lockOrientation();
  }

  @override
  void dispose() {
    Util.unlockOrientation();
    //_timer.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatTime(_elapsedSeconds);
    final dp = Density.init(context);
    return WillPopScope(
      onWillPop: () {
        if (isContactTap) {
          setState(() {
            isContactTap = false;
          });
          return Future(() => false);
        } else {
          return Future(() => true);
        }
      },
      child: Scaffold(
        backgroundColor: shouldHide ? AppColor(theme).black : Colors.transparent,
        body: Center(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            0.08.dpH(dp).spY,
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 0,
              color: AppColor(theme).overlay,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(formattedTime, style: const TextStyle(color: Colors.white, fontSize: 20)),
                  GestureDetector(
                    onTap: () => setState(() => shouldHide = !shouldHide),
                    child: Icon(shouldHide ? CupertinoIcons.bolt_slash : CupertinoIcons.bolt, color: AppColor(theme).white, size: 22),
                  ),
                ]),
              ),
            ),
            0.08.dpH(dp).spY,
            Icon(CupertinoIcons.photo_on_rectangle, color: AppColor(theme).white, size: 40),
            0.05.dpH(dp).spY,
            Text('Want to call emergency number?', style: TextStyle(fontSize: 16, color: AppColor(theme).white)),
            0.40.dpH(dp).spY,
            Text(status, style: TextStyle(fontSize: 16, color: AppColor(theme).white)),
            0.10.dpH(dp).spY,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                buildVideoIconButton(
                  Icons.video_camera_back_outlined,
                  Icons.video_collection_outlined,
                  onPressed: () {
                    if (!isRecordingAudio) {
                      widget.onVideoRecord!();
                      if (widget.properties!.isRecordingVideo) {
                        _timer.cancel();
                        _elapsedSeconds = videoRecordLength;
                        setState(() => isRecordingVideo = false);
                        status = '';
                      } else {
                        _elapsedSeconds = videoRecordLength;
                        setState(() => isRecordingVideo = true);
                        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                          setState(() {
                            if (/*_elapsedSeconds == 59 || */ _elapsedSeconds <= 0) {
                              _elapsedSeconds = 0;
                            } else {
                              _elapsedSeconds--;
                            }
                            if (!widget.properties!.isRecordingVideo) {
                              _timer.cancel();
                              _elapsedSeconds = videoRecordLength;
                              setState(() => isRecordingVideo = false);
                              status = 'Media saved!';
                              Future.delayed(const Duration(seconds: 2), () => setState(() => status = ''));
                            }
                          });
                        });
                      }
                    }
                  },
                ),
                AlertButton(
                    height: 70,
                    width: 70,
                    borderWidth: 2,
                    shadowWidth: 0,
                    iconSize: 25,
                    showSecondShadow: false,
                    iconData: widget.properties!.isCapturingImage ? Icons.play_arrow_outlined : Icons.camera_alt,
                    onPressed: () {
                      if (!isRecordingVideo) {
                        widget.onImageCapture!();
                      }
                    }),
                buildAudioIconButton(
                  CupertinoIcons.recordingtape,
                  Icons.audiotrack_outlined,
                  onPressed: () {
                    if (!isRecordingVideo) {
                      widget.onAudioRecord!();
                      if (widget.properties!.isRecordingAudio) {
                        _timer.cancel();
                        _elapsedSeconds = 0;
                        setState(() => isRecordingAudio = false);
                        status = '';
                      } else {
                        _elapsedSeconds = 0;
                        setState(() => isRecordingAudio = true);
                        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                          setState(() {
                            _elapsedSeconds++;
                            if (!widget.properties!.isRecordingAudio) {
                              _timer.cancel();
                              _elapsedSeconds = 0;
                              setState(() => isRecordingAudio = false);
                              status = 'Media saved!';
                              Future.delayed(const Duration(seconds: 2), () => setState(() => status = ''));
                            }
                          });
                        });
                      }
                    }
                  },
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  IconButton buildVideoIconButton(IconData iconA, IconData iconB, {Function()? onPressed}) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: widget.properties!.isRecordingVideo ? Blink(isNotText: true, child: buildVideoIcon(iconA, iconB)) : buildVideoIcon(iconA, iconB),
      style: ButtonStyle(
        backgroundColor: widget.properties!.isRecordingVideo ? MaterialStatePropertyAll(AppColor(theme).action) : MaterialStatePropertyAll(AppColor(theme).overlay),
        fixedSize: const MaterialStatePropertyAll(Size.square(58)),
      ),
    );
  }

  IconButton buildAudioIconButton(IconData iconA, IconData iconB, {Function()? onPressed}) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: widget.properties!.isRecordingAudio ? Blink(isNotText: true, child: buildAudioIcon(iconA, iconB)) : buildAudioIcon(iconA, iconB),
      style: ButtonStyle(
        backgroundColor: widget.properties!.isRecordingAudio ? MaterialStatePropertyAll(AppColor(theme).action) : MaterialStatePropertyAll(AppColor(theme).overlay),
        fixedSize: const MaterialStatePropertyAll(Size.square(58)),
      ),
    );
  }

  Icon buildVideoIcon(IconData iconA, IconData iconB) => Icon(widget.properties!.isRecordingVideo ? iconA : iconB, size: 22);

  Icon buildAudioIcon(IconData iconA, IconData iconB) => Icon(widget.properties!.isRecordingAudio ? iconA : iconB, size: 22);
}
