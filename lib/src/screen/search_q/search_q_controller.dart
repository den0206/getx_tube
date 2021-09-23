import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_tube/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_tube/src/screen/search_list_screen/search_list_screen.dart';
import 'package:getx_tube/src/service/shared_Pref_service.dart';
import 'package:getx_tube/src/service/yt_service.dart';
import 'package:get/get.dart';

class SearchQController extends GetxController {
  final RxList<String> suggests = RxList<String>();
  final RxList<String> predicts = RxList<String>();

  final TextEditingController tX = TextEditingController();

  String searchText = "";
  Timer? _searchTimer;

  final ytSearvice = YTService();

  final SharedPrefService database = SharedPrefService.to;

  bool get noSuggest {
    return suggests.isEmpty;
  }

  @override
  void onInit() async {
    super.onInit();
    await loadPredicts();
  }

  @override
  void onClose() {
    super.onClose();
    _searchTimer?.cancel();
  }

  void getSuggest(String q) {
    suggests.clear();
    searchText = q;
    _searchTimer?.cancel();

    try {
      if (searchText.length >= 2)
        _searchTimer = Timer(Duration(milliseconds: 500), () async {
          final temp = await ytSearvice.getSuggestion(q);

          suggests.addAll(temp);
        });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadPredicts() async {
    final temp = await database.loadArray(DatabaseKey.predicts);
    predicts.addAll(temp);
  }

  void pushListScreen(String q) {
    if (!predicts.contains(q)) {
      predicts.add(q);
      database.saveArray(key: DatabaseKey.predicts, array: predicts);
    }
    Get.toNamed(
      SearchListScreen.routeName,
      arguments: q,
    );
  }

  void deletePredicts(String value) async {
    predicts.remove(value);

    database.saveArray(key: DatabaseKey.predicts, array: predicts);
  }
}
