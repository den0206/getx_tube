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

  final ytSearvice = YTService();
  late SearchList searchList;
  RxList<Video> videos = RxList<Video>();

  var _endResults = false;
  var loading = false;

  @override
  void onInit() async {
    super.onInit();

    await setVideos();
  }

  @override
  void onClose() {
    ytSearvice.yt.close();
    super.onClose();
  }

  Future<void> setVideos() async {
    searchList = await ytSearvice.getSerchList(q);

    if (searchList.isEmpty) {
      _endResults = true;
    }

    videos.addAll(searchList.toList());
  }

  Future<void> fetchMore() async {
    if (_endResults) {
      return;
    }

    loading = true;

    try {
      final result = await searchList.nextPage();

      if (result == null) {
        _endResults = true;
        return;
      }

      videos.addAll(result.toList());
    } catch (e) {
      print(e.toString());
    } finally {
      loading = false;
    }
  }

  void pushVideoDetailScreen(Video video) {
    Get.toNamed(VideoDetailScreen.routeName, arguments: video);
  }
}
