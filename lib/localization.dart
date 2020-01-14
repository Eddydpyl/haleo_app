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
      }
      _init = true;
    }
    return Future.wait(futures).then((_) => Localization());
  }
}

class Localization {
  static final Localization _localization = Localization._internal();

  factory Localization() {
    return _localization;
  }

  Localization._internal();

  String invalidEmailText() => Intl.message(
        "The email address is not valid.",
        name: "invalidEmailText",
        args: [],
      );

  String invalidPasswordText() => Intl.message(
        "The password must be at least 6 characters long.",
        name: "invalidPasswordText",
        args: [],
      );

  String usedEmailText() => Intl.message(
        "The email address is already in use.",
        name: "usedEmailText",
        args: [],
      );

  String invalidSignInText() => Intl.message(
        "Either the email or password are incorrect.",
        name: "invalidSignInText",
        args: [],
      );

  String disabledUserText() => Intl.message(
        "Your user has been disabled by an administrator.",
        name: "disabledUserText",
        args: [],
      );

  String errorSignInText() => Intl.message(
        "There was an issue and you could not sign in.",
        name: "errorSignInText",
        args: [],
      );

  String errorSignUpText() => Intl.message(
        "There was an issue and you could not sign up.",
        name: "errorSignUpText",
        args: [],
      );

  String passwordSentText() => Intl.message(
        "A password reset link has been sent to your email.",
        name: "passwordSentText",
        args: [],
      );

  String accountNotFoundText() => Intl.message(
        "An account with the provided email does not exist.",
        name: "accountNotFoundText",
        args: [],
      );

  String eventClosedText() => Intl.message(
        "The event has been closed!",
        name: "eventClosedText",
        args: [],
      );

  String uploadErrorText() => Intl.message(
        "There was an unexpected issue and the file could not be uploaded.",
        name: "uploadErrorText",
        args: [],
      );

  String locationPermissionText() => Intl.message(
        "We need your location to create an event.",
        name: "locationPermissionText",
        args: [],
      );

  String locationErrorText() => Intl.message(
        "There was an error retrieving your location.",
        name: "locationErrorText",
        args: [],
      );

  String userUpdatedText() => Intl.message(
        "Your user profile has been updated.",
        name: "userUpdatedText",
        args: [],
      );

  String messageHintText() => Intl.message(
        "Write a message",
        name: "messageHintText",
        args: [],
      );

  String slotsNumberText() => Intl.message(
        "Minimum number of attendees?",
        name: "slotsNumberText",
        args: [],
      );

  String eventTitleHintText() => Intl.message(
        "Have a beer, go for a walk, visit the cathedral ...",
        name: "eventTitleHintText",
        args: [],
      );

  String eventBodyHintText() => Intl.message(
        "What would you like to do? What languages do you speak? At what time would you be free?",
        name: "eventBodyHintText",
        args: [],
      );

  String eventExitText(String name) => Intl.message(
        "Leave $name",
        name: "eventExitText",
        args: [name],
      );

  String exitPromtText() => Intl.message(
        "Are you sure you want to leave?",
        name: "exitPromtText",
        args: [],
      );

  String exitNoText() => Intl.message(
        "NO",
        name: "exitNoText",
        args: [],
      );

  String exitYesText() => Intl.message(
        "YES, GET ME OUT!",
        name: "exitYesText",
        args: [],
      );

  String eventEmptyFilledText() => Intl.message(
        "Whoops! \n There are no filled events yet. Keep swiping right!",
        name: "eventEmptyFilledText",
        args: [],
      );

  String emptyProfile() => Intl.message(
        "Whoops! \n We are working on some awesome features for your profile! \n Points, titles and analytics are coming soon!",
        name: "emptyProfile",
        args: [],
      );

  String eventEmptyReadText() => Intl.message(
        "No more events to check out. \n Why not create your own?",
        name: "eventEmptyReadText",
        args: [],
      );

  String haleoText() => Intl.message(
        "haleo!",
        name: "haleoText",
        args: [],
      );

  String promoText() => Intl.message(
        "Find events near you. \n You are only a click away!",
        name: "promoText",
        args: [],
      );

  String signInText() => Intl.message(
        "Sign In",
        name: "signInText",
        args: [],
      );

  String shareText(String name, String description) => Intl.message(
        "Join this haleo! : *${name}* \n _${description}_ \n Download the app in Google Play! https://play.google.com/apps/testing/io.darter.haleo",
        name: "shareText",
        args: [name, description],
      );

  String eventCreatedText() => Intl.message(
        "Your event has been created! Now we wait for more attendees.",
        name: "eventCreatedText",
        args: [],
      );

  String attendeesText(int slots, int count) {
    final int spaces = slots - count;
    return "${_attendeesCountText(count)} ${_attendeesSpacesText(spaces)}";
  }

  String _attendeesCountText(int count) => Intl.plural(
        count,
        one: "A total of $count has signed up.",
        other: "A total of $count have signed up.",
        name: "_attendeesCountText",
        args: [count],
      );

  String _attendeesSpacesText(int spaces) => Intl.plural(
        spaces,
        one: "Only $spaces space remains!",
        other: "Only $spaces spaces remain!",
        name: "_attendeesSpacesText",
        args: [spaces],
      );

  String createText() => Intl.message(
        "Create",
        name: "createText",
        args: [],
      );

  String profileText() => Intl.message(
        "Your face!",
        name: "profileText",
        args: [],
      );

  String yourText() => Intl.message(
        "Your",
        name: "yourText",
        args: [],
      );

  String existingAccountText() => Intl.message(
        "There's already an account using this email. Try loggin in using another provider.",
        name: "existingAccountText",
        args: [],
      );
}
