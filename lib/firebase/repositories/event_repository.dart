import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/event.dart';

/// REPOSITORIES MUST NOT BE STORED IN VARIABLES OR INSTANTIATED DIRECTLY!
/// These are only to be used as an interface for the model's methods, and
/// should only be accessed by making the appropriate call in DatabaseManager.

class EventRepository {
  final Firestore _database;

  EventRepository(this._database);

  Future<String> create(String uid, Event event) async {
    DocumentReference reference = _database.collection("events").document(uid);
    reference.setData((event..id = reference.documentID).toJson());
    return reference.documentID;
  }

  Future<Event> read(String key) async {
    DocumentReference reference = _database.collection("events").document(key);
    DocumentSnapshot snapshot = await reference.get();
    return snapshot?.data != null ? Event.fromRaw(snapshot.data) : null;
  }

  Future<Map<String, Event>> readAll() async {
    Query reference = _database.collection("events");
    QuerySnapshot snapshot = await reference.getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents ?? [];
    List<MapEntry<String, Event>> entries = documents.map((document) =>
        MapEntry<String, Event>(document.documentID, Event.fromRaw(document.data))).toList();
    return Map.fromEntries(entries);
  }

  Future<dynamic> update(String key, Event event) {
    DocumentReference reference = _database.collection("events").document(key);
    return reference.updateData(event.toJson());
  }

  Future<dynamic> delete(String key) async {
    DocumentReference reference = _database.collection("events").document(key);
    return reference.delete();
  }

  Stream<MapEntry<String, Event>> valueStream(String key) {
    DocumentReference reference = _database.collection("events").document(key);
    return reference.snapshots().map((snapshot) => snapshot?.data != null
        ? MapEntry(snapshot.documentID, Event.fromRaw(snapshot.data)) : null);
  }

  Stream<Map<String, Event>> collectionStream() {
    Query reference = _database.collection("events");
    return reference.snapshots().map((snapshot) {
      List<DocumentSnapshot> documents = snapshot.documents ?? [];
      List<MapEntry<String, Event>> entries = documents.map((document) =>
          MapEntry<String, Event>(document.documentID, Event.fromRaw(document.data))).toList();
      return Map.fromEntries(entries);
    });
  }
}