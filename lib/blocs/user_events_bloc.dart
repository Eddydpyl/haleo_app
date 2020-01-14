import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../models/event.dart';
import '../models/user.dart';

class UserEventsBloc extends BaseBloc {
  final DatabaseManager _databaseManager;

  LenientSubject<Map<String, Event>> _events;
  LenientSubject<Map<String, User>> _users;
  LenientSubject<String> _leave;
  LenientSubject<String> _userKey;

  StreamSubscription _subscription;

  UserEventsBloc(DatabaseManager databaseManager)
      : _databaseManager = databaseManager;

  /// Returns a [Stream] of events given the filters.
  Observable<Map<String, Event>> get eventsStream => _events.stream;

  /// Returns a [Stream] of users given the events.
  Observable<Map<String, User>> get usersStream => _users.stream;

  /// The user is no longer interested in the event.
  Sink<String> get leaveSink => _leave.sink;

  /// Consumes the key of the logged in user (REQUIRED).
  Sink<String> get userKeySink => _userKey.sink;

  @override
  void initialize() {
    super.initialize();
    _events = LenientSubject(ignoreRepeated: false);
    _users = LenientSubject(ignoreRepeated: false);
    _leave = LenientSubject(ignoreRepeated: true);
    _userKey = LenientSubject(ignoreRepeated: true);

    _leave.stream.listen((String key) {
      if (key != null && _userKey.value != null)
        _databaseManager.eventRepository().leave(key, _userKey.value);
    });

    _userKey.stream.listen((String uid) {
      if (uid?.isNotEmpty ?? false)
        _updateProviders(uid);
    });
  }

  void _updateProviders(String uid) {
    _subscription?.cancel();
    _subscription = _databaseManager.eventRepository()
        .collectionStream(uid: uid).listen((data) {
      Map<String, Event> events = data ?? Map();
      Map<String, User> users = _users.value ?? Map();
      List<Future> futures = List();
      for (Event event in events.values) {
        for (String uid in event.attendees) {
          if (!users.keys.contains(uid)) {
            futures.add(_databaseManager.userRepository()
                .read(uid).then((User user) => users[uid] = user));
          }
        }
      }
      Future.wait(futures).then((_) {
        _events.add(events);
        _users.add(users);
      });
    });
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_subscription?.cancel() ?? Future.value());
    futures.add(_events.close());
    futures.add(_leave.close());
    futures.add(_userKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}