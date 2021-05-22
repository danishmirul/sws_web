import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/models/wheelchair.dart';
import './firestore_path.dart';

class FirestoreService {
  FirestoreService({@required this.uid}) : assert(uid != null);
  final String uid;
  CollectionReference users = Firestore.instance.collection('users');
  CollectionReference msgLogs = Firestore.instance.collection('msgLogs');

  Future<bool> createNewDocument(
      CollectionReference collectionReference, dynamic data) async {
    try {
      await collectionReference.add(data.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<DocumentSnapshot> getDocumentById(
      CollectionReference collectionReference, String id) async {
    try {
      final querySnapshot = await collectionReference
          .where(FieldPath.documentId, isEqualTo: id)
          .getDocuments();

      final documents = querySnapshot.documents;

      return documents.length > 0 ? documents[0] : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<DocumentSnapshot>> getDocuments(
      CollectionReference collectionReference) async {
    try {
      final querySnapshot = await collectionReference.getDocuments();
      final documents = querySnapshot.documents;
      return documents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<DocumentSnapshot>> getDocumentsQeury(Query query) async {
    try {
      final querySnapshot = await query.getDocuments();
      final documents = querySnapshot.documents;
      return documents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> setDocument(
      DocumentReference documentReference, dynamic data) async {
    try {
      await documentReference.setData(data.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //STREAMS
  Stream<DocumentSnapshot> getDocumentSnapshot(
      DocumentReference documentReference) {
    try {
      final snapshots = documentReference.snapshots();

      print('Stream: $snapshots');
      return snapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> getDocumentsSnapshot(
      CollectionReference collectionReference) {
    try {
      final snapshots = collectionReference.snapshots();
      print('Stream: $snapshots');
      return snapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> getDocumentsSnapshotQuery(Query query) {
    try {
      final snapshots = query.snapshots();
      print('Stream: $snapshots');
      return snapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Create the user data
  Future<void> createUserReference(User userReference) async {
    try {
      final path = FirestorePath.usersPath();
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
      final path = FirestorePath.userPath(userReference.uid);
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
      final path = FirestorePath.userPath(uid);
      final reference = Firestore.instance.document(path);
      final snapshots = reference.snapshots();

      print('snapshots: $snapshots');
      return snapshots.map((snapshot) => User.fromMap(uid, snapshot.data));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> getCurrentUser() async {
    final querySnapshot =
        await users.where(FieldPath.documentId, isEqualTo: uid).getDocuments();

    final documents = querySnapshot.documents;

    return documents.length > 0 ? User.fromSnapShot(documents[0]) : null;
  }

  Future<User> getUserByEmail(String email) async {
    final querySnapshot =
        await users.where('email', isEqualTo: email).getDocuments();

    final documents = querySnapshot.documents;

    return documents.length > 0 ? User.fromSnapShot(documents[0]) : null;
  }

  Stream<List<User>> usersReferenceStream() {
    try {
      final path = FirestorePath.usersPath();
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
      final path = FirestorePath.wheelchairPath(uid);
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

  // Create the user data
  Future<void> createWheelchairReference(Wheelchair wheelchairReference) async {
    try {
      final path = FirestorePath.wheelchairsPath();
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
      final path = FirestorePath.wheelchairPath(wheelchairReference.uid);
      final reference = Firestore.instance.document(path);
      await reference.setData(wheelchairReference.toMap());
    } catch (e) {
      print(e);
      return null;
    }
  }
}
