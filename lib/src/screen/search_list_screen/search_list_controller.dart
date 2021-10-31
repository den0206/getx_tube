import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_tube/src/screen/favorite_video/list/favorite_video_controller.dart';
import 'package:getx_tube/src/service/audio_service.dart';
import 'package:getx_tube/src/service/get_storage.service.dart';
import 'package:getx_tube/src/screen/player/playing_service.dart';
import 'package:getx_tube/src/service/shared_Pref_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:getx_tube/src/service/yt_service.dart';

class SearchListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SerarchListController());
  }
}

abstract class routedWidget {
  static const routeName = '/';
}

class SerarchListController extends GetxController {
  final String q = Get.arguments;
  RxList<Video> videos = RxList<Video>();

  final ytSearvice = YTService();
  late SearchList currentPage;
  final favorite = FavoriteVideoController.to.favorite;

  var _endResults = false;
  var loading = false;

  @override
  void onInit() async {
    super.onInit();

    await loadVieos();
  }

  @override
  void onClose() {
    ytSearvice.yt.close();
    super.onClose();
  }

  Future<void> loadVieos() async {
    if (_endResults) {
      return;
    }

    loading = true;

    try {
      SearchList? result;

      if (videos.isEmpty) {
        result = await ytSearvice.getSerchList(q);
      } else {
        result = await currentPage.nextPage();
      }

      if (result == null || result.isEmpty) {
        _endResults = true;
        return;
      }

      currentPage = result;

      videos.addAll(currentPage.toList());
    } catch (e) {
      print(e.toString());
    } finally {
      loading = false;
    }
  }

  Future<void> pushVideoDetailScreen(Video video) async {
    final videoIncleWatch = await ytSearvice.yt.videos.get(video.id);

    if (videoIncleWatch is Video) {
      // VideoHandler.to.setYtVideo(video);
      PlayingService.to.setSorce(videoIncleWatch);
      Get.back();
    }
    // Get.toNamed(VideoDetailScreen.routeName, arguments: videoIncleWatch);
  }

  void addFavorite(Video video) {
    if (video.isFavorite.value) {
      Get.back();
      MainTabController.to.setIndex(1);
      FavoriteVideoController.to.update();
      return;
    }

    final fav = FavoriteVideo.fromVideo(video);

    if (!video.isFavorite.value) {
      favorite.add(fav);
      GetStorageServide.to.setArray(DatabaseKey.favorits, favorite);
    }
  }
}
