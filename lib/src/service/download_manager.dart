import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/model/favorite_video.dart';
import 'package:path_provider/path_provider.dart';

class DownloadManager extends GetxService {
  static DownloadManager get to => Get.find();

  late Directory videoDir;
  final Map<String, File> downloads = {};

  @override
  void onInit() async {
    super.onInit();

    await init();
  }

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path;
    videoDir = Directory('$path/video/');

    final List<FileSystemEntity> entities = await videoDir.list().toList();
    final List<File> files = entities.whereType<File>().toList();
    files.forEach((file) {
      String fileName = file.path.split('/').last;
      final key = fileName.replaceAll(".mp4", "").trim();

      downloads[key] = file;
    });

    print(downloads.length);
    print(downloads);
  }

  void deleteFile(FavoriteVideo fav) async {
    final exist = await fav.dlFile?.exists() ?? false;
    if (exist) {
      await fav.dlFile!.delete();
    }
    await CachedNetworkImage.evictFromCache(fav.thumbnail);
    downloads.remove(fav.id);

    print("DELETE FAV");
  }
}
