import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/player/playing_service.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AudioPlayerHandlerImpl extends BaseAudioHandler {
  YoutubePlayerController? youtubePlayerController;
  VideoPlayerController? videoPlayerController;

  bool get isPlaying {
    if (youtubePlayerController == null && videoPlayerController == null) {
      return false;
    } else if (videoPlayerController!.value.isPlaying ||
        youtubePlayerController!.value.isPlaying) {
      return true;
    } else {
      return false;
    }
  }

  void playYT(MediaItem media) async {
    mediaItem.add(media);
    print(mediaItem);
    // if (isPlaying) {
    //   youtubePlayerController?.pause();
    //   videoPlayerController?.pause();
    // }

    _setyt(media);
  }

  Future<void> _setyt(MediaItem media) async {
    if (youtubePlayerController != null) {
      youtubePlayerController!.load(media.id);
      return;
    }
    youtubePlayerController = await YoutubePlayerController(
      initialVideoId: media.id,
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

    print(youtubePlayerController);
    youtubePlayerController!.addListener(() {
      print(youtubePlayerController!.value.position);
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (youtubePlayerController!.value.isPlaying)
            MediaControl.pause
          else
            MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        playing: youtubePlayerController!.value.isPlaying,
        updatePosition: youtubePlayerController!.value.position,
        bufferedPosition: youtubePlayerController!.value.position,
      ));
    });
  }

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value
        .copyWith(playing: true, controls: [MediaControl.pause]));

    if (youtubePlayerController != null) {
      youtubePlayerController!.play();
    }
  }

  @override
  Future<void> pause() async {
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        controls: [MediaControl.play],
      ),
    );
    if (youtubePlayerController != null) {
      youtubePlayerController!.pause();
    }
  }

  @override
  Future<void> stop() async {
    youtubePlayerController?.removeListener(() {});
    videoPlayerController?.removeListener(() {});
    youtubePlayerController?.dispose();
    videoPlayerController?.dispose();
    return super.stop();
  }
}

class VideoHandler extends GetxController {
  static VideoHandler get to => Get.find();
  AudioPlayerHandlerImpl? audioHandler;

  final MiniplayerController miniplayerController = MiniplayerController();

  CurrentPlayerState get currentState {
    if (audioHandler == null) {
      return CurrentPlayerState.none;
    } else if (audioHandler?.videoPlayerController != null) {
      return CurrentPlayerState.video;
    } else if (audioHandler?.youtubePlayerController != null) {
      return CurrentPlayerState.yt;
    } else {
      return CurrentPlayerState.none;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    await startService();
    print("INIT");
  }

  @override
  void onClose() {
    super.onClose();
    audioHandler?.stop();
  }

  void play() => audioHandler?.play();

  void pause() => audioHandler?.pause();

  Future<void> startService() async {
    audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandlerImpl(),
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

  Future<void> setYtVideo(Video video) async {
    final String thumbString = video.thumbnails.standardResUrl;
    final artUri = Uri.parse(thumbString);

    final MediaItem mediaItem = MediaItem(
      id: video.id.toString(),
      title: video.title,
      artist: video.author,
      artUri: artUri,
      duration: video.duration,
    );

    print(mediaItem);
    audioHandler?.playYT(mediaItem);

    update();
  }
}
