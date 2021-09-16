import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/main_tab/main_tab_controller.dart';

class MainTabScreen extends GetView<MainTabController> {
  const MainTabScreen({Key? key}) : super(key: key);
  static const routeName = '/MainTab';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainTabController>(
      init: MainTabController(),
      builder: (_) {
        return Scaffold(
          body: controller.currentPage,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.currentIndex,
            items: controller.item,
            onTap: controller.setIndex,
          ),
        );
      },
    );
  }
}
