import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_tube/src/screen/widget/video_player_screen.dart';
import 'package:getx_tube/src/service/playing_service.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MainTabScreen extends GetView<MainTabController> {
  const MainTabScreen({Key? key}) : super(key: key);
  static const routeName = '/MainTab';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainTabController>(
      init: MainTabController(),
      builder: (_) {
        return Scaffold(
          body: IndexedStack(
            children: controller.menuPages,
            index: controller.currentIndex,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlayingScreen(),
              BottomNavigationBar(
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex,
                items: controller.item,
                onTap: controller.setIndex,
              ),
            ],
          ),
        );
      },
    );
  }
}

class PlayingScreen extends GetView<PlayingService> {
  const PlayingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayingService>(
      init: PlayingService(),
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(width: 1, color: Colors.white),
            bottom: BorderSide(color: Colors.white),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 20.w,
                width: 25.w,
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: _playngScreen(),
                ),
              ),
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
            ],
          ),
        );
      },
    );
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
}

  //  Expanded(
  //                 child: Align(
  //               alignment: Alignment.center,
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8),
  //                 child: AspectRatio(
  //                   aspectRatio: 3 / 2,
  //                   child: _playngScreen(),
  //                 ),
  //               ),
  //             )),

