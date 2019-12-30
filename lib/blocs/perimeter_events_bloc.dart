import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../managers/preference_manager.dart';
import '../models/perimeter.dart';
import '../models/event.dart';
import '../models/user.dart';

class PerimeterEventsBloc extends BaseBloc {
  final DatabaseManager _databaseManager;
  final PreferenceManager _preferenceManager;

  LenientSubject<Map<String, Event>> _events;
  LenientSubject<Map<String, User>> _users;
  LenientSubject<MapEntry<String, bool>> _attend;
  LenientSubject<Perimeter> _perimeter;
  LenientSubject<String> _userKey;

  StreamSubscription _eventSubscription;
  StreamSubscription _preferenceSubscription;

  List<String> viewed = [];

  PerimeterEventsBloc(DatabaseManager databaseManager, PreferenceManager preferenceManager)
      : _databaseManager = databaseManager, _preferenceManager = preferenceManager;

  /// Returns a [Stream] of events given the filters.
  Observable<Map<String, Event>> get eventsStream => _events.stream;

  /// Returns a [Stream] of users given the events.
  Observable<Map<String, User>> get usersStream => _users.stream;

  /// Indicates if the user is interested in an event.
  LenientSink<MapEntry<String, bool>> get attendSink => _attend.sink;

  /// Consumes the [Perimeter] where the events will be searched for (REQUIRED).
  LenientSink<Perimeter> get perimeterSink => _perimeter.sink;

  /// Consumes the key of the logged in user (REQUIRED).
  LenientSink<String> get userKeySink => _userKey.sink;

  @override
  void initialize() {
    super.initialize();
    _events = LenientSubject(ignoreRepeated: false);
    _users = LenientSubject(ignoreRepeated: false);
    _attend = LenientSubject(ignoreRepeated: true);
    _perimeter = LenientSubject(ignoreRepeated: true);
    _userKey = LenientSubject(ignoreRepeated: true);

    _attend.stream.listen((MapEntry<String, bool> attend) async {
      if (attend != null && _userKey.value != null) {
        if (attend.value) {
          await _databaseManager.eventRepository()
              .attend(attend.key, _userKey.value)
              .catchError((e) => forwardException(e));
        } _preferenceManager.view(attend.key);
      }
    });
    _perimeter.stream.listen((Perimeter perimeter) {
      if (perimeter != null) {
        _eventSubscription?.cancel();
        _eventSubscription = _databaseManager.eventRepository()
            .collectionStream(center: GeoFirePoint(perimeter.lat, perimeter.lng),
            radius: perimeter.radius, open: true).listen((data) {
              Map<String, Event> purged = purge(data ?? Map());
              Map<String, User> users = _users.value ?? Map();
              List<Future> futures = List();
              for (Event event in purged.values) {
                for (String uid in event.attendees) {
                  if (!users.keys.contains(uid)) {
                    futures.add(_databaseManager.userRepository()
                        .read(uid).then((User user) => users[uid] = user));
                  }
                }
              }
              Future.wait(futures).then((_) {
                _events.add(purged);
                _users.add(users);
              });
            });
      }
    });
    _preferenceSubscription = _preferenceManager
        .viewed().listen((List<String> viewed) {
      if (viewed != null) {
        this.viewed = viewed;
        if (_events.value != null)
          _events.add(purge(_events.value));
      }
    });
  }

  Map<String, Event> purge(Map<String, Event> data) => data
    ..removeWhere((String key, Event value) => viewed.contains(key));

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_eventSubscription?.cancel() ?? Future.value());
    futures.add(_preferenceSubscription?.cancel() ?? Future.value());
    futures.add(_events.close());
    futures.add(_users.close());
    futures.add(_attend.close());
    futures.add(_perimeter.close());
    futures.add(_userKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}