import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart' hide Action;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haleo_app/localization_delegate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';

import 'localization.dart';
import 'providers/application_provider.dart';
import 'providers/state_provider.dart';
import 'views/pages/events_page.dart';
import 'views/pages/events_create_page.dart';
import 'views/pages/login_page.dart';
import 'views/themes.dart';
import 'models/base.dart';

void main() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final FirebaseAuth auth = FirebaseAuth.fromApp(FirebaseApp.instance);
  Locale locale = ui.window.locale ?? Locale(Language.EN);
  Intl.systemLocale = locale.languageCode;
  Intl.defaultLocale = locale.languageCode;
  auth.setLanguageCode(locale.languageCode);
  runApp(App(locale, auth, preferences));
}

class App extends StatelessWidget {
  final FirebaseMessaging messaging = FirebaseMessaging();

  final Locale locale;
  final FirebaseAuth auth;
  final SharedPreferences preferences;

  App(this.locale, this.auth, this.preferences);

  @override
  Widget build(BuildContext context) {
    return ApplicationProvider(
      auth: auth,
      database: Firestore(app: FirebaseApp.instance),
      messaging: messaging,
      geo: Geoflutterfire(),
      google: GoogleSignIn(),
      preferences: preferences,
      child: Builder(
        builder: (BuildContext context) {
          return StateProvider(
            auth: ApplicationProvider.auth(context),
            database: ApplicationProvider.database(context),
            messaging: ApplicationProvider.messaging(context),
            child: MaterialApp(
              title: "Haleo",
              theme: CustomTheme.haleo,
              home: Initializer(messaging),
              locale: locale,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                const HaleoLocalizationsDelegate(),
              ],
              supportedLocales: [
                const Locale("en"),
                const Locale("es"),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Setting up services such messaging requires a context.
// In order to keep the code clean, we use this widget.
class Initializer extends StatefulWidget {
  final FirebaseMessaging messaging;

  Initializer(this.messaging);

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  void initState() {
    super.initState();
    LocalizationLoader.load();
    // TODO: Only integrated with Android. Integrate with iOS.
    // https://pub.dev/packages/firebase_messaging#ios-integration
    widget.messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final Map<String, dynamic> data =
            Map.from(Platform.isIOS ? message : message["data"]);
        if (data != null && data["type"] != null) {
          // Play the appropriate sound.
          FlutterRingtonePlayer.playNotification();
          // Vibrate for the default amount of time.
          bool vibration = await Vibration.hasVibrator();
          if (vibration) Vibration.vibrate();
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        final Map<String, dynamic> data =
            Map.from(Platform.isIOS ? message : message["data"]);
        if (data != null && data["type"] != null) {
          // Identify the notification type.
          final int type = int.parse(data["type"]);
          final int action = int.parse(data["action"]);
          final String key = data["key"];
          if (type == Archetype.EVENT) {
            if (action == Action.COMPLETE || action == Action.SEND_MESSAGE) {
              // TODO: Navigate to the event's page.
            }
          }
        }
      },
      onResume: (Map<String, dynamic> message) async {
        final Map<String, dynamic> data =
            Map.from(Platform.isIOS ? message : message["data"]);
        if (data != null && data["type"] != null) {
          // Identify the notification type.
          final int type = int.parse(data["type"]);
          final int action = int.parse(data["action"]);
          final String key = data["key"];
          if (type == Archetype.EVENT) {
            if (action == Action.COMPLETE || action == Action.SEND_MESSAGE) {
              // TODO: Navigate to the event's page.
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: StateProvider.stateBloc(context).userKeyStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data != null) {
          return EventsPage();
        } else
          return EventsPage();
      },
    );
  }
}
