import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';

class MessagesBloc extends BaseBloc {
  final DatabaseManager _databaseManager;

  LenientSubject<String> _eventKey;

  MessagesBloc(DatabaseManager databaseManager)
      : _databaseManager = databaseManager;

  /// Consumes the key of the event(REQUIRED).
  LenientSink<String> get _eventKeySink => _eventKey.sink;

  @override
  void initialize() {
    super.initialize();
    _eventKey = LenientSubject(ignoreRepeated: true);
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_eventKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}