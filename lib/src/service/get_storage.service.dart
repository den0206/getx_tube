import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:getx_tube/src/service/shared_Pref_service.dart';

class GetStorageServide extends GetxService {
  static GetStorageServide get to => Get.find();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void setArray(DatabaseKey key, List<dynamic> array) {
    if (key == DatabaseKey.favorits && array.length >= 12) {
      array.remove(0);
    }
    switch (key) {
      case DatabaseKey.favorits:
        array as List<FavoriteVideo>;
        box.write(key.keyString, FavoriteVideo.encode(array));
        break;
      default:
        print("UN Authorozation Key");
        return;
    }

    print("Update local");
  }

  List<dynamic> loadArray(DatabaseKey key) {
    if (box.read(key.keyString) == null) {
      return [];
    } else {
      final String decode = box.read(key.keyString);

      switch (key) {
        case DatabaseKey.favorits:
          return FavoriteVideo.decode(decode);
        default:
          return [];
      }
    }
  }

  void deleteKey(DatabaseKey key) async {
    if (box.read(key.keyString) == null) {
      return;
    } else {
      await box.remove(key.keyString);
    }
  }
}
