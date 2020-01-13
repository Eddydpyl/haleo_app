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

  static m0(count) => "${Intl.plural(count, one: 'A total of ${count} has signed up.', other: 'A total of ${count} have signed up.')}";

  static m1(spaces) => "${Intl.plural(spaces, one: 'Only ${spaces} space remains!', other: 'Only ${spaces} spaces remain!')}";

  static m2(name) => "Leave ${name}";

  static m3(name, description) => "Join this haleo! : *${name}* \n _${description}_ \n Download the app in Google Play! https://play.google.com/apps/testing/io.darter.haleo";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "_attendeesCountText" : m0,
    "_attendeesSpacesText" : m1,
    "accountNotFoundText" : MessageLookupByLibrary.simpleMessage("An account with the provided email does not exist."),
    "createText" : MessageLookupByLibrary.simpleMessage("Create"),
    "disabledUserText" : MessageLookupByLibrary.simpleMessage("Your user has been disabled by an administrator."),
    "emptyProfile" : MessageLookupByLibrary.simpleMessage("Whoops! \n We are still working on some awesome features for your profile!"),
    "errorSignInText" : MessageLookupByLibrary.simpleMessage("There was an issue and you could not sign in."),
    "errorSignUpText" : MessageLookupByLibrary.simpleMessage("There was an issue and you could not sign up."),
    "eventBodyHintText" : MessageLookupByLibrary.simpleMessage("What would you like to do? What languages do you speak? At what time would you be free?"),
    "eventClosedText" : MessageLookupByLibrary.simpleMessage("The event has been closed!"),
    "eventCreatedText" : MessageLookupByLibrary.simpleMessage("Your event has been created! Now we wait for more attendees."),
    "eventEmptyFilledText" : MessageLookupByLibrary.simpleMessage("Whoops! \n There are no filled events yet. Keep swiping right!"),
    "eventEmptyReadText" : MessageLookupByLibrary.simpleMessage("No more events to check out. \n Why not create your own?"),
    "eventExitText" : m2,
    "eventTitleHintText" : MessageLookupByLibrary.simpleMessage("Have a beer, go for a walk, visit the cathedral ..."),
    "existingAccountText" : MessageLookupByLibrary.simpleMessage("There\'s already an account using this email. Try loggin in using another provider."),
    "exitNoText" : MessageLookupByLibrary.simpleMessage("NO"),
    "exitPromtText" : MessageLookupByLibrary.simpleMessage("Are you sure you want to leave?"),
    "exitYesText" : MessageLookupByLibrary.simpleMessage("YES, GET ME OUT!"),
    "haleoText" : MessageLookupByLibrary.simpleMessage("haleo!"),
    "invalidEmailText" : MessageLookupByLibrary.simpleMessage("The email address is not valid."),
    "invalidPasswordText" : MessageLookupByLibrary.simpleMessage("The password must be at least 6 characters long."),
    "invalidSignInText" : MessageLookupByLibrary.simpleMessage("Either the email or password are incorrect."),
    "locationErrorText" : MessageLookupByLibrary.simpleMessage("There was an error retrieving your location."),
    "locationPermissionText" : MessageLookupByLibrary.simpleMessage("We need your location to create an event."),
    "messageHintText" : MessageLookupByLibrary.simpleMessage("Write a message"),
    "passwordSentText" : MessageLookupByLibrary.simpleMessage("A password reset link has been sent to your email."),
    "profileText" : MessageLookupByLibrary.simpleMessage("Your face!"),
    "promoText" : MessageLookupByLibrary.simpleMessage("Find events near you. \n You are only a click away!"),
    "shareText" : m3,
    "signInText" : MessageLookupByLibrary.simpleMessage("Sign In"),
    "slotsNumberText" : MessageLookupByLibrary.simpleMessage("Minimum number of attendees?"),
    "uploadErrorText" : MessageLookupByLibrary.simpleMessage("There was an unexpected issue and the file could not be uploaded."),
    "usedEmailText" : MessageLookupByLibrary.simpleMessage("The email address is already in use."),
    "userUpdatedText" : MessageLookupByLibrary.simpleMessage("Your user profile has been updated."),
    "yourText" : MessageLookupByLibrary.simpleMessage("Your")
  };
}
