import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/favorite_video/detail/detail_favorite_controller.dart';
import 'package:getx_tube/src/screen/favorite_video/list/favorite_video_controller.dart';
import 'package:getx_tube/src/screen/widget/custom_buton.dart';
import 'package:sizer/sizer.dart';

class DetailFavoriteScreen extends GetView<DetailFavoriteController> {
  const DetailFavoriteScreen({Key? key}) : super(key: key);
  static const routeName = '/DetailFav';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.fav.title),
        ),
        body: GetBuilder<DetailFavoriteController>(
          builder: (_) {
            return Column(
              children: [
                Container(
                  height: 30.h,
                  child: CachedNetworkImage(
                    imageUrl: controller.fav.thumbnail,
                    fit: BoxFit.contain,
                  ),
                ),
                CustomButton(
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
                Divider(
                  color: Colors.grey,
                  height: 3,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(controller.fav.dlFile?.path ?? "")
              ],
            );
          },
        ));
  }
}
