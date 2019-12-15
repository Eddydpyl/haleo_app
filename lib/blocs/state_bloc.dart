import 'package:darter_base/darter_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../managers/auth_manager.dart';
import '../managers/message_manager.dart';
import '../models/user.dart';

class StateBloc extends BaseBloc {
  final AuthManager _authManager;
  final DatabaseManager _databaseManager;
  final MessageManager _messageManager;

  LenientSubject<String> _userKey;

  StateBloc(AuthManager authManager, DatabaseManager databaseManager, MessageManager messageManager)
      : _authManager = authManager, _databaseManager = databaseManager, _messageManager = messageManager;

  /// Returns a [Stream] of the logged in user's key.
  Observable<String> get userKeyStream => _userKey.stream;

  @override
  void initialize() {
    super.initialize();
    _userKey = LenientSubject();

    _authManager.onAuthStateChanged().listen((FirebaseUser user) async {
      if (user != null) {
        String token = (await _messageManager?.getToken()) ?? "";
        _updateToken(_databaseManager, user.uid, token);
      } _userKey.add(user?.uid);
    });
    _messageManager.tokenStream.listen((String token) {
      if (_userKey.value?.isNotEmpty ?? false)
        _updateToken(_databaseManager, _userKey.value, token);
    });
  }

  Future _updateToken(DatabaseManager databaseManager, String uid, String token) async {
    if ((await databaseManager.userRepository().read(uid)).token != token)
      return databaseManager.userRepository().update(uid, User(token: token));
  }

  @override
  Future dispose() {
    List<Future> futures = List();
    futures.add(_userKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}