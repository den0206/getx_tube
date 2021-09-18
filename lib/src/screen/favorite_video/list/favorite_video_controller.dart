import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/screen/favorite_video/detail/detail_favorite_screen.dart';
import 'package:getx_tube/src/service/download_manager.dart';
import 'package:getx_tube/src/service/get_storage.service.dart';
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

  void pushDetailFav(FavoriteVideo fav) {
    Get.toNamed(DetailFavoriteScreen.routeName, arguments: fav);
  }

  void deleteFav(FavoriteVideo fav) {
    if (favorite.contains(fav)) {
      DownloadManager.to.deleteFile(fav);
      favorite.remove(fav);
    }

    database.setArray(DatabaseKey.favorits, favorite);
    update();
  }
}
