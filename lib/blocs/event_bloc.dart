import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../models/event.dart';
import '../models/message.dart';
import '../models/user.dart';

class EventBloc extends BaseBloc {
  final DatabaseManager _databaseManager;

  LenientSubject<MapEntry<String, Event>> _event;
  LenientSubject<Map<String, Message>> _messages;
  LenientSubject<Map<String, User>> _users;
  LenientSubject<String> _eventKey;

  StreamSubscription _eventSubscription;
  StreamSubscription _messagesSubscription;

  EventBloc(DatabaseManager databaseManager)
      : _databaseManager = databaseManager;

  /// Returns a [Stream] of the event.
  Observable<MapEntry<String, Event>> get eventStream => _event.stream;

  /// Returns a [Stream] of messages given the filters.
  Observable<Map<String, Message>> get messagesStream => _messages.stream;

  /// Returns a [Stream] of the messages' users.
  Observable<Map<String, User>> get usersStream => _users.stream;

  /// Consumes the key of the event (REQUIRED).
  LenientSink<String> get eventKeySink => _eventKey.sink;

  @override
  void initialize() {
    super.initialize();
    _event = LenientSubject(ignoreRepeated: false);
    _messages = LenientSubject(ignoreRepeated: false);
    _users = LenientSubject(ignoreRepeated: false);
    _eventKey = LenientSubject(ignoreRepeated: true);

    _eventKey.stream.listen((String key) {
      if (key?.isNotEmpty ?? false)
        _updateProviders(key);
    });
  }

  void _updateProviders(String key) {
    _eventSubscription?.cancel();
    _eventSubscription = _databaseManager.eventRepository()
        .valueStream(key).listen((event) {
      if (event != null) {
        Map<String, User> users = _users.value ?? Map();
        List<Future> futures = List();
        for (String uid in event.value.attendees) {
          if (!users.keys.contains(uid)) {
            futures.add(_databaseManager.userRepository()
                .read(uid).then((User user) => users[uid] = user));
          }
        }
        Future.wait(futures).then((_) {
          _event.add(event);
          _users.add(users);
        });
      }
    });
    _messagesSubscription?.cancel();
    _messagesSubscription = _databaseManager
        .messageRepository(key).collectionStream()
        .listen((data) => _messages.add(data ?? Map()));
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_eventSubscription?.cancel() ?? Future.value());
    futures.add(_messagesSubscription?.cancel() ?? Future.value());
    futures.add(_event.close());
    futures.add(_messages.close());
    futures.add(_users.close());
    futures.add(_eventKey.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}