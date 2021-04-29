import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sws_web/models/message.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/models/wheelchair.dart';
import './firestore_path.dart';

class FirestoreService {
  FirestoreService({@required this.uid}) : assert(uid != null);
  final String uid;

  // Create the user data
  Future<void> createUserReference(User userReference) async {
    try {
      final path = FirestorePath.users();
      final reference = Firestore.instance.collection(path);
      await reference.add(userReference.toMap());
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Set the user data
  Future<void> setUserReference(User userReference) async {
    try {
      final path = FirestorePath.user(userReference.uid);
      final reference = Firestore.instance.document(path);
      await reference.setData(userReference.toMap());
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Reads the current user data
  Stream<User> userReferenceStream() {
    try {
      print('UID: $uid');
      final path = FirestorePath.user(uid);
      final reference = Firestore.instance.document(path);
      final snapshots = reference.snapshots();

      print('snapshots: $snapshots');
      return snapshots.map((snapshot) => User.fromMap(uid, snapshot.data));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<User>> usersReferenceStream() {
    try {
      final path = FirestorePath.users();
      final reference = Firestore.instance.collection(path);
      final snapshots = reference.snapshots();
      final stream = snapshots.map((snapshot) => snapshot.documents
          .map((doc) => User.fromMap(uid, doc.data))
          .toList());

      print('Stream: $stream');

      // users.add(snapshot.map((e) => User.fromMap(uid, e.data)));
      // stream.forEach((snapshot) {
      //   users.add(snapshot.map((e) => User.fromMap(uid, e.data)));
      // });

      return stream;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Reads the current user data
  Stream<Wheelchair> wheelchairReferenceStream(String uid) {
    try {
      print('UID: $uid');
      final path = FirestorePath.wheelchair(uid);
      final reference = Firestore.instance.document(path);
      final snapshots = reference.snapshots();

      print('snapshots: $snapshots');
      return snapshots
          .map((snapshot) => Wheelchair.fromMap(uid, snapshot.data));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<Wheelchair>> wheelchairsReferenceStream() {
    try {
      final path = FirestorePath.wheelchairs();
      final reference = Firestore.instance.collection(path);
      final snapshots = reference.snapshots();
      final stream = snapshots.map((snapshot) => snapshot.documents
          .map((doc) => Wheelchair.fromMap(uid, doc.data))
          .toList());

      print('Stream: $stream');

      // users.add(snapshot.map((e) => User.fromMap(uid, e.data)));
      // stream.forEach((snapshot) {
      //   users.add(snapshot.map((e) => User.fromMap(uid, e.data)));
      // });

      return stream;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Create the user data
  Future<void> createWheelchairReference(Wheelchair wheelchairReference) async {
    try {
      final path = FirestorePath.wheelchairs();
      final reference = Firestore.instance.collection(path);
      await reference.add(wheelchairReference.toMap());
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Set the user data
  Future<void> setWheelchairReference(Wheelchair wheelchairReference) async {
    try {
      final path = FirestorePath.wheelchair(wheelchairReference.uid);
      final reference = Firestore.instance.document(path);
      await reference.setData(wheelchairReference.toMap());
    } catch (e) {
      print(e);
      return null;
    }
  }
}
