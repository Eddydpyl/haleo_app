import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../managers/preference_manager.dart';
import '../models/perimeter.dart';
import '../models/event.dart';

class EventsBloc extends BaseBloc {
  final DatabaseManager _databaseManager;
  final PreferenceManager _preferenceManager;

  LenientSubject<Map<String, Event>> _events;
  LenientSubject<MapEntry<String, bool>> _attend;
  LenientSubject<Perimeter> _perimeter;
  LenientSubject<String> _userKey;

  StreamSubscription _subscription;

  EventsBloc(DatabaseManager databaseManager, PreferenceManager preferenceManager)
      : _databaseManager = databaseManager, _preferenceManager = preferenceManager;

  /// Returns a [Stream] of events given the filters.
  Observable<Map<String, Event>> get eventsStream => _events.stream;

  /// Indicates if the user is interested in an event.
  LenientSink<MapEntry<String, bool>> get attendSink => _attend.sink;

  /// Consumes the [Perimeter] where the events will be searched for.
  LenientSink<Perimeter> get perimeterSink => _perimeter.sink;

  /// Consumes the key of the logged in user.
  LenientSink<String> get userKeySink => _userKey.sink;

  @override
  void initialize() {
    super.initialize();
    _events = LenientSubject(ignoreRepeated: false);
    _attend = LenientSubject(ignoreRepeated: true);
    _perimeter = LenientSubject(ignoreRepeated: true);
    _userKey = LenientSubject(ignoreRepeated: true);

    _attend.stream.listen((MapEntry<String, bool> attend) {
      if (attend != null) {
        if (attend.value) _databaseManager.eventRepository()
            .update(attend.key, Event(attendees: [attend.key]))
            .catchError((e) => forwardException(e));
        _preferenceManager.view(attend.key);
      }
    });
    _perimeter.stream.listen((Perimeter perimeter) {
      if (perimeter != null) {
        _subscription?.cancel();
        List<String> viewed = _preferenceManager.viewed;
        _subscription = _databaseManager.eventRepository()
            .collectionStream(center: GeoFirePoint(perimeter.lat,
            perimeter.lng), radius: perimeter.radius, open: true)
            .listen((data) => _events.add((data ?? Map())
            ..removeWhere((String key, Event value) =>
                viewed.contains(key))));
      }
    });
    _userKey.stream.listen((String uid) {
      if (uid?.isNotEmpty ?? false) {
        _subscription?.cancel();
        _subscription = _databaseManager.eventRepository()
            .collectionStream(uid: uid, open: true)
            .listen((data) => _events.add(data ?? Map()));
      }
    });
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_subscription?.cancel() ?? Future.value());
    futures.add(_events.close());
    futures.add(_attend.close());
    futures.add(_perimeter.close());
    futures.add(_userKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}