import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/service/yt_service.dart';

class FavoriteInfoController extends GetxController {
  FavoriteInfoController({
    required this.fav,
  });

  final FavoriteVideo fav;
  final YTService yt = YTService();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    yt.yt.close();
  }

  Future<void> startDownload() async {
    RxDouble progres = 0.0.obs;
    bool cancel = false;

    final ft = yt.downloadVideo(fav.id, progress: progres, cancel: cancel);

    await Get.showOverlay(
      asyncFunction: () => ft,
      loadingWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            width: 300,
            height: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Obx(
                () => LinearProgressIndicator(
                  value: progres.value,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00ff00)),
                  backgroundColor: Color(0xffD6D6D6),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    update();
  }
}
