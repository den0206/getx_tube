import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/service/database_service.dart';
import 'package:getx_tube/src/service/yt_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class FavoriteVideoService extends GetxController {
  static FavoriteVideoService get to => Get.find();
  final List<Video> favorite = [];
  final ytService = YTService();
  @override
  void onInit() async {
    super.onInit();

    await loadFavorite();
  }

  Future<void> loadFavorite() async {
    final List<String> localFavorite =
        await SharedPrefService.to.loadArray(DatabaseKey.favorits);

    if (localFavorite.isNotEmpty) {
      await Future.forEach(
        localFavorite,
        (id) async {
          final video = await ytService.yt.videos.get(id);
          favorite.add(video);
        },
      );
    }
  }
}
