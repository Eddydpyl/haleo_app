import 'package:darter_base/darter_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/auth_manager.dart';
import '../managers/database_manager.dart';
import '../localization.dart';
import '../models/user.dart';

class SessionMode {
  static const int SIGN_IN = 0;
  static const int SIGN_UP = 1;
  static const int RESET = 2;
}

class SessionBloc extends BaseBloc {
  final AuthManager _authManager;
  final DatabaseManager _databaseManager;
  final Localization _localization;

  LenientSubject<int> _mode;
  LenientSubject<String> _name;
  LenientSubject<String> _email;
  LenientSubject<String> _password;
  LenientSubject<bool> _google;
  LenientSubject<bool> _facebook;

  SessionBloc(AuthManager authManager, DatabaseManager databaseManager, Localization localization)
      : _authManager = authManager, _databaseManager = databaseManager, _localization = localization;

  /// Returns a [Stream] of the current mode.
  Observable<int> get modeStream => _mode.stream;

  /// Consumes a [int] used for indicating whether we sign up, sign in or reset.
  LenientSink<int> get modeSink => _mode.sink;

  /// Consumes a [String] used to sign up.
  LenientSink<String> get nameSink => _name.sink;

  /// Consumes a [String] used to sign up, sign in or reset.
  LenientSink<String> get emailSink => _email.sink;

  /// Consumes a [String] used to sign up or sign in.
  LenientSink<String> get passwordSink => _password.sink;

  /// Consumes a placeholder to trigger a Google sign in.
  LenientSink<bool> get googleSink => _google.sink;

  /// Consumes a placeholder to trigger a Facebook sign in.
  LenientSink<bool> get facebookSink => _facebook.sink;

  @override
  void initialize() {
    super.initialize();
    _mode = LenientSubject(ignoreRepeated: false);
    _name = LenientSubject(ignoreRepeated: false);
    _email = LenientSubject(ignoreRepeated: false);
    _password = LenientSubject(ignoreRepeated: false);
    _google = LenientSubject(ignoreRepeated: false);
    _facebook = LenientSubject(ignoreRepeated: false);

    _mode.add(SessionMode.SIGN_IN);
    _mode.stream.listen((int mode) => _emptyFields());
    _name.stream.listen((String name) {
      if (_mode.value == SessionMode.SIGN_UP)
        _signUp(_authManager, _databaseManager,
            name, _email.value, _password.value);
    });
    _email.stream.listen((String email) {
      if (_mode.value == SessionMode.SIGN_IN)
        _signIn(_authManager, email, _password.value);
      else if (_mode.value == SessionMode.SIGN_UP)
        _signUp(_authManager, _databaseManager,
            _name.value, email, _password.value);
      else if (_mode.value == SessionMode.RESET)
        _reset(_authManager, email);
    });
    _password.stream.listen((String password) {
      if (_mode.value == SessionMode.SIGN_IN)
        _signIn(_authManager, _email.value, password);
      else if (_mode.value == SessionMode.SIGN_UP)
        _signUp(_authManager, _databaseManager,
            _name.value, _email.value, password);
    });
    _google.stream.listen((bool google) async {
      if (google ?? false) {
        FirebaseUser aux = await _authManager
          .signInWithGoogle().catchError((exception) {
            forwardException(FailedException(_localization.errorSignInText()));
            return null;
          });

        if (aux == null) return;
        User user = User(email: aux.email,
            name: aux.displayName, image: aux.photoUrl);
        _databaseManager.userRepository().create(aux.uid, user);
      }
    });
    _facebook.stream.listen((bool facebook) async {
      if (facebook ?? false) {
        FirebaseUser aux = await _authManager
          .signInWithFacebook().catchError((exception) {
            forwardException(FailedException(_localization.errorSignInText()));
            return null;
          });

        if (aux == null) return;
        User user = User(email: aux.email,
            name: aux.displayName, image: aux.photoUrl);
        _databaseManager.userRepository().create(aux.uid, user);
      }
    });
  }

  void _signIn(AuthManager auth, String email, String password) {
    if (email == null) return;
    if (password == null) return;
    _emptyFields();

    auth.signInWithEmailAndPassword(email, password).catchError((exception) {
      if (exception.code == "ERROR_INVALID_EMAIL")
        forwardException(FailedException(_localization.invalidEmailText()));
      else if (exception.code == "ERROR_WRONG_PASSWORD")
        forwardException(FailedException(_localization.invalidSignInText()));
      else if (exception.code == "ERROR_USER_NOT_FOUND")
        forwardException(FailedException(_localization.invalidSignInText()));
      else if (exception.code == "ERROR_USER_DISABLED")
        forwardException(FailedException(_localization.disabledUserText()));
      else forwardException(FailedException(_localization.errorSignInText()));
    });
  }

  void _signUp(AuthManager auth, DatabaseManager database,
      String name, String email, String password) {
    if (name == null) return;
    if (email == null) return;
    if (password == null) return;
    _emptyFields();

    auth.createUserWithEmailAndPassword(email, password).then((data) {
      User user = User(email: email, name: name);
      database.userRepository().create(data.uid, user);
    }).catchError((PlatformException exception) {
      if (exception.code == "ERROR_WEAK_PASSWORD")
        forwardException(FailedException(_localization.invalidPasswordText()));
      else if (exception.code == "ERROR_INVALID_EMAIL")
        forwardException(FailedException(_localization.invalidEmailText()));
      else if (exception.code == "ERROR_WEAK_PASSWORD")
        forwardException(FailedException(_localization.usedEmailText()));
      else forwardException(FailedException(_localization.errorSignUpText()));
    });
  }

  void _reset(AuthManager auth, String email) {
    if (email == null) return;
    _emptyFields();

    auth.sendPasswordResetEmail(email)
        .then((_) => forwardException(SuccessfulException(_localization.passwordSentText())))
        .catchError((_) => forwardException(FailedException(_localization.accountNotFoundText())));
  }

  void _emptyFields() {
    _name.add(null);
    _email.add(null);
    _password.add(null);
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_mode.close());
    futures.add(_name.close());
    futures.add(_email.close());
    futures.add(_password.close());
    futures.add(_google.close());
    futures.add(_facebook.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}