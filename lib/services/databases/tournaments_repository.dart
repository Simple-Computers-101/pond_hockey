import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentsRepository {
  final CollectionReference ref = Firestore.instance.collection('tournaments');


}