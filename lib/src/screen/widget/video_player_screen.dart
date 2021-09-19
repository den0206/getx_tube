import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/screen/widget/loading_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({
    Key? key,
    required this.favoriteVideo,
  }) : super(key: key);
  final FavoriteVideo favoriteVideo;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController?.dispose();
  }

  void _init() async {
    if (widget.favoriteVideo.dlFile != null) {
      _videoPlayerController =
          VideoPlayerController.file(widget.favoriteVideo.dlFile!);
    } else {
      return;
    }

    try {
      await _videoPlayerController.initialize();
    } catch (e) {
      Get.snackbar("Error", "Can't load Video");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      fullScreenByDefault: false,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
      ],
      placeholder: Container(
        color: Colors.black87,
        child: Container(
          child: Center(
            child: LoadingCellWidget(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: !_isLoading && _chewieController != null
          ? Chewie(
              controller: _chewieController!,
            )
          : LoadingCellWidget(),
    );
  }
}
