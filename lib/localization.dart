import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'l10n/messages_all.dart';

class Language {
  static const String EN = "en";
  static const String ES = "es";
}

class LocalizationLoader {
  static const List<String> _locales = const [Language.EN, Language.ES];
  static bool _init = false;

  static Future<Localization> load() {
    List<Future> futures = List();
    if (!_init) {
      for (String locale in _locales) {
        futures.add(initializeMessages(locale));
        futures.add(initializeDateFormatting(locale));
      } _init = true;
    } return Future.wait(futures).then((_) => Localization());
  }
}

class Localization {
  static final Localization _localization = new Localization._internal();

  factory Localization() {
    return _localization;
  }

  Localization._internal();

  String placeholderText() =>
      Intl.message(
        "PLACEHOLDER",
        name: "placeholderText",
        args: [],
      );
}