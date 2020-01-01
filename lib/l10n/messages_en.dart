// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accountNotFoundText" : MessageLookupByLibrary.simpleMessage("An account with the provided email does not exist."),
    "disabledUserText" : MessageLookupByLibrary.simpleMessage("Your user has been disabled by an administrator."),
    "errorSignInText" : MessageLookupByLibrary.simpleMessage("There was an issue and you could not sign in."),
    "errorSignUpText" : MessageLookupByLibrary.simpleMessage("There was an issue and you could not sign up."),
    "eventClosedText" : MessageLookupByLibrary.simpleMessage("The event has been closed!"),
    "invalidEmailText" : MessageLookupByLibrary.simpleMessage("The email address is not valid."),
    "invalidPasswordText" : MessageLookupByLibrary.simpleMessage("The password must be at least 6 characters long."),
    "invalidSignInText" : MessageLookupByLibrary.simpleMessage("Either the email or password are incorrect."),
    "locationErrorText" : MessageLookupByLibrary.simpleMessage("There was an error retrieving your location."),
    "locationPermissionText" : MessageLookupByLibrary.simpleMessage("We need your location to create an event."),
    "passwordSentText" : MessageLookupByLibrary.simpleMessage("A password reset link has been sent to your email."),
    "uploadErrorText" : MessageLookupByLibrary.simpleMessage("There was an unexpected issue and the file could not be uploaded."),
    "usedEmailText" : MessageLookupByLibrary.simpleMessage("The email address is already in use.")
  };
}
