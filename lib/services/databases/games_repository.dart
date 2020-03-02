import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pond_hockey/models/game.dart';

class GamesRepository {
  final CollectionReference ref = Firestore.instance.collection('games');

  Stream<QuerySnapshot> getGamesFromTournamentId(String id) {
    final query = ref.where('tournament', isEqualTo: id).snapshots();
    return query;
  }

  Future<Stream<Game>> getStreamFromGameId(String gameId) async {
    var doc = ref.document(gameId);
    if ((await doc.get()).exists == false) return null;
    return doc.snapshots().map(Game.fromDocument);
  }

  Future<void> updateScores(String gameId, int teamOne, int teamTwo) {
    return ref.document(gameId).updateData({
      'team_one': {
        'score': teamOne,
      },
      'team_two': {
        'score': teamTwo,
      }
    });
  }
}
