import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/screen/favorite_video/detail/detail_favorite_screen.dart';
import 'package:getx_tube/src/screen/video_detail/video_detail_screen.dart';
import 'package:getx_tube/src/service/background_service.dart';
import 'package:getx_tube/src/service/yt_service.dart';
import 'package:miniplayer/miniplayer.dart';
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
  late BackGroundPlayerHandlerImpl _backGroundPlayerHandlerImpl;

  final MiniplayerController miniplayerController = MiniplayerController();
  final ytSearvice = YTService();

  dynamic source;

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

  bool get isPlaying {
    switch (currentState) {
      case CurrentPlayerState.none:
        return false;
      case CurrentPlayerState.yt:
        return ytController!.value.isPlaying;
      case CurrentPlayerState.video:
        return videoPlayerController!.value.isPlaying;
    }
  }

  Duration get currentPosition {
    switch (currentState) {
      case CurrentPlayerState.none:
        return Duration();
      case CurrentPlayerState.yt:
        return ytController!.value.position;
      case CurrentPlayerState.video:
        return videoPlayerController!.value.position;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    await startService();
  }

  @override
  void onClose() {
    super.onClose();
    ytController?.dispose();
    videoPlayerController?.dispose();
    miniplayerController.dispose();
  }

  Future<void> startService() async {
    _backGroundPlayerHandlerImpl = await AudioService.init(
      builder: () => BackGroundPlayerHandlerImpl(),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.shadow.gettube.channel.audio',
        androidNotificationChannelName: 'GetTube',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'drawable/ic_stat_music_note',
        androidShowNotificationBadge: true,
        notificationColor: Colors.grey[900],
      ),
    );
  }

  void handleOnPause() {
    _backGroundPlayerHandlerImpl.handleOnPause(currentPosition);
  }

  void handleOnResume() async {
    final Duration currentDuration =
        await _backGroundPlayerHandlerImpl.handleOnResume();

    setCurrentPosition(currentDuration);
  }

  void setSorce(dynamic sorce) {
    source = sorce;
    sourceToMedia();

    if (sorce is Video) {
      _setYT(sorce.id.toString());
    } else if (sorce is FavoriteVideo) {
      if (sorce.isDownloaded) {
        ytController = null;
        if (videoPlayerController != null) {
          stop();
          return;
        }
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

    try {
      if (ytController != null) {
        ytController!.load(id);
        update();
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
          // hideControls: true,
        ),
      );
    } catch (e) {}
  }

  Future<void> sourceToMedia() async {
    if (source is! Video && source is! FavoriteVideo) {
      print("NOT FIT TYPE");
      return;
    }

    MediaItem? mediaItem;

    if (source is Video) {
      mediaItem = await _configYTMedia(source);
    }

    if (source is FavoriteVideo) {
      mediaItem = await _configFavMedia(source);
    }

    if (mediaItem != null)
      _backGroundPlayerHandlerImpl.setBackgroundTrack(mediaItem);
  }

  Future<MediaItem> _configYTMedia(Video video) async {
    final String thumbString = video.thumbnails.standardResUrl;
    final artUri = Uri.parse(thumbString);
    final audioUrl = await ytSearvice.getAudioUrl(video.id);

    final MediaItem mediaItem = MediaItem(
      id: video.id.toString(),
      title: video.title,
      artist: video.author,
      artUri: artUri,
      duration: video.duration,
      extras: {
        "url": audioUrl,
        "isFile": false,
      },
    );

    return mediaItem;
  }

  Future<MediaItem> _configFavMedia(FavoriteVideo fav) async {
    final artUri = Uri.parse(fav.thumbnail);

    dynamic urlSorce;
    if (fav.isDownloaded) {
      urlSorce = fav.dlFile!.path;
    } else {
      final audioUrl = await ytSearvice.getAudioUrl(VideoId(fav.id));
      urlSorce = audioUrl;
    }
    bool isFile = fav.isDownloaded;

    final mediaItem = MediaItem(
      id: fav.id.toString(),
      title: fav.title,
      artist: fav.title,
      artUri: artUri,
      duration: fav.duration,
      extras: {
        "url": urlSorce,
        "isFile": isFile,
      },
    );

    return mediaItem;
  }

  void setCurrentPosition(Duration positon) {
    switch (currentState) {
      case CurrentPlayerState.none:
        return;
      case CurrentPlayerState.yt:
        ytController!.seekTo(positon);
        break;
      case CurrentPlayerState.video:
        videoPlayerController!.seekTo(positon);
        break;
    }
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
    ytController?.pause();
    videoPlayerController?.pause();
    videoPlayerController = null;
    ytController = null;

    update();
  }

  void openDetail() async {
    if (source == null) {
      return;
    }

    if (source is Video) {
      ytController?.pause();
      Get.to(
        () => VideoDetailScreen(),
        arguments: source,
        fullscreenDialog: true,
      );
    }
    if (source is FavoriteVideo) {
      videoPlayerController?.pause();
      final _ = await Get.to(
        () => DetailFavoriteScreen(),
        arguments: source,
        fullscreenDialog: true,
      );

      update();
    }
  }
}
