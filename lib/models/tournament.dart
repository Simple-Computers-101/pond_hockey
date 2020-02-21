import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:pond_hockey/enums/game_status.dart';

class Tournament extends Equatable {
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

  @override
  List<Object> get props => [
        id,
        name,
        details,
        status,
        year,
        location,
        startDate,
        endDate,
        owner,
        scorers,
      ];

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
      scorers: map['scorers']?.cast<String>(),
    );
  }

  static Tournament fromDocument(DocumentSnapshot doc) {
    var data = doc.data;
    var startTimestamp = data['startDate'] as Timestamp;
    var endTimestamp = data['endDate'] as Timestamp;
    return Tournament(
      startDate: startTimestamp?.toDate(),
      endDate: endTimestamp?.toDate(),
      name: data['name'],
      details: data['details'],
      id: data['id'],
      location: data['location'],
      owner: data['owner'],
      scorers: data['scorers']?.cast<String>(),
      status: EnumToString.fromString(GameStatus.values, data['status']),
      year: data['year'],
    );
  }

  String toJson() => json.encode(toMap());

  static Tournament fromJson(String source) => fromMap(json.decode(source));
}
