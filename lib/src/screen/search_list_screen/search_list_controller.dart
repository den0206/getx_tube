import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_tube/src/screen/video_detail/video_detail_screen.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:getx_tube/src/service/yt_service.dart';

class SearchListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SerarchListController());
  }
}

class SerarchListController extends GetxController {
  final String q = Get.arguments;
  RxList<Video> videos = RxList<Video>();

  final ytSearvice = YTService();
  late SearchList currentPage;

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

    Get.toNamed(VideoDetailScreen.routeName, arguments: videoIncleWatch);
  }
}
