import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_tube/src/screen/search_list_screen/search_list_screen.dart';
import 'package:getx_tube/src/service/yt_service.dart';
import 'package:get/get.dart';

class SearchQController extends GetxController {
  final RxList<String> suggests = RxList<String>();

  String _searchText = "";
  Timer? _searchTimer;

  final ytSearvice = YTService();

  bool get noSuggest {
    return suggests.isEmpty;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _searchTimer?.cancel();
  }

  void getSuggest(String q) {
    suggests.clear();
    _searchText = q;
    _searchTimer?.cancel();

    try {
      if (_searchText.length >= 2)
        _searchTimer = Timer(Duration(milliseconds: 500), () async {
          final temp = await ytSearvice.getSuggestion(q);

          suggests.addAll(temp);
        });
    } catch (e) {
      print(e.toString());
    }
  }

  void pushListScreen(String q) {
    Get.toNamed(SearchListScreen.routeName, arguments: q);
  }
}
