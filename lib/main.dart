import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getx_tube/src/screen/favorite_video/detail/detail_favorite_controller.dart';
import 'package:getx_tube/src/screen/favorite_video/detail/detail_favorite_screen.dart';
import 'package:getx_tube/src/screen/main_tab/main_tab_screen.dart';

import 'package:getx_tube/src/screen/search_list_screen/search_list_controller.dart';
import 'package:getx_tube/src/screen/search_list_screen/search_list_screen.dart';
import 'package:getx_tube/src/screen/search_q/search_q_controller.dart';
import 'package:getx_tube/src/screen/video_detail/video_detail_screen.dart';
import 'package:getx_tube/src/screen/favorite_video/list/favorite_video_controller.dart';
import 'package:getx_tube/src/service/download_manager.dart';
import 'package:getx_tube/src/service/get_storage.service.dart';
import 'package:sizer/sizer.dart';

void main() async {
  await Get.put(GetStorageServide()).initStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
          ),
          dividerColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          scaffoldBackgroundColor: Colors.black,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
          ),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        darkTheme: ThemeData.light(),
        getPages: [
          GetPage(
            name: MainTabScreen.routeName,
            page: () => MainTabScreen(),
          ),
          GetPage(
            name: SearchListScreen.routeName,
            page: () => SearchListScreen(),
            binding: SearchListBinding(),
          ),
          GetPage(
            name: VideoDetailScreen.routeName,
            page: () => VideoDetailScreen(),
            // binding: VideoDetailBinding(),
          ),
          GetPage(
            name: DetailFavoriteScreen.routeName,
            page: () => DetailFavoriteScreen(),
            binding: DetailFavoriteBinding(),
          ),
        ],
        initialBinding: InitialBinding(),
        initialRoute: MainTabScreen.routeName,
      );
    });
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DownloadManager());
    Get.put(FavoriteVideoController());
    Get.put(SearchQController());
  }
}
