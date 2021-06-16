import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sws_web/models/location.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/services/firestore_service.dart';

class LocationController {
  LocationController({@required this.firestoreService})
      : assert(firestoreService != null);

  final FirestoreService firestoreService;

  CollectionReference locations = Firestore.instance.collection('locations');

  // Get
  Stream<QuerySnapshot> wheelchairlocationStream(String idWheelchair,
      {int length = 10}) {
    try {
      final query = locations
          .where('wheelchairID', isEqualTo: idWheelchair)
          .orderBy('createdAt', descending: true)
          .limit(length);
      return firestoreService.getDocumentsSnapshotQuery(query);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
