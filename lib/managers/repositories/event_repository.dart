import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darter_base/darter_base.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/event.dart';
import '../../localization.dart';

/// REPOSITORIES MUST NOT BE STORED IN VARIABLES OR INSTANTIATED DIRECTLY!
/// These are only to be used as an interface for the model's methods, and
/// should only be accessed by making the appropriate call in DatabaseManager.

class EventRepository {
  final Firestore _database;
  final Geoflutterfire _geo;

  EventRepository(this._database, this._geo);

  Future<String> create(Event event) async {
    DocumentReference reference = _database.collection("events").document();
    reference.setData((event..topic = reference.documentID).toJson());
    return reference.documentID;
  }

  Future<Event> read(String key) async {
    DocumentReference reference = _database.collection("events").document(key);
    DocumentSnapshot snapshot = await reference.get();
    return snapshot?.data != null ? Event.fromRaw(snapshot.data) : null;
  }

  Future<Map<String, Event>> readAll({String uid,
    bool open, GeoFirePoint center, double radius}) async {
    Query reference = _database.collection("events");
    if (uid != null) reference = reference.where("attendees", arrayContains: uid);
    if (open != null) reference = reference.where("open", isEqualTo: open);
    List<DocumentSnapshot> documents;
    if (center != null && radius != null) {
      documents = await Observable(_geo.collection(collectionRef: reference)
          .within(center: center, radius: radius, field: "point")).first;
    } else {
      QuerySnapshot snapshot = await reference.getDocuments();
      documents = snapshot.documents ?? [];
    }

    List<MapEntry<String, Event>> entries = documents.map((document) =>
        MapEntry<String, Event>(document.documentID, Event.fromRaw(document.data))).toList();
    return Map.fromEntries(entries);
  }

  Future<dynamic> update(String key, Event event) {
    DocumentReference reference = _database.collection("events").document(key);
    return reference.updateData(event.toJson(true));
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

  Stream<Map<String, Event>> collectionStream({String uid,
    bool open, GeoFirePoint center, double radius}) {
    Query reference = _database.collection("events");
    if (uid != null) reference = reference.where("attendees", arrayContains: uid);
    if (open != null) reference = reference.where("open", isEqualTo: open);
    if (center != null && radius != null) {
      return _geo.collection(collectionRef: reference).within(center: center,
          radius: radius, field: "point").map((List<DocumentSnapshot> documents) {
        List<MapEntry<String, Event>> entries = documents.map((document) =>
            MapEntry<String, Event>(document.documentID, Event.fromRaw(document.data))).toList();
        return Map.fromEntries(entries);
      });
    } else {
      return reference.snapshots().map((snapshot) {
        List<DocumentSnapshot> documents = snapshot.documents ?? [];
        List<MapEntry<String, Event>> entries = documents.map((document) =>
            MapEntry<String, Event>(document.documentID, Event.fromRaw(document.data))).toList();
        return Map.fromEntries(entries);
      });
    }
  }

  Future<dynamic> attend(String key, String uid) {
    DocumentReference reference = _database.collection("events").document(key);
    return _database.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      Event event = snapshot?.data != null ? Event.fromRaw(snapshot.data) : null;
      if (!(event?.open ?? false)) throw FailedException(Localization().eventFullText());
      Event update = Event(attendees: [uid], count: (event?.count ?? 0) + 1);
      transaction.update(reference, update.toJson(true));
    });
  }
}