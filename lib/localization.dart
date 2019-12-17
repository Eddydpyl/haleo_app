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
  static final Localization _localization = Localization._internal();

  factory Localization() {
    return _localization;
  }

  Localization._internal();

  String invalidEmailText() =>
      Intl.message(
        "The email address is not valid.",
        name: "invalidEmailText",
        args: [],
      );

  String invalidPasswordText() =>
      Intl.message(
        "The password must be at least 6 characters long.",
        name: "invalidPasswordText",
        args: [],
      );

  String usedEmailText() =>
      Intl.message(
        "The email address is already in use.",
        name: "usedEmailText",
        args: [],
      );

  String invalidSignInText() =>
      Intl.message(
        "Either the email or password are incorrect.",
        name: "invalidSignInText",
        args: [],
      );

  String disabledUserText() =>
      Intl.message(
        "Your user has been disabled by an administrator.",
        name: "disabledUserText",
        args: [],
      );

  String errorSignInText() =>
      Intl.message(
        "There was an issue and you could not sign in.",
        name: "errorSignInText",
        args: [],
      );

  String errorSignUpText() =>
      Intl.message(
        "There was an issue and you could not sign up.",
        name: "errorSignUpText",
        args: [],
      );

  String passwordSentText() =>
      Intl.message(
        "A password reset link has been sent to your email.",
        name: "passwordSentText",
        args: [],
      );

  String accountNotFoundText() =>
      Intl.message(
        "An account with the provided email does not exist.",
        name: "accountNotFoundText",
        args: [],
      );

  String eventFullText() =>
      Intl.message(
        "The event is already full!",
        name: "eventFullText",
        args: [],
      );

  String uploadErrorText() =>
      Intl.message(
        "There was an unexpected issue and the file could not be uploaded.",
        name: "uploadErrorText",
        args: [],
      );

  String locationPermissionText() =>
      Intl.message(
        "We need your location to crear an event.",
        name: "locationPermissionText",
        args: [],
      );

  String locationErrorText() =>
      Intl.message(
        "There was an error retrieving your location.",
        name: "locationErrorText",
        args: [],
      );
}