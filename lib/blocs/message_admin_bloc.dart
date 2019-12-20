import 'dart:async';

import 'package:darter_base/darter_base.dart';

import '../managers/database_manager.dart';
import '../models/message.dart';

class MessageAdminBloc extends BaseBloc {
  final DatabaseManager _databaseManager;

  LenientSubject<Message> _create;
  LenientSubject<MapEntry<String, Message>> _update;
  LenientSubject<String> _delete;
  LenientSubject<String> _eventKey;

  MessageAdminBloc(DatabaseManager databaseManager)
      : _databaseManager = databaseManager;

  /// Consumes a [Message] and uses it to create an instance in the database.
  LenientSink<Message> get createSink => _create.sink;

  /// Consumes a [MapEntry] and uses it to update the instance in the database.
  LenientSink<MapEntry<String, Message>> get updateSink => _update.sink;

  /// Consumes a [String] and uses it to delete the instance in the database.
  LenientSink<String> get deleteSink => _delete.sink;

  /// The event where the messages belong to(REQUIRED).
  LenientSink<String> get eventKeySink => _eventKey.sink;

  @override
  void initialize() {
    super.initialize();
    _create = LenientSubject(ignoreRepeated: false);
    _update = LenientSubject(ignoreRepeated: false);
    _delete = LenientSubject(ignoreRepeated: false);
    _eventKey = LenientSubject(ignoreRepeated: false);

    _create.stream.listen((Message message) {
      if (message != null && _eventKey.value != null) {
        _databaseManager.messageRepository(_eventKey.value).create(message)
            .catchError((e) => forwardException(e));
      }
    });
    _update.stream.listen((MapEntry<String, Message> entry) {
      if (entry != null && _eventKey.value != null) {
        _databaseManager.messageRepository(_eventKey.value)
            .update(entry.key, entry.value)
            .catchError((e) => forwardException(e));
      }
    });
    _delete.stream.listen((String key) {
      if ((key?.isNotEmpty ?? false) && _eventKey.value != null) {
        _databaseManager.messageRepository(_eventKey.value).delete(key)
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
    futures.add(_eventKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}