import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

YoutubePlayer commonYTPlayer(
    {required String videoTitle,
    required YoutubePlayerController ytController}) {
  return YoutubePlayer(
    controller: ytController,
    showVideoProgressIndicator: true,
    progressIndicatorColor: Colors.blueAccent,
    topActions: <Widget>[
      IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 25.0,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      const SizedBox(width: 8.0),
      Expanded(
        child: Text(
          videoTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      IconButton(
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
          size: 25.0,
        ),
        onPressed: () async {},
      ),
    ],
    onReady: () {
      // ytController.play();
    },
    onEnded: (data) {
      ytController.pause();
    },
  );
}
