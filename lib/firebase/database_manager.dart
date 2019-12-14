import 'package:cloud_firestore/cloud_firestore.dart';

import 'repositories/event_repository.dart';
import 'repositories/message_repository.dart';
import 'repositories/user_repository.dart';

class DatabaseManager {
  final Firestore _database;

  DatabaseManager(this._database);

  EventRepository eventRepository() => EventRepository(_database);

  MessageRepository messageRepository(String event) => MessageRepository(_database, event);

  UserRepository userRepository() => UserRepository(_database);
}