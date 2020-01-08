import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:vibration/vibration.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

import 'localization.dart';
import 'providers/application_provider.dart';
import 'providers/state_provider.dart';
import 'views/pages/event_cards_page.dart';
import 'views/pages/session_page.dart';
import 'views/pages/chat_page.dart';
import 'localization_delegate.dart';
import 'views/themes.dart';
import 'models/base.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
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
  final StreamingSharedPreferences preferences;

  App(this.locale, this.auth, this.preferences);

  @override
  Widget build(BuildContext context) {
    return ApplicationProvider(
      auth: auth,
      database: Firestore(app: FirebaseApp.instance),
      messaging: messaging,
      geo: Geoflutterfire(),
      google: GoogleSignIn(),
      facebook: FacebookLogin(),
      preferences: preferences,
      storage: FirebaseStorage(),
      child: Builder(
        builder: (BuildContext context) {
          return StateProvider(
            auth: ApplicationProvider.auth(context),
            database: ApplicationProvider.database(context),
            messaging: ApplicationProvider.messaging(context),
            child: MaterialApp(
              title: "haleo",
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
    // Initialize localization.
    LocalizationLoader.load();
    // Request location permissions.
    Location().requestPermission();
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
            if (action == Action.OPEN
                || action == Action.ATTEND
                || action == Action.SEND_MESSAGE) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ChatPage(key),
              ));
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
            if (action == Action.OPEN
                || action == Action.ATTEND
                || action == Action.SEND_MESSAGE) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ChatPage(key),
              ));
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: "",
      stream: StateProvider.stateBloc(context).userKeyStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data != null) {
          if (snapshot.data.isNotEmpty)
            return EventCardsPage();
          else return SplashScreen();
        } else return SessionPage();
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(80.0),
      color: Colors.white,
      child: Center(
        child: Image.asset("assets/images/haleo_android.png"),
      ),
    );
  }
}
