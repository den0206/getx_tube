import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPrefService to = SharedPrefService();

  void saveArray({required String key, required List<String> array}) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (array.length >= 12) {
      array.removeAt(0);
    }
    if (key == DatabaseKey.predicts) {
      await myPrefs.setStringList(DatabaseKey.predicts, array);
    } else if (key == DatabaseKey.favorits) {
      await myPrefs.setStringList(DatabaseKey.favorits, array);
    }
  }

  Future<List<String>> loadArray(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    List<String>? temp;
    if (key == DatabaseKey.predicts) {
      temp = myPrefs.getStringList(DatabaseKey.predicts);
    } else if (key == DatabaseKey.favorits) {
      temp = myPrefs.getStringList(DatabaseKey.favorits);
    }

    return temp ?? [];
  }
}

class DatabaseKey {
  static String predicts = "predicts";
  static String favorits = "favorits";
}
