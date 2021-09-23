import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/favorite_video/detail/detail_favorite_controller.dart';
import 'package:getx_tube/src/screen/favorite_video/list/favorite_video_controller.dart';
import 'package:getx_tube/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_tube/src/screen/widget/common_yt_player.dart';
import 'package:getx_tube/src/screen/widget/custom_buton.dart';
import 'package:getx_tube/src/screen/widget/video_player_screen.dart';
import 'package:getx_tube/src/service/life_cycle_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:sizer/sizer.dart';

class DetailFavoriteScreen extends GetView<DetailFavoriteController> {
  const DetailFavoriteScreen({Key? key}) : super(key: key);
  static const routeName = '/DetailFav';

  @override
  Widget build(BuildContext context) {
    return LifecycleWidget(
      callback: LifecycleCallback(),
      child: Scaffold(body: SafeArea(
        child: GetBuilder<DetailFavoriteController>(
          builder: (_) {
            if (!controller.fav.isDownloaded) {
              return YoutubePlayerBuilder(
                onExitFullScreen: () {
                  SystemChrome.setPreferredOrientations(
                      DeviceOrientation.values);
                },
                player: commonYTPlayer(
                  videoTitle: controller.fav.title,
                  ytController: controller.ytController!,
                ),
                builder: (context, player) {
                  return Column(
                    children: [
                      player,
                      _DetailFotter(),
                    ],
                  );
                },
              );
            } else {
              return Column(
                children: [
                  Container(
                    height: 30.h,
                    child: VideoPlayerScreen(favoriteVideo: controller.fav),
                  ),
                  _DetailFotter(),
                ],
              );
            }
          },
        ),
      )),
    );
  }
}

class _DetailFotter extends GetView<DetailFavoriteController> {
  const _DetailFotter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back(id: MainTabController.to.currentIndex);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CustomButton(
                mainColor:
                    !controller.fav.isDownloaded ? Colors.green : Colors.red,
                text: !controller.fav.isDownloaded ? "ダウンロードを行う" : "削除",
                onPress: () {
                  if (!controller.fav.isDownloaded) {
                    controller.startDownload();
                  } else {
                    FavoriteVideoController.to.deleteFav(controller.fav);
                    Get.back();
                  }
                },
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.grey,
          height: 3,
        ),
        SizedBox(
          height: 5,
        ),
        Text(controller.fav.dlFile?.path ?? ""),
      ],
    );
  }
}
