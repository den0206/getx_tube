import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/favorite_video/list/favorite_video_screen.dart';
import 'package:getx_tube/src/screen/search_q/search_q_screen.dart';

class MainTabController extends GetxController {
  static MainTabController get to => Get.find();
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

  List<Widget> get menuPages {
    final map = pages.asMap();
    final List<_TabNav> res = [];

    map.forEach((key, value) {
      final tab = _TabNav(key, value);
      res.add(tab);
    });

    return res;
  }

  Widget get currentPage {
    return pages[currentIndex];
  }

  void setIndex(int value) {
    currentIndex = value;
    update();
  }
}

class _TabNav extends GetView<MainTabController> {
  final int index;
  final Widget child;

  _TabNav(this.index, this.child);
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(index),
      observers: [GetObserver((_) {}, Get.routing)],
      onGenerateRoute: (settings) {
        Get.routing.args = settings.arguments;
        return MaterialPageRoute(builder: (_) => child);
      },
    );
  }
}
