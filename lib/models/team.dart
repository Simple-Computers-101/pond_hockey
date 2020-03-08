import 'package:flutter/widgets.dart';
import 'package:pond_hockey/enums/division.dart';

class Team {
  String id;
  String name;
  String currentTournament;
  Division division;
  int gamesLost;
  int gamesPlayed;
  int gamesWon;
  int pointDifferential;

  Team({
    @required this.id,
    @required this.name,
    @required this.currentTournament,
    @required this.division,
    this.gamesLost = 0,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.pointDifferential = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currentTournament': currentTournament,
      'division': divisionMap[division],
      'gamesLost': gamesLost,
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'pointDifferential': pointDifferential,
    };
  }

  static Team fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    var divisionFromMap = divisionMap.keys.firstWhere(
      (element) => divisionMap[element] == map['division'],
    );

    return Team(
      id: map['id'],
      name: map['name'],
      currentTournament: map['currentTournament'],
      division: divisionFromMap,
      gamesLost: map['gamesLost'],
      gamesPlayed: map['gamesPlayed'],
      gamesWon: map['gamesWon'],
      pointDifferential: map['pointDifferential'],
    );
  }
}
