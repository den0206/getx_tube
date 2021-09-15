import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

import 'package:getx_tube/src/screen/search_list_screen/search_list_controller.dart';
import 'package:getx_tube/src/screen/search_list_screen/search_list_screen.dart';
import 'package:getx_tube/src/screen/search_q/search_q_controller.dart';
import 'package:getx_tube/src/screen/search_q/search_q_screen.dart';
import 'package:getx_tube/src/screen/video_detail/video_detail_screen.dart';
import 'package:getx_tube/src/service/database_service.dart';
import 'package:sizer/sizer.dart';

void main() async {
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
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        darkTheme: ThemeData.light(),
        getPages: [
          GetPage(
            name: SearchListScreen.routeName,
            page: () => SearchListScreen(),
            binding: SearchListBinding(),
          ),
          GetPage(
            name: VideoDetailScreen.routeName,
            page: () => VideoDetailScreen(),
            // binding: VideoDetailBinding(),
          )
        ],
        initialBinding: InitialBinding(),
        home: SearchQScreen(),
      );
    });
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SharedPrefService());
    Get.put(SearchQController());
  }
}
