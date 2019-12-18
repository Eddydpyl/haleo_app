import 'dart:async';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';

import '../utility.dart';

class StorageManager {
  FirebaseStorage _storage;

  StorageManager(this._storage);

  Future<String> uploadImage(dynamic file) async {
    final String random = Random().nextInt(1000).toString();
    final String currentDate = DateUtility.currentDate();
    final String name = "$currentDate-$random";
    final StorageReference reference = _storage
        .ref().child("images").child(name);
    await reference.putData(file).onComplete;
    return reference.getDownloadURL()
        .then((uri) => uri.toString());
  }

  Future<dynamic> deleteFile(String url) async {
    StorageReference reference = await _storage.getReferenceFromUrl(url);
    await reference.delete();
  }
}