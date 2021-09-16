import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/service/favorite_video_service.dart';

class FavoriteVideoScreen extends GetView<FavoriteVideoService> {
  const FavoriteVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.favorite.length,
      itemBuilder: (BuildContext context, int index) {
        final video = controller.favorite[index];

        return ListTile(
          title: Text(video.id.toString()),
        );
      },
    );
  }
}
