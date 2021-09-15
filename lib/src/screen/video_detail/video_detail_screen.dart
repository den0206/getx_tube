import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/video_detail/video_detail_controller.dart';
import 'package:getx_tube/src/screen/widget/loading_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoDetailScreen extends GetView<VideoDetailController> {
  const VideoDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/VideoDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          maintainBottomViewPadding: true,
          child: GetBuilder<VideoDetailController>(
            init: VideoDetailController(),
            builder: (_) {
              return YoutubePlayerBuilder(
                onExitFullScreen: () {
                  SystemChrome.setPreferredOrientations(
                      DeviceOrientation.values);
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
                          // shrinkWrap: true,
                          itemCount: controller.comments.length,
                          itemBuilder: (context, index) {
                            final comment = controller.comments[index];

                            if (index == controller.comments.length - 1) {
                              controller.loadCommens();
                              if (controller.loading)
                                return LoadingCellWidget();
                            }
                            return ListTile(
                              title: Text(comment.text),
                            );
                          },
                        ),
                      )
                    ],
                  );
                },
              );
            },
          )),
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
            child: Row(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    backgroundImage: controller.videoChannel != null
                        ? NetworkImage(controller.videoChannel!.logoUrl)
                        : null),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    controller.video.title,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${controller.video.engagement.viewCount} 回",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _thumbUpIcon(
                  Icons.thumb_up_off_alt_outlined,
                  controller.video.engagement.likeCount != null
                      ? controller.video.engagement.likeCount.toString()
                      : "高評価",
                ),
                SizedBox(
                  width: 5.w,
                ),
                _thumbUpIcon(
                  Icons.thumb_down_off_alt_outlined,
                  controller.video.engagement.dislikeCount != null
                      ? controller.video.engagement.dislikeCount.toString()
                      : "低評価",
                ),
                Spacer(),
                Text(controller.video.publishDate != null
                    ? timeago.format(controller.video.publishDate!)
                    : ''),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Column _thumbUpIcon(IconData icon, String title) {
    return Column(
      children: [
        Icon(
          icon,
          size: 25.sp,
        ),
        SizedBox(
          height: 2,
        ),
        Text(title),
      ],
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
          onPressed: () async {
            await controller.loadCommens();
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
