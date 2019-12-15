import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../models/message.dart';

class MessagesBloc extends BaseBloc {
  final DatabaseManager _databaseManager;

  LenientSubject<Map<String, Message>> _messages;
  LenientSubject<String> _eventKey;

  StreamSubscription _subscription;

  MessagesBloc(DatabaseManager databaseManager)
      : _databaseManager = databaseManager;

  /// Returns a [Stream] of messages given the filters.
  Observable<Map<String, Message>> get messagesStream => _messages.stream;

  /// Consumes the key of the event(REQUIRED).
  LenientSink<String> get eventKeySink => _eventKey.sink;

  @override
  void initialize() {
    super.initialize();
    _messages = LenientSubject(ignoreRepeated: false);
    _eventKey = LenientSubject(ignoreRepeated: true);

    _eventKey.stream.listen((String key) {
      if (key?.isNotEmpty ?? false) {
        _subscription?.cancel();
        _subscription = _databaseManager
            .messageRepository(key).collectionStream()
            .listen((data) => _messages.add(data ?? Map()));
      }
    });
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_subscription?.cancel() ?? Future.value());
    futures.add(_messages.close());
    futures.add(_eventKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}