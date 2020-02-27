import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pond_hockey/models/game.dart';

class GamesRepository {
  final CollectionReference ref = Firestore.instance.collection('games');

  Future<List<Game>> getGamesFromTournamentId(String id) async {
    final query = await ref.where('tournament', isEqualTo: id).getDocuments();
    return query.documents.map(Game.fromDocument).toList();
  }

  Stream<DocumentSnapshot> getStreamFromGameId(String game) {
    return ref.document('$game').snapshots();
  }
}