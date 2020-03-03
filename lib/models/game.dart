import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:pond_hockey/enums/game_status.dart';
import 'package:pond_hockey/enums/game_type.dart';

class Game {
  String id;
  GameStatus status;
  GameTeam teamOne;
  GameTeam teamTwo;
  String tournament;
  GameType type;

  Game({
    this.id,
    this.tournament,
    this.status,
    this.teamOne,
    this.teamTwo,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournament': tournament,
      'teamOne': teamOne.toMap(),
      'teamTwo': teamTwo.toMap(),
      'status': EnumToString.parseCamelCase(status),
      'type': EnumToString.parseCamelCase(type),
    };
  }

  static Game fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Game(
      id: map['id'],
      tournament: map['tournament'],
      teamOne: GameTeam.fromMap(map['teamOne']),
      teamTwo: GameTeam.fromMap(map['teamTwo']),
      status: EnumToString.fromString(GameStatus.values, map['status']),
      type: EnumToString.fromString(GameType.values, map['type']),
    );
  }

  static Game fromDocument(DocumentSnapshot doc) {
    var data = doc.data;

    var teamOne;
    var teamTwo;

    if (data.containsKey('team_one')) {
      teamOne = GameTeam.fromMap(data['team_one']);
      teamTwo = GameTeam.fromMap(data['team_one']);
    } else {
      teamOne = GameTeam.fromMap(data['teamOne']);
      teamTwo = GameTeam.fromMap(data['teamTwo']);
    }

    var status = gameStatus.keys
        .firstWhere((element) => gameStatus[element] == data['status']);

    var type = gameType.keys
        .firstWhere((element) => gameType[element] == data['type']);

    return Game(
      id: data['id'],
      tournament: data['tournament'],
      teamOne: teamOne,
      teamTwo: teamTwo,
      status: status,
      type: type,
    );
  }

  String toJson() => json.encode(toMap());

  static Game fromJson(String source) => fromMap(json.decode(source));
}

class GameTeam {
  String id;
  String name;
  int score;
  int differential;

  GameTeam({
    this.id,
    this.name,
    this.score,
    this.differential,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'differential': differential,
    };
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

  String toJson() => json.encode(toMap());

  static GameTeam fromJson(String source) => fromMap(json.decode(source));
}
