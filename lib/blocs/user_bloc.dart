import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../models/user.dart';

class UserBloc extends BaseBloc {
  final DatabaseManager _databaseManager;

  LenientSubject<MapEntry<String, User>> _user;
  LenientSubject<String> _userKey;

  StreamSubscription _subscription;

  UserBloc(DatabaseManager databaseManager)
      : _databaseManager = databaseManager;

  /// Returns a [Stream] of the user.
  Observable<MapEntry<String, User>> get userStream => _user.stream;

  /// Consumes the key of the user (REQUIRED).
  Sink<String> get userKeySink => _userKey.sink;

  @override
  void initialize() {
    super.initialize();
    _user = LenientSubject(ignoreRepeated: false);
    _userKey = LenientSubject(ignoreRepeated: true);

    _userKey.stream.listen((String uid) {
      if (uid?.isNotEmpty ?? false) {
        _subscription?.cancel();
        _subscription = _databaseManager
            .userRepository().valueStream(uid)
            .listen((data) => _user.add(data));
      }
    });
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_subscription?.cancel() ?? Future.value());
    futures.add(_user.close());
    futures.add(_userKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}