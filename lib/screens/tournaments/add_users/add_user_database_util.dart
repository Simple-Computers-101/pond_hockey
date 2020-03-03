import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pond_hockey/screens/tournaments/add_users/user.dart';

class FirebaseDatabaseUtil {
  CollectionReference _tournamentRef =
      Firestore.instance.collection('tournaments');
  var database = Firestore.instance;
  int _counter;
  DatabaseError error;

  static final FirebaseDatabaseUtil _instance =
      FirebaseDatabaseUtil._internal();

  FirebaseDatabaseUtil._internal();

  factory FirebaseDatabaseUtil() {
    return _instance;
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
    await _tournamentRef.document(user.id).updateData({
      'editors': [
        user.id,
      ],
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
      "email": user.email,
    }).then((_) {
      print('Transaction  committed.');
    });
  }
}
