import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pond_hockey/screens/tournaments/add_users/user.dart';

class FirebaseDatabaseUtil {
  CollectionReference _tournamentRef;
  var database = Firestore.instance;
  int _counter;
  DatabaseError error;

  static final FirebaseDatabaseUtil _instance = FirebaseDatabaseUtil.internal();

  FirebaseDatabaseUtil.internal();

  factory FirebaseDatabaseUtil() {
    return _instance;
  }

  void initState() {
    _tournamentRef = database
        .collection("tournaments")
        .document("LORQyVSHgMkChOecIj3A")
        .collection("mainteners");
  }

  DatabaseError getError() {
    return error;
  }

  int getCounter() {
    return _counter;
  }

  Stream<QuerySnapshot> getUser() {
    return _tournamentRef.snapshots();
  }

  addUser(User user) async {
    await _tournamentRef.document(user.id).setData({
      "email": "" + user.email,
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void deleteUser(User user) async {
    await _tournamentRef.document(user.id).delete().then((_) {
      print('Transaction  committed.');
    });
  }

  void updateUser(User user) async {
    await _tournamentRef.document(user.id).updateData({
      "email": "" + user.email,
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void dispose() {}
}
