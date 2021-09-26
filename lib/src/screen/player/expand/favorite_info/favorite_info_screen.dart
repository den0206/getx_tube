import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/screen/favorite_video/list/favorite_video_controller.dart';
import 'package:getx_tube/src/screen/widget/custom_buton.dart';

import 'favorite_info_controller.dart';

class FavoriteInfoScreen extends GetView<FavoriteInfoController> {
  const FavoriteInfoScreen({
    Key? key,
    required this.fav,
  }) : super(key: key);

  final FavoriteVideo fav;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteInfoController>(
      init: FavoriteInfoController(fav: fav),
      builder: (_) {
        return Column(
          children: [
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
                  }
                },
              ),
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
      },
    );
  }
}
