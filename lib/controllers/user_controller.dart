import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import 'package:sws_web/services/firestore_path.dart';
import 'package:sws_web/services/firestore_service.dart';

class UserController {
  UserController({@required this.firestoreService})
      : assert(firestoreService != null);

  final FirestoreService firestoreService;

  CollectionReference users = Firestore.instance.collection('users');

  //  CRUD
  //  CREATE

  Future<bool> createNewUser(
      {@required FirebaseAuthService authService,
      @required User user,
      @required String password}) async {
    try {
      await authService.signUpEmailPassword(
          email: user.email, password: password);
      return await firestoreService.createNewDocument(users, user);
    } catch (e) {
      print(e);
      return false;
    }
  }

  //  READ

  Future<User> getCurrentUser() async {
    final querySnapshot = await users
        .where(FieldPath.documentId, isEqualTo: firestoreService.uid)
        .getDocuments();

    final documents = querySnapshot.documents;

    return documents.length > 0 ? User.fromSnapShot(documents[0]) : null;
  }

  Future<User> getUserById(String id) async {
    final documents = await firestoreService.getDocumentById(users, id);
    return documents != null ? User.fromSnapShot(documents) : null;
  }

  Future<User> getUserByEmail(String email) async {
    final querySnapshot =
        await users.where('email', isEqualTo: email).getDocuments();

    final documents = querySnapshot.documents;

    return documents.length > 0 ? User.fromSnapShot(documents[0]) : null;
  }

  Future<List<User>> getUsers() async {
    final documents = await firestoreService.getDocuments(users);

    List<User> userList = <User>[];
    userList =
        documents.map((e) => User.fromMap(e.documentID, e.data)).toList();

    return userList;
  }

  Future<List<User>> getAvailableUsers() async {
    Query query = users.limit(4).where('accessible', isEqualTo: true);
    final documents = await firestoreService.getDocumentsQeury(query);

    List<User> userList = <User>[];
    userList =
        documents.map((e) => User.fromMap(e.documentID, e.data)).toList();

    return userList;
  }

  Future<List<User>> getAvailableHotlines() async {
    Query query = users
        .limit(4)
        .where('hotline', isEqualTo: true)
        .where('accessible', isEqualTo: true);
    final documents = await firestoreService.getDocumentsQeury(query);

    List<User> userList = <User>[];
    userList =
        documents.map((e) => User.fromMap(e.documentID, e.data)).toList();

    return userList;
  }

  List<DocumentSnapshot> paginatedDocumentList = [];
  int index = 0;
  Future<List<User>> getPaginatedUser(
      {bool next = true, int length = 1}) async {
    Query query;
    final temp = await getUsers();
    final total = temp.length;
    print('index: $index');

    try {
      if (next) {
        if (index == 0) {
          query = users.orderBy('createdAt', descending: true).limit(length);
          List<DocumentSnapshot> snapshots =
              await firestoreService.getDocumentsQeury(query);
          paginatedDocumentList = snapshots;

          List<User> wheelchairList = <User>[];
          wheelchairList =
              snapshots.map((e) => User.fromMap(e.documentID, e.data)).toList();

          index = wheelchairList.length;

          return wheelchairList;
        } else if (index < total) {
          print('INDEX NORMAL');
          query = users
              .orderBy('createdAt', descending: true)
              .startAfterDocument(paginatedDocumentList[index - 1])
              .limit(length);
          List<DocumentSnapshot> snapshots =
              await firestoreService.getDocumentsQeury(query);
          paginatedDocumentList.addAll(snapshots);

          List<User> wheelchairList = <User>[];
          wheelchairList =
              snapshots.map((e) => User.fromMap(e.documentID, e.data)).toList();

          index = paginatedDocumentList.length;

          return wheelchairList;
        }
        return [];
      } else {
        if (index == 0 || index == length) {
          return [];
        } else if (index == total) {
          int remainder = index % length;

          int startIndex = remainder > 0
              ? total - (remainder + length)
              : total - (length * 2);

          List<DocumentSnapshot> snapshots =
              paginatedDocumentList.sublist(startIndex, startIndex + length);

          paginatedDocumentList.removeRange(
              startIndex + 1, paginatedDocumentList.length);

          index = paginatedDocumentList.length;

          List<User> wheelchairList = <User>[];
          wheelchairList =
              snapshots.map((e) => User.fromMap(e.documentID, e.data)).toList();

          return wheelchairList;
        } else {
          int startIndex = paginatedDocumentList.length - (length * 2);

          List<DocumentSnapshot> snapshots =
              paginatedDocumentList.sublist(startIndex, startIndex + length);

          paginatedDocumentList.removeRange(
              startIndex + 1, paginatedDocumentList.length);

          index = paginatedDocumentList.length;

          List<User> wheelchairList = <User>[];
          wheelchairList =
              snapshots.map((e) => User.fromMap(e.documentID, e.data)).toList();

          return wheelchairList;
        }
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  //  UPDATE
  Future<bool> updateUser(User user) async {
    final path = FirestorePath.userPath(user.uid);
    final docRef = Firestore.instance.document(path);
    return await firestoreService.setDocument(docRef, user);
  }

  //  STREAM
  Stream<User> userReferenceStream(String id) {
    try {
      final path = FirestorePath.userPath(id);
      final docRef = Firestore.instance.document(path);
      final snapshots = firestoreService.getDocumentSnapshot(docRef);
      final stream =
          snapshots.map((snapshot) => User.fromMap(id, snapshot.data));

      print('Stream: $stream');

      return stream;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<User>> usersReferenceStream() {
    try {
      final snapshots = firestoreService.getDocumentsSnapshot(users);
      final stream = snapshots.map((snapshot) => snapshot.documents
          .map((doc) => User.fromMap(doc.documentID, doc.data))
          .toList());

      print('Stream: $stream');

      return stream;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String getHotlineString(bool param) => param ? 'Hotline' : 'Normal';
  Color getHotlineColor(bool param) => param ? Colors.green : Colors.white;

  String getAccessibilityString(bool param) =>
      param ? 'Accessible' : 'Inacessible';
}
