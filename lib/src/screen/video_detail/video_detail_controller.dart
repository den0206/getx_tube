import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_tube/src/service/yt_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoDetailController());
  }
}

class VideoDetailController extends GetxController {
  final Video video = Get.arguments;

  late YoutubePlayerController ytController;
  final YTService ytService = YTService();
  final List<Comment> comments = [];

  CommentsList? currentPage;
  Channel? videoChannel;
  var _endResults = false;
  var loading = false;

  @override
  void onInit() async {
    super.onInit();
    loadVideo();
    await loadChannel();
    await loadCommens();
  }

  @override
  void onClose() {
    super.onClose();
    ytController.dispose();
    ytService.yt.close();
  }

  void loadVideo() {
    ytController = YoutubePlayerController(
      initialVideoId: video.id.toString(),
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: video.isLive,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  Future<void> loadCommens() async {
    if (_endResults) {
      return;
    }

    // loading = true;

    // update();
    try {
      CommentsList? result;

      if (comments.isEmpty) {
        result = await ytService.getComments(video);
      } else {
        print("more");
        result = await currentPage!.nextPage();
      }

      if (result == null) {
        _endResults = true;
      } else {
        currentPage = result;
        comments.addAll(result.toList());
      }
      update();

      print(comments.length);
    } catch (e) {
      _endResults = true;
      print(e.toString());
    } finally {
      loading = false;
    }
  }

  Future<void> loadChannel() async {
    videoChannel = await ytService.getChannel(video.channelId);
    update();
  }
}
