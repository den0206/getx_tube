import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/favorite_video/favorite_video_screen.dart';
import 'package:getx_tube/src/screen/search_q/search_q_screen.dart';

class MainTabController extends GetxController {
  var currentIndex = 0;

  final List<BottomNavigationBarItem> item = [
    BottomNavigationBarItem(
      label: "検索",
      icon: Icon(Icons.search),
    ),
    BottomNavigationBarItem(
      label: "お気に入り",
      icon: Icon(Icons.favorite),
    ),
  ];

  final List<Widget> pages = [
    SearchQScreen(),
    FavoriteVideoScreen(),
  ];

  Widget get currentPage {
    return pages[currentIndex];
  }

  void setIndex(int value) {
    currentIndex = value;
    update();
  }
}
