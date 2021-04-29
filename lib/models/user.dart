import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  // String uuid;
  String fullname;
  String email;
  String phone;
  bool hotline;
  bool accessible;

  // constructor
  User({
    this.uid,
    // this.uuid,
    this.email,
    this.fullname,
    this.phone,
    this.hotline,
    this.accessible,
  });

  // copy
  User.copy(User from)
      : this(
          uid: from.uid,
          // uuid: from.uuid,
          fullname: from.fullname,
          email: from.email,
          phone: from.phone,
          hotline: from.hotline,
          accessible: from.accessible,
        );

  @override
  String toString() {
    // TODO: implement toString
    return "{ uid:${this.uid}," +
        //  uuid:${this.uuid},
        "fullname:${this.fullname}, email:${this.email}, phone:${this.phone}, hotline:${this.hotline} }";
  }

  // initialised through snapshot
  User.fromSnapShot(DocumentSnapshot snapshot) {
    this.uid = snapshot.documentID;
    // this.uuid = snapshot.data['uuid'];
    this.fullname = snapshot.data['fullname'];
    this.email = snapshot.data['email'];
    this.phone = snapshot.data['phone'];
    this.hotline = snapshot.data['hotline'];
    this.accessible = snapshot.data['accessible'];
  }

  // map to object
  factory User.fromMap(uid, Map<String, dynamic> data) {
    if (data == null || uid == null) {
      return null;
    }
    // final String uuid = data['uuid'];
    // if (uuid == null) {
    //   return null;
    // }
    final String email = data['email'];
    if (email == null) {
      return null;
    }
    final String fullname = data['fullname'];
    if (fullname == null) {
      return null;
    }
    final String phone = data['phone'];
    if (phone == null) {
      return null;
    }
    final bool hotline = data['hotline'];
    if (hotline == null) {
      return null;
    }
    final bool accessible = data['accessible'];
    if (accessible == null) {
      return null;
    }

    return User(
      uid: uid,
      // uuid: uuid,
      email: email,
      fullname: fullname,
      phone: phone,
      hotline: hotline,
      accessible: accessible,
    );
  }

  // object to map
  Map<String, dynamic> toMap() {
    return {
      // 'uuid': uuid,
      'email': email,
      'fullname': fullname,
      'phone': phone,
      'hotline': hotline,
      'accessible': accessible,
    };
  }
}
