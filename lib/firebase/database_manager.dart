import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'repositories/event_repository.dart';
import 'repositories/message_repository.dart';
import 'repositories/user_repository.dart';

class DatabaseManager {
  final Firestore _database;
  final Geoflutterfire _geo;

  DatabaseManager(this._database, this._geo);

  EventRepository eventRepository() => EventRepository(_database, _geo);

  MessageRepository messageRepository(String event) => MessageRepository(_database, event);

  UserRepository userRepository() => UserRepository(_database);
}