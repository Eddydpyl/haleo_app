import 'dart:async';

import 'package:flutter/material.dart';

import 'localization.dart';

class HaleoLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const HaleoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) => LocalizationLoader.load();

  @override
  bool shouldReload(HaleoLocalizationsDelegate old) => false;
}