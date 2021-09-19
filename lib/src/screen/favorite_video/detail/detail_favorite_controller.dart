import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:get/get.dart';
import 'package:getx_tube/src/service/yt_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailFavoriteController());
  }
}

class DetailFavoriteController extends GetxController {
  final FavoriteVideo fav = Get.arguments;

  final YTService yt = YTService();
  YoutubePlayerController? ytController;

  @override
  void onInit() {
    super.onInit();
    if (!fav.isDownloaded) loadVideo();
  }

  @override
  void onClose() {
    yt.yt.close();
    ytController?.dispose();
    super.onClose();
  }

  void loadVideo() {
    ytController = YoutubePlayerController(
      initialVideoId: fav.id.toString(),
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  Future<void> startDownload() async {
    RxDouble progres = 0.0.obs;
    bool cancel = false;

    final ft = yt.downloadVideo(fav.id, progress: progres, cancel: cancel);
    // final op = CancelableOperation.fromFuture(
    //   ft,
    //   onCancel: () => {cancel = true},
    // );

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
