import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';


import '../managers/auth_manager.dart';
import '../managers/database_manager.dart';
import '../managers/message_manager.dart';
import '../managers/preference_manager.dart';
import '../managers/storage_manager.dart';
import '../localization.dart';

class ApplicationProvider extends InheritedWidget {
  final AuthManager _authManager;
  final DatabaseManager _databaseManager;
  final MessageManager _messageManager;
  final PreferenceManager _prefManager;
  final StorageManager _storageManager;
  final Localization _localization;

  ApplicationProvider({
    Key key,
    @required Widget child,
    @required FirebaseAuth auth,
    @required Firestore database,
    @required GoogleSignIn google,
    @required FacebookLogin facebook,
    @required Geoflutterfire geo,
    @required FirebaseMessaging messaging,
    @required StreamingSharedPreferences preferences,
    @required FirebaseStorage storage,
  })  : _authManager = AuthManager(auth, google, facebook),
        _databaseManager = DatabaseManager(database, geo),
        _messageManager = MessageManager(messaging),
        _prefManager = PreferenceManager(preferences),
        _storageManager = StorageManager(storage),
        _localization = Localization(),
        super(key: key, child: child);

  static AuthManager auth(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationProvider)
      as ApplicationProvider)._authManager;

  static DatabaseManager database(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationProvider)
      as ApplicationProvider)._databaseManager;

  static MessageManager messaging(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationProvider)
      as ApplicationProvider)._messageManager;

  static PreferenceManager preferences(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationProvider)
      as ApplicationProvider)._prefManager;

  static StorageManager storage(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationProvider)
      as ApplicationProvider)._storageManager;

  static Localization localization(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApplicationProvider)
      as ApplicationProvider)._localization;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}