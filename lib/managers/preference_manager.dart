import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../utility.dart';

class PreferenceManager {
  final StreamingSharedPreferences  _pref;

  PreferenceManager(this._pref);

  Preference<List<String>> viewed() => _pref.getStringList("viewed", defaultValue: []);
  void view(String key) => _pref.setStringList("viewed", viewed().getValue()..add(key));

  Preference<String> lastRead(String key) => _pref.getString(key, defaultValue: "");
  void read(String key) => _pref.setString(key, DateUtility.currentDate());
}