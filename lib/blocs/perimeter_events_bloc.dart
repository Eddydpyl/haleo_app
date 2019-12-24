import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../managers/message_manager.dart';
import '../managers/preference_manager.dart';
import '../models/perimeter.dart';
import '../models/event.dart';

class PerimeterEventsBloc extends BaseBloc {
  final DatabaseManager _databaseManager;
  final MessageManager _messageManager;
  final PreferenceManager _preferenceManager;

  LenientSubject<Map<String, Event>> _events;
  LenientSubject<MapEntry<String, bool>> _attend;
  LenientSubject<Perimeter> _perimeter;
  LenientSubject<String> _userKey;

  StreamSubscription _subscription;

  PerimeterEventsBloc(DatabaseManager databaseManager, MessageManager messageManager, PreferenceManager preferenceManager)
      : _databaseManager = databaseManager, _messageManager = messageManager, _preferenceManager = preferenceManager;

  /// Returns a [Stream] of events given the filters.
  Observable<Map<String, Event>> get eventsStream => _events.stream;

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
    _attend = LenientSubject(ignoreRepeated: true);
    _perimeter = LenientSubject(ignoreRepeated: true);
    _userKey = LenientSubject(ignoreRepeated: true);

    _attend.stream.listen((MapEntry<String, bool> attend) async {
      if (attend != null && _userKey.value != null) {
        _preferenceManager.view(attend.key);
        if (attend.value) {
          await _databaseManager.eventRepository()
              .attend(attend.key, _userKey.value)
              .catchError((e) => forwardException(e));
        }
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