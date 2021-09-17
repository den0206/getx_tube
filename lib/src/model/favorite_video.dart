import 'dart:convert';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class FavoriteVideo {
  final String id;
  final String title;
  final Duration? duration;
  final String thumbnail;

  FavoriteVideo({
    required this.id,
    required this.title,
    required this.duration,
    required this.thumbnail,
  });

  factory FavoriteVideo.fromVideo(Video video) {
    return FavoriteVideo(
      id: video.id.toString(),
      title: video.title,
      duration: video.duration,
      thumbnail: video.thumbnails.mediumResUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id.toString(),
      "title": title,
      "duration": duration?.inSeconds,
      "thumbnail": thumbnail,
    };
  }

  static String encode(List<FavoriteVideo> favs) {
    return json.encode(favs.map((video) => video.toMap()).toList());
  }

  factory FavoriteVideo.fromMap(Map<String, dynamic> map) {
    final duration =
        map["duration"] != null ? Duration(seconds: map["duration"]) : null;

    return FavoriteVideo(
      id: map["id"],
      title: map["title"],
      duration: duration,
      thumbnail: map["thumbnail"],
    );
  }

  static List<FavoriteVideo> decode(String favs) {
    return (json.decode(favs) as List<dynamic>)
        .map((item) => FavoriteVideo.fromMap(item))
        .toList();
  }
}