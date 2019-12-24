import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class PreferenceManager {
  final StreamingSharedPreferences  _pref;

  PreferenceManager(this._pref);

  Preference<List<String>> get viewed => _pref.getStringList("viewed", defaultValue: []);
  void view(String key) => _pref.setStringList("viewed", viewed.getValue()..add(key));
}