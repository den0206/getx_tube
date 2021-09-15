import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService extends GetxController {
  static SharedPrefService get to => Get.find();

  void savePredicts(List<String> predicts) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (predicts.length >= 12) {
      predicts.removeAt(0);
    }
    await myPrefs.setStringList(DatabaseKey.predicts, predicts);
  }

  Future<List<String>> loadPredicts() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final temp = myPrefs.getStringList(DatabaseKey.predicts);

    return temp ?? [];
  }
}

class DatabaseKey {
  static String predicts = "predicts";
}
