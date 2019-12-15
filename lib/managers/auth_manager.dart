import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthManager {
  final FirebaseAuth _auth;
  final GoogleSignIn _google;

  AuthManager(this._auth, this._google);

  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password) async =>
      (await _auth.createUserWithEmailAndPassword(email: email, password: password))?.user;

  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async =>
      (await _auth.signInWithEmailAndPassword(email: email, password: password))?.user;

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignIn = await _google.signIn();
    final GoogleSignInAuthentication googleAuth = await googleSignIn.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    return authResult?.user;
  }

  Future<dynamic> signOut() async {
    await _google?.signOut();
    await _auth?.signOut();
  }

  Future<FirebaseUser> currentUser() => _auth.currentUser();

  Future<bool> isSignedIn() async => (await currentUser()) == null ? false : true;

  Stream<FirebaseUser> onAuthStateChanged() => _auth.onAuthStateChanged;
}