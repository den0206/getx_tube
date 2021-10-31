import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class BackGroundPlayerHandlerImpl extends BaseAudioHandler {
  final _player = AudioPlayer();

  BackGroundPlayerHandlerImpl() {
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;

      playbackState.add(
        playbackState.value.copyWith(
            controls: [
              MediaControl.skipToPrevious,
              if (playing) MediaControl.pause else MediaControl.play,
              MediaControl.stop,
              MediaControl.skipToNext,
            ],
            systemActions: const {
              MediaAction.seek,
            },
            androidCompactActionIndices: const [
              0,
              1,
              3
            ],
            processingState: const {
              ProcessingState.idle: AudioProcessingState.idle,
              ProcessingState.loading: AudioProcessingState.loading,
              ProcessingState.buffering: AudioProcessingState.buffering,
              ProcessingState.ready: AudioProcessingState.ready,
              ProcessingState.completed: AudioProcessingState.completed,
            }[_player.processingState]!,
            playing: playing,
            updatePosition: _player.position,
            bufferedPosition: _player.bufferedPosition,
            speed: _player.speed,
            queueIndex: event.currentIndex,
            shuffleMode: (_player.shuffleModeEnabled)
                ? AudioServiceShuffleMode.all
                : AudioServiceShuffleMode.none),
      );
    });
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  AudioSource _itemToSource(MediaItem mediaItem) {
    AudioSource audioSorce;
    final bool isFile = mediaItem.extras!["isFile"];

    if (isFile) {
      print("File");
      print(Uri.file(mediaItem.extras!["url"].toString()));
      audioSorce =
          AudioSource.uri(Uri.file(mediaItem.extras!["url"].toString()));
    } else {
      print("Not File");
      audioSorce = AudioSource.uri(
        Uri.parse(mediaItem.extras!["url"].toString()),
      );
    }

    return audioSorce;
  }

  Future<void> setBackgroundTrack(MediaItem media) async {
    mediaItem.add(media);
    await _player.setAudioSource(_itemToSource(media), preload: false);
    await _player.load();
  }

  Future<void> handleOnPause(Duration currentDuration) async {
    await seek(currentDuration);

    await _player.play();
  }

  Future<Duration> handleOnResume() async {
    if (_player.playing) {
      await _player.pause();
    }

    return _player.position;
  }
}
