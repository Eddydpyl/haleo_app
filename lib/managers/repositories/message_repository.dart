import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/message.dart';

/// REPOSITORIES MUST NOT BE STORED IN VARIABLES OR INSTANTIATED DIRECTLY!
/// These are only to be used as an interface for the model's methods, and
/// should only be accessed by making the appropriate call in DatabaseManager.

class MessageRepository {
  final Firestore _database;
  final String _event;

  MessageRepository(this._database, this._event);

  Future<String> create(Message message) async {
    DocumentReference reference = _database.collection("events")
        .document(_event).collection("messages").document();
    reference.setData(message.toJson());
    return reference.documentID;
  }

  Future<Message> read(String key) async {
    DocumentReference reference = _database.collection("events")
        .document(_event).collection("messages").document(key);
    DocumentSnapshot snapshot = await reference.get();
    return snapshot?.data != null ? Message.fromRaw(snapshot.data) : null;
  }

  Future<Map<String, Message>> readAll() async {
    Query reference = _database.collection("events")
        .document(_event).collection("messages");
    QuerySnapshot snapshot = await reference.getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents ?? [];
    List<MapEntry<String, Message>> entries = documents.map((document) =>
        MapEntry<String, Message>(document.documentID, Message.fromRaw(document.data))).toList();
    return Map.fromEntries(entries);
  }

  Future<dynamic> update(String key, Message message) {
    DocumentReference reference = _database.collection("events")
        .document(_event).collection("messages").document(key);
    return reference.updateData(message.toJson());
  }

  Future<dynamic> delete(String key) async {
    DocumentReference reference = _database.collection("events")
        .document(_event).collection("messages").document(key);
    return reference.delete();
  }

  Stream<MapEntry<String, Message>> valueStream(String key) {
    DocumentReference reference = _database.collection("events")
        .document(_event).collection("messages").document(key);
    return reference.snapshots().map((snapshot) => snapshot?.data != null
        ? MapEntry(snapshot.documentID, Message.fromRaw(snapshot.data)) : null);
  }

  Stream<Map<String, Message>> collectionStream() {
    Query reference = _database.collection("events")
        .document(_event).collection("messages");
    return reference.snapshots().map((snapshot) {
      List<DocumentSnapshot> documents = snapshot.documents ?? [];
      List<MapEntry<String, Message>> entries = documents.map((document) =>
          MapEntry<String, Message>(document.documentID, Message.fromRaw(document.data))).toList();
      return Map.fromEntries(entries);
    });
  }
}