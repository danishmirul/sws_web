import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    return User(
      uid: user.uid,
      email: user.email,
    );
  }

  Stream<User> get onAuthStateChanged {
    try {
      return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signInEmailPassword(String email, String password) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signUpEmailPassword(
      {@required String email, @required String password}) async {
    try {
      FirebaseApp app = await FirebaseApp.configure(
          name: 'Secondary', options: await FirebaseApp.instance.options);
      final authResult = await FirebaseAuth.fromApp(app)
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> resetPassword({@required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User> signInAnonymously() async {
    try {
      final authResult = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return _firebaseAuth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> currentUser() async {
    try {
      final user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
