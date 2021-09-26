import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:getx_tube/src/screen/player/expand/yt_info/yt_info_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class YTInfoScreen extends StatelessWidget {
  const YTInfoScreen({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YTInfoController>(
      init: YTInfoController(video: video),
      builder: (info) {
        final Video video = info.video;
        return Column(
          children: [
            Padding(
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
                            backgroundImage: info.videoChannel != null
                                ? NetworkImage(info.videoChannel!.logoUrl)
                                : null),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            video.title,
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${video.engagement.viewCount} 回",
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
                          video.engagement.likeCount != null
                              ? video.engagement.likeCount.toString()
                              : "高評価",
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        _thumbUpIcon(
                          Icons.thumb_down_off_alt_outlined,
                          video.engagement.dislikeCount != null
                              ? video.engagement.dislikeCount.toString()
                              : "低評価",
                        ),
                        Spacer(),
                        Text(video.publishDate != null
                            ? timeago.format(video.publishDate!)
                            : ''),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        );
      },
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
}
