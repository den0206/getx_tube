import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/screen/favorite_video/detail/detail_favorite_controller.dart';
import 'package:getx_tube/src/screen/favorite_video/detail/detail_favorite_screen.dart';
import 'package:getx_tube/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_tube/src/service/download_manager.dart';
import 'package:getx_tube/src/service/get_storage.service.dart';
import 'package:getx_tube/src/service/playing_service.dart';
import 'package:getx_tube/src/service/shared_Pref_service.dart';

class FavoriteVideoController extends GetxController {
  static FavoriteVideoController get to => Get.find();
  final List<FavoriteVideo> favorite = [];

  final GetStorageServide database = GetStorageServide.to;

  @override
  void onInit() {
    super.onInit();

    loadFavorite();
  }

  void loadFavorite() {
    final temp = database.loadArray(DatabaseKey.favorits);

    if (temp.isNotEmpty) {
      favorite.addAll(temp as List<FavoriteVideo>);
    }
  }

  void pushDetailFav(FavoriteVideo fav) async {
    PlayingService.to.setSorce(fav);

    final _ = await Get.to(
      () => DetailFavoriteScreen(),
      arguments: fav,
      binding: DetailFavoriteBinding(),
      id: MainTabController.to.currentIndex,
    );

    update();

    // final _ = await Get.toNamed(DetailFavoriteScreen.routeName, arguments: fav);
    // update();
  }

  void deleteFav(FavoriteVideo fav) {
    if (favorite.contains(fav)) {
      DownloadManager.to.deleteFile(fav);
      favorite.remove(fav);
    }

    database.setArray(DatabaseKey.favorits, favorite);
    update();
  }

  void deleteAllFav() {
    if (favorite.isEmpty) {
      return;
    }

    favorite.forEach((fav) {
      DownloadManager.to.deleteFile(fav);
    });

    database.deleteKey(DatabaseKey.favorits);
    update();
  }
}
