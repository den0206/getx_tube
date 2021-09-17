import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/service/get_storage.service.dart';
import 'package:getx_tube/src/service/shared_Pref_service.dart';

class FavoriteVideoService extends GetxController {
  static FavoriteVideoService get to => Get.find();
  final List<FavoriteVideo> favorite = [];

  @override
  void onInit() {
    super.onInit();

    loadFavorite();
  }

  void loadFavorite() {
    final temp = GetStorageServide.to.loadArray(DatabaseKey.favorits);

    if (temp.isNotEmpty) {
      favorite.addAll(temp as List<FavoriteVideo>);
    }
  }
}
