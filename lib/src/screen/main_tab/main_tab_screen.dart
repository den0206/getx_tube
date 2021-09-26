import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_tube/src/screen/player/mini_player.dart';

class MainTabScreen extends GetView<MainTabController> {
  const MainTabScreen({Key? key}) : super(key: key);
  static const routeName = '/MainTab';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainTabController>(
      init: MainTabController(),
      builder: (_) {
        return Scaffold(
          body: IndexedStack(
            children: controller.menuPages,
            index: controller.currentIndex,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MiniPlayerArea(),
              BottomNavigationBar(
                elevation: 0,
                selectedItemColor: Colors.redAccent,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex,
                items: controller.item,
                onTap: controller.setIndex,
              ),
            ],
          ),
        );
      },
    );
  }
}



  //  Expanded(
  //                 child: Align(
  //               alignment: Alignment.center,
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8),
  //                 child: AspectRatio(
  //                   aspectRatio: 3 / 2,
  //                   child: _playngScreen(),
  //                 ),
  //               ),
  //             )),

