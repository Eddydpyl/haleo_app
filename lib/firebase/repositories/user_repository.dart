import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user.dart';

/// REPOSITORIES MUST NOT BE STORED IN VARIABLES OR INSTANTIATED DIRECTLY!
/// These are only to be used as an interface for the model's methods, and
/// should only be accessed by making the appropriate call in DatabaseManager.

class UserRepository {
  final Firestore _database;

  UserRepository(this._database);

  Future<String> create(String uid, User user) async {
    DocumentReference reference = _database.collection("users").document(uid);
    reference.setData(user.toJson());
    return reference.documentID;
  }

  Future<User> read(String key) async {
    DocumentReference reference = _database.collection("users").document(key);
    DocumentSnapshot snapshot = await reference.get();
    return snapshot?.data != null ? User.fromRaw(snapshot.data) : null;
  }

  Future<Map<String, User>> readAll() async {
    Query reference = _database.collection("users");
    QuerySnapshot snapshot = await reference.getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents ?? [];
    List<MapEntry<String, User>> entries = documents.map((document) =>
        MapEntry<String, User>(document.documentID, User.fromRaw(document.data))).toList();
    return Map.fromEntries(entries);
  }

  Future<dynamic> update(String key, User user) {
    DocumentReference reference = _database.collection("users").document(key);
    return reference.updateData(user.toJson());
  }

  Future<dynamic> delete(String key) async {
    DocumentReference reference = _database.collection("users").document(key);
    return reference.delete();
  }

  Stream<MapEntry<String, User>> valueStream(String key) {
    DocumentReference reference = _database.collection("users").document(key);
    return reference.snapshots().map((snapshot) => snapshot?.data != null
        ? MapEntry(snapshot.documentID, User.fromRaw(snapshot.data)) : null);
  }

  Stream<Map<String, User>> collectionStream() {
    Query reference = _database.collection("users");
    return reference.snapshots().map((snapshot) {
      List<DocumentSnapshot> documents = snapshot.documents ?? [];
      List<MapEntry<String, User>> entries = documents.map((document) =>
          MapEntry<String, User>(document.documentID, User.fromRaw(document.data))).toList();
      return Map.fromEntries(entries);
    });
  }
}