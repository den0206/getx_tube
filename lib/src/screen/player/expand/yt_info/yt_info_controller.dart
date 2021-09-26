import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/service/yt_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTInfoController extends GetxController {
  YTInfoController({
    required this.video,
  });

  final Video video;
  Channel? videoChannel;
  final YTService ytService = YTService();

  @override
  void onInit() async {
    super.onInit();

    await loadChannel();
  }

  @override
  void onClose() {
    super.onClose();
    ytService.yt.close();
  }

  Future<void> loadChannel() async {
    videoChannel = await ytService.getChannel(video.channelId);
    update();
  }
}
