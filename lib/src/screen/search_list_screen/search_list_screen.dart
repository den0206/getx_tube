import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/search_list_screen/search_list_controller.dart';
import 'package:getx_tube/src/screen/widget/loading_widget.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:sizer/sizer.dart';

class SearchListScreen extends GetView<SerarchListController> {
  const SearchListScreen({Key? key}) : super(key: key);

  static const routeName = '/SearchList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.q),
      ),
      body: Obx(
        () => ListView.separated(
          separatorBuilder: (context, index) => Divider(
            height: 1,
          ),
          itemCount: controller.videos.length,
          itemBuilder: (context, index) {
            final video = controller.videos[index];

            if (index == controller.videos.length - 1) {
              controller.loadVieos();
              if (controller.loading) return LoadingCellWidget();
            }
            return VideoCell(video: video);
          },
        ),
      ),
    );
  }
}

class VideoCell extends GetView<SerarchListController> {
  const VideoCell({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(video.id.toString()),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        IconSlideAction(
          caption: !controller.isFavorite(video) ? 'Favorite' : "お気に入り済み",
          color: Colors.green,
          icon: Icons.favorite,
          onTap: () {
            if (!controller.isFavorite(video)) controller.addFavorite(video);
          },
        ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: () async {
            await controller.pushVideoDetailScreen(video);
          },
          child: Container(
            height: 15.h,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Text(
                      video.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        video.thumbnails.mediumResUrl,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.5.h),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Chip(
                            backgroundColor: Colors.black,
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 9.sp),
                            label: Text(
                                video.duration?.toHoursMinutesSeconds() ??
                                    "00:00"),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension DurationExtensions on Duration {
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes";
  }

  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(this.inSeconds.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
