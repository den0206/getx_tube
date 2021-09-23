import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

enum CurrentPlayerState {
  none,
  yt,
  video,
}

class PlayingService extends GetxController {
  static PlayingService get to => Get.find();
  YoutubePlayerController? ytController;
  VideoPlayerController? videoPlayerController;

  CurrentPlayerState get currentState {
    if (ytController == null && videoPlayerController == null) {
      return CurrentPlayerState.none;
    } else if (videoPlayerController != null) {
      return CurrentPlayerState.video;
    } else if (ytController != null) {
      return CurrentPlayerState.yt;
    } else {
      return CurrentPlayerState.none;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    ytController?.dispose();
    videoPlayerController?.dispose();
  }

  void setSorce(dynamic sorce) {
    if (sorce is Video) {
      _setYT(sorce.id.toString());
    } else if (sorce is FavoriteVideo) {
      if (sorce.isDownloaded) {
        ytController = null;
        videoPlayerController = VideoPlayerController.file(sorce.dlFile!);
      } else {
        _setYT(sorce.id);
      }
    } else {
      return;
    }

    update();
  }

  void _setYT(String id) {
    videoPlayerController = null;
    if (ytController != null) {
      ytController!.load(id);
      return;
    }
    ytController = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: false,
        forceHD: false,
        enableCaption: false,
        hideControls: true,
      ),
    );
  }

  void play() {
    switch (currentState) {
      case CurrentPlayerState.none:
        return;
      case CurrentPlayerState.yt:
        ytController!.play();
        break;
      case CurrentPlayerState.video:
        videoPlayerController!.play();
        break;
    }
  }

  void pause() {
    switch (currentState) {
      case CurrentPlayerState.none:
        return;
      case CurrentPlayerState.yt:
        if (!ytController!.value.isPlaying) {
          ytController!.play();
        } else {
          ytController!.pause();
        }

        break;
      case CurrentPlayerState.video:
        if (!videoPlayerController!.value.isPlaying) {
          videoPlayerController!.play();
        } else {
          videoPlayerController!.pause();
        }

        break;
    }
  }

  void stop() {
    videoPlayerController = null;
    ytController = null;

    update();
  }
}
