import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/video_detail/video_detail_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:sizer/sizer.dart';

class VideoDetailScreen extends GetView<VideoDetailController> {
  const VideoDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/VideoDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        maintainBottomViewPadding: true,
        child: YoutubePlayerBuilder(
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: _ytPlayer(),
          builder: (context, player) {
            return Column(
              children: [
                player,
                SizedBox(
                  height: 3.h,
                ),
                _header(),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    shrinkWrap: true,
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("$index"),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Padding _header() {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Wrap(
        // spacing: 8,
        runSpacing: 2.h,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Text(
              controller.video.title,
              maxLines: 2,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                // backgroundImage: NetworkImage(
                //     controller.videoChannel?.logoUrl ?? ""),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "${controller.video.engagement.viewCount} 回",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  YoutubePlayer _ytPlayer() {
    return YoutubePlayer(
      controller: controller.ytController,
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
            controller.video.title,
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
          onPressed: () {
            print('Settings Tapped!');
          },
        ),
      ],
      onReady: () {
        controller.ytController.play();
      },
      onEnded: (data) {
        controller.ytController.pause();
      },
    );
  }
}


  // Row(
   //   children: [
   //     Column(
   //       children: [
   //         Icon(
   //           Icons.thumb_up_off_alt_outlined,
   //           size: 25.sp,
   //         ),
   //         Text("高評価"),
   //         Text(controller.video.engagement.likeCount
   //             .toString()),
   //       ],
   //     ),
   //     Icon(
   //       Icons.thumb_down_off_alt_outlined,
   //     ),
   //   ],
   // ),