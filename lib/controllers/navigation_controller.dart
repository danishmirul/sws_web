import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sws_web/models/location.dart';
import 'package:sws_web/models/navigation.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/services/firestore_path.dart';
import 'package:sws_web/services/firestore_service.dart';

class NavigationController {
  NavigationController({@required this.firestoreService})
      : assert(firestoreService != null);

  final FirestoreService firestoreService;

  CollectionReference navigations =
      Firestore.instance.collection('navigations');

  // Get
  Stream<QuerySnapshot> navigationStream(String idWheelchair,
      {int length = 10}) {
    try {
      final query = navigations
          .where('wheelchairID', isEqualTo: idWheelchair)
          .orderBy('createdAt', descending: true)
          .limit(length);
      return firestoreService.getDocumentsSnapshotQuery(query);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> fetchNavigation(String idWheelchair) async {
    Query query = navigations
        .where('wheelchairID', isEqualTo: idWheelchair)
        .where('request', isEqualTo: true);
    final documents = await firestoreService.getDocumentsQeury(query);

    if (documents != null) {
      if (documents.length > 0) {
        Navigation navigation = Navigation.fromSnapShot(documents[0]);

        return {'status': true, 'data': navigation};
      }
      return {'status': false, 'data': null};
    }

    return {'status': false, 'data': null};
  }

  Future<bool> updateNavigation(Navigation navigation) async {
    final path = FirestorePath.navigationPath(navigation.uid);
    final docRef = Firestore.instance.document(path);
    try {
      return await firestoreService.setDocument(docRef, navigation);
    } catch (e) {
      print(e);
      return false;
    }
  }
}
