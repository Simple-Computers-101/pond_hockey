import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String id;
  String name;
  DocumentReference currentTournament;

  Team({
    this.id,
    this.name,
    this.currentTournament,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currentTournament': currentTournament.path,
    };
  }

  static Team fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Team(
      id: map['id'],
      name: map['name'],
      currentTournament: Firestore.instance.document(map['currentTournament']),
    );
  }

  String toJson() => json.encode(toMap());

  static Team fromJson(String source) => fromMap(json.decode(source));
}
