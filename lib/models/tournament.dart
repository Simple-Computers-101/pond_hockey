import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:pond_hockey/enums/game_status.dart';

class Tournament {
  String id;
  String name;
  String details;
  GameStatus status;
  int year;
  String location;
  DateTime startDate;
  DateTime endDate;
  String owner;
  List<String> scorers;

  Tournament({
    this.id,
    this.name,
    this.details,
    this.status,
    this.year,
    this.location,
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
      'location': location,
      'startDate': startDate,
      'endDate': startDate,
      'owner': owner,
      'scorers': scorers,
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
      location: map['location'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      owner: map['owner'],
      scorers: map['scorers'].cast<String>(),
    );
  }

  String toJson() => json.encode(toMap());

  static Tournament fromJson(String source) => fromMap(json.decode(source));
}
