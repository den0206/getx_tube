import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:get/get.dart';
import 'package:getx_tube/src/service/yt_service.dart';

class DetailFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailFavoriteController());
  }
}

class DetailFavoriteController extends GetxController {
  final FavoriteVideo fav = Get.arguments;

  final YTService yt = YTService();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    yt.yt.close();
    super.onClose();
  }

  Future<void> startDownload() async {
    RxDouble progres = 0.0.obs;

    await Get.showOverlay(
      asyncFunction: () => yt.downloadVideo(fav.id, progress: progres),
      loadingWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => LinearProgressIndicator(
              value: progres.value,
            ),
          )
        ],
      ),
    );

    update();
  }
}
