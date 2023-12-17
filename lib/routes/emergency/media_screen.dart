import 'package:quickresponse/main.dart';

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key});

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  ProfileInfo? profileInfo;
  Future<List<String>>? mediaFilesFuture;
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    profileInfo = getProfileInfoFromSharedPreferences();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Density dp = Density.init(context);
    //final theme = ref.watch(themeProvider.select((value) => value));
    return Scaffold(
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        title: const Text('Emergency Media', style: TextStyle(fontSize: 20)),
        leading: const LogoCard(),
        actionTitle: '',
        actionIcon: PopupMenuButton<MediaType>(
          surfaceTintColor: Colors.white,
          icon: Icon(Icons.filter_list, color: AppColor(theme).navIconSelected),
          onSelected: (MediaType result) {
            setState(() => selectedMediaType = result);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MediaType>>[
            const PopupMenuItem<MediaType>(value: MediaType.Image, child: Text('Images')),
            const PopupMenuItem<MediaType>(value: MediaType.Video, child: Text('Videos')),
            const PopupMenuItem<MediaType>(value: MediaType.Audio, child: Text('Audios')),
          ],
        ),
        onActionClick: () {},
      ),
      body: Center(
        child: Column(children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FutureBuilder<List<String>>(
                  future: _loadMediaFiles(selectedMediaType),
                  builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: AppColor(theme).navIconSelected));
                    }

                    final List<String> mediaFiles = snapshot.data ?? [];

                    if (mediaFiles.isEmpty) {
                      return Container(
                        decoration: BoxDecoration(color: AppColor(theme).white),
                        padding: const EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Center(child: Text('No media available', style: TextStyle(fontSize: 21, color: AppColor(theme).title_2))),
                        ),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(color: AppColor(theme).white),
                      padding: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GridView.builder(
                          itemCount: mediaFiles.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: selectedMediaType == MediaType.Audio ? 100 : 200,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            final String mediaUrl = mediaFiles[index];

                            // Determine the card type based on the selectedMediaType
                            Widget mediaCard;
                            switch (selectedMediaType) {
                              case MediaType.Image:
                                mediaCard = buildImageCard(mediaUrl, theme);
                                break;
                              case MediaType.Video:
                                mediaCard = buildVideoCard(mediaUrl, theme);
                                break;
                              case MediaType.Audio:
                                mediaCard = buildAudioCard(mediaUrl, theme);
                                break;
                            }

                            return mediaCard;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildImageCard(String imageUrl, bool theme) {
    return Card(
      margin: EdgeInsets.zero,
      color: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) => ImageDisplay(imageUrl: imageUrl),
          ));
        },
        child: Stack(alignment: Alignment.center, children: [
          FutureBuilder<Uint8List?>(
            future: loadImage(imageUrl),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: MemoryImage(snapshot.data!),
                      fit: BoxFit.cover, // Cover the entire space
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            top: 3,
            right: 3,
            child: Container(
              width: 35,
              height: 40,
              decoration: BoxDecoration(color: AppColor(theme).overlay, borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                splashColor: AppColor(theme).navIconSelected,
                child: const Icon(CupertinoIcons.delete_simple, color: Colors.white, size: 21),
                onTap: () => deleteMedia(imageUrl, MediaType.Image),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildVideoCard(String videoUrl, bool theme) {
    return Card(
      margin: EdgeInsets.zero,
      color: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      elevation: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) => VideoPlay(url: videoUrl),
          ));
        },
        child: Stack(alignment: Alignment.center, children: [
          FutureBuilder<Uint8List?>(
            future: VideoThumbnail.thumbnailData(
              video: videoUrl,
              imageFormat: ImageFormat.JPEG,
              maxWidth: 120,
              quality: 100,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(image: MemoryImage(snapshot.data!), fit: BoxFit.cover),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator(color: AppColor(theme).navIconSelected));
              }
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(CupertinoIcons.delete_simple, color: Colors.white, size: 21),
              onPressed: () => deleteMedia(videoUrl, MediaType.Video),
            ),
          ),
          Icon(Icons.play_circle_fill, size: 48, color: AppColor(theme).background),
        ]),
      ),
    );
  }

  Widget buildAudioCard(String audioUrl, bool theme) {
    final audioFileName = audioUrl.split('/').last; // Extract the file name from the URL
    const maxTitleLength = 45;

    // Trim the title if it's too long
    final trimmedTitle = audioFileName.length > maxTitleLength ? '${audioFileName.substring(0, maxTitleLength)}...' : audioFileName;

    return Card(
      margin: EdgeInsets.zero,
      color: AppColor(theme).overlay,
      elevation: 0,
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () => playAudio(audioUrl),
          leading: Icon(CupertinoIcons.music_note, color: AppColor(theme).action),
          title: Text(
            trimmedTitle,
            style: TextStyle(color: AppColor(theme).title),
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1, // Limit to a single line
          ),
          subtitle: Text('Tap to Play', style: TextStyle(color: AppColor(theme).title_2)),
          trailing: SizedBox(
            width: 30,
            height: 30,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              splashColor: AppColor(theme).overlay,
              child: Icon(CupertinoIcons.delete_simple, color: AppColor(theme).title_2, size: 21),
              onTap: () => deleteMedia(audioUrl, MediaType.Audio),
            ),
          ),
        ),
      ),
    );
  }

// Audio Player instance
  final AudioPlayer audioPlayer = AudioPlayer();

// Function to play an audio file from the device's external storage directory
  Future<void> playAudio(String audioUrl) async {
    final String audioPath = audioUrl;

    try {
      await audioPlayer.setFilePath(audioPath);
      await audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

// Function to delete media from the device's external storage directory
  void deleteMedia(String mediaUrl, MediaType mediaType) async {
    //final Directory? externalDir = await getExternalStorageDirectory();
    final String mediaPath = mediaUrl;

    try {
      final File mediaFile = File(mediaPath);
      if (await mediaFile.exists()) {
        await mediaFile.delete();
        print('Deleted media: $mediaUrl');
        setState(() {});
      } else {
        print('Media file not found: $mediaUrl');
      }
    } catch (e) {
      print('Error deleting media: $e');
    }
  }

// Helper function to get the media type directory name
  String getMediaTypeDirectoryName(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.Image:
        return 'images';
      case MediaType.Video:
        return 'videos';
      case MediaType.Audio:
        return 'audios';
      default:
        return 'unknown';
    }
  }
}

// Function to load an image from the device's external storage directory
Future<Uint8List?> loadImage(String imageUrl) async {
  final String imagePath = imageUrl;

  try {
    final File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      final Uint8List bytes = await imageFile.readAsBytes();
      print('Image loaded successfully: $imageUrl');
      return bytes;
    } else {
      print('Image file not found: $imageUrl');
    }
  } catch (e) {
    print('Error loading image: $e');
  }
  return null;
}

Future<List<String>> _loadMediaFiles(MediaType mediaType) async {
  final Directory? externalDir = await getExternalStorageDirectory();
  final String mediaDir = mediaType == MediaType.Image
      ? 'images'
      : mediaType == MediaType.Video
          ? 'videos'
          : 'audios';

  final String mediaPath = '${externalDir?.path}/$mediaDir';

  try {
    final List<FileSystemEntity> files = Directory(mediaPath).listSync();
    return files.whereType<File>().map((file) => file.path).toList();
  } catch (e) {
    print('Error loading media files: $e');
    return [];
  }
}

// ignore: constant_identifier_names
enum MediaType { Image, Video, Audio }

MediaType selectedMediaType = MediaType.Image; // Default selection

class VideoPlay extends ConsumerStatefulWidget {
  const VideoPlay({super.key, required this.url});

  final String url;

  @override
  ConsumerState<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends ConsumerState<VideoPlay> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final theme = ref.watch(themeProvider.select((value) => value));
    return Scaffold(
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        title: const Text('Video Player', style: TextStyle(fontSize: 20)),
        leading: Icon(CupertinoIcons.increase_quotelevel, color: AppColor(theme).navIconSelected),
        actionTitle: '',
        actionIcon: CupertinoIcons.memories,
        onActionClick: () {},
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(5),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _controller.value.isInitialized ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)) : Container(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class ImageDisplay extends ConsumerStatefulWidget {
  final String imageUrl;

  const ImageDisplay({super.key, required this.imageUrl});

  @override
  ConsumerState<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends ConsumerState<ImageDisplay> {
  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    //final theme = ref.watch(themeProvider.select((value) => value));
    return LayoutBuilder(
      builder: (context, orientation) {
        var isPortrait = orientation.maxWidth > orientation.maxHeight;
        return Scaffold(
          backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
          appBar: CustomAppBar(
            title: const Text('Image Display', style: TextStyle(fontSize: 20)),
            leading: Icon(CupertinoIcons.increase_quotelevel, color: AppColor(theme).navIconSelected),
            actionTitle: '',
            actionIcon: CupertinoIcons.photo,
            //onActionClick: () {},
          ),
          body: Container(
            height: isPortrait ? 900 : null,
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(5),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FutureBuilder<Uint8List?>(
                  future: loadImage(widget.imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return SingleChildScrollView(
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          //height: isPortrait ? 900 : null,
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
