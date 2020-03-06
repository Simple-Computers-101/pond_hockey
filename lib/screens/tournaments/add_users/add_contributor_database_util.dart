//import 'dart:async';
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:pond_hockey/screens/tournaments/add_users/contributor.dart';
//
//class ContributorsDatabaseUtil {
//  final _tournamentRef =
//      Firestore.instance.collection('tournaments');
//
//
//  static final ContributorsDatabaseUtil _instance =
//      ContributorsDatabaseUtil._internal();
//
//  ContributorsDatabaseUtil._internal();
//
//  factory ContributorsDatabaseUtil() {
//    return _instance;
//  }
//
//  Stream<QuerySnapshot> getContributors() {
//    return _tournamentRef.snapshots();
//  }
//
//  addContributors(Contributor user) async {
//    await _tournamentRef.document(user.id).updateData({
//      'editors': [
//        user.id,
//      ],
//    }).then((_) {
//      print('Transaction  committed.');
//    });
//  }
//
//  void deleteContributors(Contributor user) async {
//    await _tournamentRef.document(user.id).delete().then((_) {
//      print('Transaction  committed.');
//    });
//  }
//
//  void updateContributors(Contributor user) async {
//    await _tournamentRef.document(user.id).updateData({
//      "email": user.email,
//    }).then((_) {
//      print('Transaction  committed.');
//    });
//  }
//}
