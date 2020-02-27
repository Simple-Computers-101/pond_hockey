import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:pond_hockey/enums/game_status.dart';
import 'package:pond_hockey/enums/game_type.dart';

class Game {
  String id;
  GameStatus status;
  Map<String, dynamic> teamOne;
  Map<String, dynamic> teamTwo;
  String tournament;
  GameType type;

  Game({
    this.id,
    this.status,
    this.teamOne,
    this.teamTwo,
    this.tournament,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': EnumToString.parseCamelCase(status),
      'teamOne': teamOne,
      'teamTwo': teamTwo,
      'tournament': tournament,
      'type': EnumToString.parseCamelCase(type),
    };
  }

  static Game fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Game(
      id: map['id'],
      status: EnumToString.fromString(GameStatus.values, map['status']),
      teamOne: map['teamOne'],
      teamTwo: map['teamTwo'],
      tournament: map['tournament'],
      type: EnumToString.fromString(GameType.values, map['type']),
    );
  }

  static Game fromDocument(DocumentSnapshot doc) {
    var data = doc.data;

    return Game(
      id: data['id'],
      status: EnumToString.fromString(GameStatus.values, data['status']),
      teamOne: data['team_one'],
      teamTwo: data['team_two'],
      tournament: data['tournament'],
      type: EnumToString.fromString(GameType.values, data['type']),
    );
  }

  String toJson() => json.encode(toMap());

  static Game fromJson(String source) => fromMap(json.decode(source));
}
