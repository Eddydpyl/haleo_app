import 'dart:async';

import 'package:darter_base/darter_base.dart';

import '../managers/database_manager.dart';
import '../managers/preference_manager.dart';
import '../models/event.dart';

class EventAdminBloc extends BaseBloc {
  final DatabaseManager _databaseManager;
  final PreferenceManager _preferenceManager;

  LenientSubject<Event> _create;
  LenientSubject<MapEntry<String, Event>> _update;
  LenientSubject<String> _delete;

  EventAdminBloc(DatabaseManager databaseManager, PreferenceManager preferenceManager)
      : _databaseManager = databaseManager, _preferenceManager = preferenceManager;

  /// Consumes a [Event] and uses it to create an instance in the database.
  Sink<Event> get createSink => _create.sink;

  /// Consumes a [MapEntry] and uses it to update the instance in the database.
  Sink<MapEntry<String, Event>> get updateSink => _update.sink;

  /// Consumes a [String] and uses it to delete the instance in the database.
  Sink<String> get deleteSink => _delete.sink;

  @override
  void initialize() {
    super.initialize();
    _create = LenientSubject(ignoreRepeated: false);
    _update = LenientSubject(ignoreRepeated: false);
    _delete = LenientSubject(ignoreRepeated: false);

    _create.stream.listen((Event event) async {
      if (event != null) {
        String key = await _databaseManager
            .eventRepository().create(event)
            .catchError((e) => forwardException(e));
        _preferenceManager.view(key);
      }
    });
    _update.stream.listen((MapEntry<String, Event> entry) {
      if (entry != null) {
        _databaseManager.eventRepository()
            .update(entry.key, entry.value)
            .catchError((e) => forwardException(e));
      }
    });
    _delete.stream.listen((String key) {
      if (key?.isNotEmpty ?? false) {
        _databaseManager.eventRepository().delete(key)
            .catchError((e) => forwardException(e));
      }
    });
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_create.close());
    futures.add(_update.close());
    futures.add(_delete.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}
