import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getx_tube/src/service/download_manager.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTService {
  final yt = YoutubeExplode();

  Future<List<String>> getSuggestion(String q) async {
    final suggestList = await yt.search.getQuerySuggestions(q);

    return suggestList;
  }

  Future<SearchList> getSerchList(String q) async {
    final searchList = await yt.search.getVideos(q);

    return searchList;
  }

  Future<void> getStreamInfo(VideoId id) async {
    var manifest = await yt.videos.streamsClient.getManifest(id);
    var streamInfo = manifest.muxed.withHighestBitrate();
    print(streamInfo);
  }

  Future<CommentsList?> getComments(Video video) async {
    final comment = await yt.videos.commentsClient.getComments(video);

    return comment;
  }

  Future<Channel> getChannel(ChannelId id) async {
    final channel = await yt.channels.get(id);
    return channel;
  }

  Future<void> downloadVideo(String videoId,
      {RxDouble? progress, bool? cancel}) async {
    final directory = DownloadManager.to.videoDir;
    await directory.create(recursive: true);

    final file = File("${directory.path}$videoId.mp4");
    // print(file.path);
    final existFile = await file.exists();
    if (!existFile) {
      var output = file.openWrite(mode: FileMode.writeOnlyAppend);

      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var streamInfo = manifest.muxed.withHighestBitrate();
      final ytStream = yt.videos.streamsClient.get(streamInfo);

      double len = streamInfo.size.totalBytes.toDouble();
      double count = 0;

      await for (final data in ytStream) {
        count += data.length.toDouble();
        progress?.value = ((count / len) / 1);
        print(progress);
        if (cancel != null && cancel) {
          Get.back();
        }
        output.add(data);
      }

      await output.flush();
      await output.close();

      DownloadManager.to.downloads[videoId] = file;
    }
  }
}
