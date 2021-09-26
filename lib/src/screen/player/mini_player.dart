import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/screen/player/playing_service.dart';
import 'package:getx_tube/src/screen/widget/video_player_screen.dart';

import 'expand/favorite_info/favorite_info_screen.dart';
import 'expand/yt_info/yt_info_screen.dart';

class MiniPlayerArea extends GetView<PlayingService> {
  const MiniPlayerArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height -
        20.h -
        -(MediaQuery.of(context).padding.top + kToolbarHeight);
    return GetBuilder<PlayingService>(
      init: PlayingService(),
      builder: (_) {
        return Miniplayer(
          controller: controller.miniplayerController,
          minHeight: 25.w,
          maxHeight: maxHeight,
          builder: (height, percentage) {
            final bool isMini = (height <= 25.w + 50.0);

            return Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.white),
                    bottom: BorderSide(color: Colors.white),
                  )),
              child: Flex(
                direction: isMini ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: isMini
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: isMini ? 0 : 5.h),
                    constraints: BoxConstraints(maxHeight: height - 10),
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: IgnorePointer(
                        ignoring: isMini,
                        child: _playngScreen(),
                      ),
                    ),
                  ),
                  if (isMini) ..._miniPlayerButtons,
                  if (height >= maxHeight - 10) ..._properSpace()
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> get _miniPlayerButtons {
    return [
      IconButton(
        icon: Icon(
          Icons.play_arrow,
          size: 30.sp,
        ),
        onPressed: () {
          controller.play();
        },
      ),
      IconButton(
        icon: Icon(
          Icons.pause,
          size: 30.sp,
        ),
        onPressed: () {
          controller.pause();
        },
      ),
      IconButton(
        icon: Icon(
          Icons.stop,
          size: 30.sp,
        ),
        onPressed: () {
          controller.stop();
        },
      ),
    ];
  }

  Widget _playngScreen() {
    switch (controller.currentState) {
      case CurrentPlayerState.none:
        return Container();

      case CurrentPlayerState.yt:
        return YoutubePlayer(
          controller: controller.ytController!,
        );
      case CurrentPlayerState.video:
        return PlayingVideoScreen(
          controller: controller.videoPlayerController!,
        );
    }
  }

  List<Widget> _properSpace() {
    if (controller.source is Video) {
      return [
        YTInfoScreen(video: controller.source),
      ];
    }
    if (controller.source is FavoriteVideo) {
      return [
        FavoriteInfoScreen(fav: controller.source),
      ];
    }
    return [];
  }
}
