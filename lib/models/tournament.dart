import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:pond_hockey/enums/game_status.dart';

class Tournament {
  int id;
  String name;
  String details;
  GameStatus status;
  int year;
  DateTime startDate;
  DateTime endDate;
  DocumentReference owner;
  Map<int, bool> scorers;

  Tournament({
    this.id,
    this.name,
    this.details,
    this.status,
    this.year,
    this.startDate,
    this.endDate,
    this.owner,
    this.scorers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'status': EnumToString.parseCamelCase(status),
      'year': year,
      'startDate': startDate,
      'endDate': startDate,
      'owner': owner.path,
      'scorers': Map<String, bool>.from(scorers),
    };
  }

  static Tournament fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Tournament(
      id: map['id'],
      name: map['name'],
      details: map['details'],
      status: EnumToString.fromString(
        GameStatus.values,
        map['status'],
      ),
      year: map['year'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      owner: Firestore.instance.document(map['owner']),
      scorers: Map<int, bool>.from(map['scorers']),
    );
  }

  String toJson() => json.encode(toMap());

  static Tournament fromJson(String source) => fromMap(json.decode(source));
}
