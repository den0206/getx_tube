import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/screen/favorite_video/list/favorite_video_controller.dart';
import 'package:getx_tube/src/screen/widget/loading_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:getx_tube/src/screen/search_list_screen/search_list_screen.dart';

class FavoriteVideoScreen extends GetView<FavoriteVideoController> {
  const FavoriteVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お気に入り'),
      ),
      body: GetBuilder<FavoriteVideoController>(
        builder: (_) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 1,
            ),
            itemCount: controller.favorite.length,
            itemBuilder: (BuildContext context, int index) {
              final fav = controller.favorite[index];

              return FavoriteCell(fav: fav);
            },
          );
        },
      ),
    );
  }
}

class FavoriteCell extends GetView<FavoriteVideoController> {
  const FavoriteCell({
    Key? key,
    required this.fav,
  }) : super(key: key);

  final FavoriteVideo fav;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(fav.id),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.close,
          onTap: () {
            controller.deleteFav(fav);
          },
        ),
      ],
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              controller.pushDetailFav(fav);
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
                        fav.title,
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
                        CachedNetworkImage(
                          imageUrl: fav.thumbnail,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          progressIndicatorBuilder: (context, url, progress) =>
                              LoadingCellWidget(),
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 1.5.h),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Chip(
                              backgroundColor: Colors.black,
                              labelStyle: TextStyle(
                                  color: Colors.white, fontSize: 9.sp),
                              label: Text(
                                fav.duration?.toHoursMinutesSeconds() ??
                                    "00:00",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
