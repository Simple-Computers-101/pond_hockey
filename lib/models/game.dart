import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_status.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/team.dart';

class Game {
  String id;
  GameStatus status;
  GameTeam teamOne;
  GameTeam teamTwo;
  String tournament;
  GameType type;
  Division division;
  DateTime startDate;
  int round;

  Game({
    @required this.id,
    @required this.tournament,
    @required this.teamOne,
    @required this.teamTwo,
    @required this.type,
    @required this.division,
    @required this.round,
    this.status = GameStatus.notStarted,
    this.startDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournament': tournament,
      'teamOne': teamOne.toMap(),
      'teamTwo': teamTwo.toMap(),
      'status': gameStatus[status],
      'type': gameType[type],
      'division': divisionMap[division],
      'startDate': startDate,
      'rounds': round,
    };
  }

  static Game fromDocument(DocumentSnapshot doc) {
    final data = doc.data;

    final status = gameStatus.keys.firstWhere(
      (element) => gameStatus[element] == data['status'],
    );

    final type = gameType.keys.firstWhere(
      (element) => gameType[element] == data['type'],
    );

    final division = divisionMap.keys.firstWhere(
      (element) => divisionMap[element] == data['division'],
    );

    var startDate = data['startDate'] as Timestamp;

    return Game(
      id: data['id'],
      tournament: data['tournament'],
      teamOne: GameTeam.fromMap(data['teamOne']),
      teamTwo: GameTeam.fromMap(data['teamTwo']),
      status: status,
      division: division,
      type: type,
      startDate: startDate?.toDate(),
      round: data['rounds'] ?? 0,
    );
  }
}

class SemiFinalGame {
  String id;
  GameStatus status;
  GameTeam teamOne;
  GameTeam teamTwo;
  String tournament;
  int round;
  Division division;
  DateTime startDate;

  SemiFinalGame({
    this.id,
    this.status,
    this.teamOne,
    this.teamTwo,
    this.tournament,
    this.division,
    this.startDate,
    this.round,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': gameStatus[status],
      'teamOne': teamOne.toMap(),
      'teamTwo': teamTwo.toMap(),
      'tournament': tournament,
      'division': divisionMap[division],
      'startDate': startDate.millisecondsSinceEpoch,
      'round': round,
    };
  }

  static SemiFinalGame fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    final division = divisionMap.keys.firstWhere(
      (element) => divisionMap[element] == map['division'],
    );

    final status = gameStatus.keys.firstWhere(
      (element) => gameStatus[element] == map['status'],
    );

    return SemiFinalGame(
      id: map['id'],
      status: status,
      teamOne: GameTeam.fromMap(map['teamOne']),
      teamTwo: GameTeam.fromMap(map['teamTwo']),
      tournament: map['tournament'],
      division: division,
      round: map['round'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
    );
  }
}

class GameTeam {
  String id;
  String name;
  int score;
  int differential;

  GameTeam({
    this.id,
    this.name,
    this.score = 0,
    this.differential = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'differential': differential,
    };
  }

  static GameTeam fromTeam(Team team) {
    return GameTeam(
      id: team.id,
      name: team.name,
    );
  }

  static GameTeam fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GameTeam(
      id: map['id'],
      name: map['name'],
      score: map['score'],
      differential: map['differential'],
    );
  }
}
