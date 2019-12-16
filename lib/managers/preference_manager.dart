import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  final SharedPreferences _pref;

  PreferenceManager(this._pref);

  List<String> get viewed => _pref.getStringList("viewed") ?? [];
  set viewed(List<String> viewed) => _pref.setStringList("viewed", viewed ?? []);

  void view(String key) => viewed = viewed..add(key);

  String get lang => _pref.getString("lang");
  set lang(String lang) => _pref.setString("lang", lang);
}