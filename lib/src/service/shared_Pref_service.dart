import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPrefService to = SharedPrefService();

  void deleteKey(DatabaseKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.remove(key.keyString);
  }

  void saveArray(
      {required DatabaseKey key, required List<String> array}) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (array.length >= 12) {
      array.removeAt(0);
    }
    if (key == DatabaseKey.predicts) {
      await myPrefs.setStringList(DatabaseKey.predicts.keyString, array);
    }
  }

  Future<List<String>> loadArray(DatabaseKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    List<String>? temp;
    if (key == DatabaseKey.predicts) {
      temp = myPrefs.getStringList(DatabaseKey.predicts.keyString);
    }

    return temp ?? [];
  }
}

enum DatabaseKey {
  predicts,
  favorits,
}

extension DatabaseKeyEXT on DatabaseKey {
  String get keyString {
    switch (this) {
      case DatabaseKey.predicts:
        return "predicts";
      case DatabaseKey.favorits:
        return "favorits";
    }
  }
}
