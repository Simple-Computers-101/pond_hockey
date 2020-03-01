import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pond_hockey/models/game.dart';

class GamesRepository {
  final CollectionReference ref = Firestore.instance.collection('games');

  Future<List<Game>> getGamesFromTournamentId(String id) async {
    final query = await ref.where('tournament', isEqualTo: id).getDocuments();
    return query.documents.map(Game.fromDocument).toList();
  }

  Future<Stream<Game>> getStreamFromGameId(String gameId) async {
    var doc = ref.document(gameId);
    if ((await doc.get()).exists == false) return null;
    return doc.snapshots().map(Game.fromDocument);
  }
}