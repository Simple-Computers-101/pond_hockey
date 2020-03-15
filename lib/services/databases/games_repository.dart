import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_status.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';

class GamesRepository {
  final CollectionReference ref = Firestore.instance.collection('games');

  Stream<QuerySnapshot> getGamesStreamFromTournamentId(String id,
      {Division division, GameType pGameType}) {
    // GET GAMES FROM TOURNAMENT ID
    // FILTER GAMES BY DIVISION
    var query;
    if (division != null) {
      query = ref
          .where('tournament', isEqualTo: id)
          .where('division', isEqualTo: divisionMap[division])
          .snapshots();
    } else if (pGameType != null && division != null) {
      query = ref
          .where('tournament', isEqualTo: id)
          .where('division', isEqualTo: divisionMap[division])
          .where('type', isEqualTo: gameType[pGameType])
          .snapshots();
    } else if (pGameType != null) {
      query = ref
          .where('tournament', isEqualTo: id)
          .where('type', isEqualTo: gameType[pGameType])
          .snapshots();
    } else {
      query = ref.where('tournament', isEqualTo: id).snapshots();
    }
    return query;
  }

  Future<List<Game>> getGamesFromTournamentId(String tournamentId,
      {Division division, GameType type}) async {
    QuerySnapshot query;
    if (type != null && division != null) {
      query = await ref
          .where('tournament', isEqualTo: tournamentId)
          .where('division', isEqualTo: divisionMap[division])
          .where('type', isEqualTo: gameType[type])
          .getDocuments();
    } else if (division != null) {
      query = await ref
          .where('tournament', isEqualTo: tournamentId)
          .where('division', isEqualTo: divisionMap[division])
          .getDocuments();
    } else {
      query =
          await ref.where('tournament', isEqualTo: tournamentId).getDocuments();
    }
    return query.documents.map(Game.fromDocument).toList();
  }

  Future<List<Game>> getGamesFromTeamId(String teamId,
      {Division division, GameType type}) async {
    if (division != null && type != null) {
      final queryOne = await ref
          .where('teamOne.id', isEqualTo: teamId)
          .where('division', isEqualTo: divisionMap[division])
          .where('type', isEqualTo: gameType[type])
          .getDocuments();
      final queryTwo = await ref
          .where('teamTwo.id', isEqualTo: teamId)
          .where('division', isEqualTo: divisionMap[division])
          .where('type', isEqualTo: gameType[type])
          .getDocuments();

      final docs = <DocumentSnapshot>[]
        ..addAll(queryOne.documents)
        ..addAll(queryTwo.documents);
      final games = docs.map(Game.fromDocument).toList().toSet().toList();
      return games;
    } else if (division != null) {
      final queryOne = await ref
          .where('teamOne.id', isEqualTo: teamId)
          .where('division', isEqualTo: divisionMap[division])
          .getDocuments();
      final queryTwo = await ref
          .where('teamTwo.id', isEqualTo: teamId)
          .where('division', isEqualTo: divisionMap[division])
          .getDocuments();

      final docs = <DocumentSnapshot>[]
        ..addAll(queryOne.documents)
        ..addAll(queryTwo.documents);
      final games = docs.map(Game.fromDocument).toList().toSet().toList();
      return games;
    } else if (type != null) {
      final queryOne = await ref
          .where('teamOne.id', isEqualTo: teamId)
          .where('type', isEqualTo: gameType[type])
          .getDocuments();
      final queryTwo = await ref
          .where('teamTwo.id', isEqualTo: teamId)
          .where('type', isEqualTo: gameType[type])
          .getDocuments();

      final docs = <DocumentSnapshot>[]
        ..addAll(queryOne.documents)
        ..addAll(queryTwo.documents);
      final games = docs.map(Game.fromDocument).toList().toSet().toList();
      return games;
    } else {
      final queryOne =
          await ref.where('teamOne.id', isEqualTo: teamId).getDocuments();
      final queryTwo =
          await ref.where('teamTwo.id', isEqualTo: teamId).getDocuments();

      final docs = <DocumentSnapshot>[]
        ..addAll(queryOne.documents)
        ..addAll(queryTwo.documents);
      final games = docs.map(Game.fromDocument).toList().toSet().toList();
      return games;
    }
  }

  List<Game> removeDuplicates(List<Game> games) {
    return games.toSet().toList();
  }

  Future<bool> areAllGamesCompleted(String tournamentId,
      {Division division}) async {
    var games =
        await getGamesFromTournamentId(tournamentId, division: division);
    for (var game in games) {
      if (game.status != GameStatus.finished) {
        return false;
      }
    }
    return true;
  }

  Future<int> getDifferentialFromTeamId(String teamId) async {
    var differential = 0;
    var teamOneQuery =
        await ref.where('teamOne.id', isEqualTo: teamId).getDocuments();
    var teamTwoQuery =
        await ref.where('teamTwo.id', isEqualTo: teamId).getDocuments();
    for (final team in teamOneQuery.documents) {
      differential += team.data['teamOne']['differential'] as int;
    }
    for (final team in teamTwoQuery.documents) {
      differential += team.data['teamTwo']['differential'] as int;
    }
    return differential;
  }

  Future<void> deleteGamesFromTournament(String id, Division division) async {
    var query;
    if (division != null) {
      query = await ref
          .where('tournament', isEqualTo: id)
          .where('division', isEqualTo: divisionMap[division])
          .getDocuments();
    } else {
      query = await ref.where('tournament', isEqualTo: id).getDocuments();
    }
    for (var doc in query.documents) {
      await doc.reference.delete();
    }
  }

  Future<void> addGame(Game game) {
    return ref.document(game.id).setData(game.toMap());
  }

  Future<void> updateGame(String gameId, Map<String, dynamic> data) {
    return ref.document(gameId).updateData(data);
  }

  Future<Stream<Game>> getStreamFromGameId(String gameId) async {
    var doc = ref.document(gameId);
    if ((await doc.get()).exists == false) return null;
    return doc.snapshots().map(Game.fromDocument);
  }

  Future<void> updateScores(String gameId, int teamOne, int teamTwo) async {
    return ref.document(gameId).setData({
      'teamOne': {
        'score': teamOne,
        'differential': teamOne - teamTwo,
      },
      'teamTwo': {
        'score': teamTwo,
        'differential': teamTwo - teamOne,
      }
    }, merge: true);
  }

  Future<bool> alreadySemiFinalGames(String tournamentId) async {
    var query = await ref
        .where('tournament', isEqualTo: tournamentId)
        .where('type', isEqualTo: gameType[GameType.semiFinal])
        .getDocuments();
    return query.documents.isNotEmpty;
  }

  Future<void> updateStatus(String gameId, {@required bool isComplete}) async {
    if (isComplete) {
      var doc = await ref.document(gameId).get();
      var game = Game.fromDocument(doc);
      if (game.teamOne.score > game.teamTwo.score) {
        await TeamsRepository().addTeamVictory(game.teamOne.id);
        await TeamsRepository().addTeamLoss(game.teamTwo.id);
      } else if (game.teamOne.score < game.teamTwo.score) {
        await TeamsRepository().addTeamVictory(game.teamTwo.id);
        await TeamsRepository().addTeamLoss(game.teamOne.id);
      }
      await TeamsRepository().addGamePlayed(game.teamOne.id);
      await TeamsRepository().addGamePlayed(game.teamTwo.id);
    }
    return ref.document(gameId).updateData({
      'status': isComplete
          ? gameStatus[GameStatus.finished]
          : gameStatus[GameStatus.inProgress],
    });
  }
}
