import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class TournamentsRepository extends ChangeNotifier {
  final CollectionReference _ref = Firestore.instance.collection('tournaments');


}