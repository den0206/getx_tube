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

  Future<Channel> getChannel(ChannelId id) async {
    final channel = await yt.channels.get(id);
    return channel;
  }
}
