import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class TournamentsRepository extends ChangeNotifier {
  final CollectionReference ref = Firestore.instance.collection('tournaments');


}