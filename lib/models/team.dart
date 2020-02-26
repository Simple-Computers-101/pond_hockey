import 'dart:convert';

class Team {
  String id;
  String name;
  String currentTournament;
  String division;
  int gamesLost;
  int gamesPlayed;
  int gamesWon;
  int pointDifferential;

  Team({
    this.id,
    this.name,
    this.currentTournament,
    this.division,
    this.gamesLost,
    this.gamesPlayed,
    this.gamesWon,
    this.pointDifferential,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currentTournament': currentTournament,
      'division': division,
      'gamesLost': gamesLost,
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'pointDifferential': pointDifferential,
    };
  }

  static Team fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Team(
      id: map['id'],
      name: map['name'],
      currentTournament: map['currentTournament'],
      division: map['division'],
      gamesLost: map['gamesLost'],
      gamesPlayed: map['gamesPlayed'],
      gamesWon: map['gamesWon'],
      pointDifferential: map['pointDifferential'],
    );
  }

  String toJson() => json.encode(toMap());

  static Team fromJson(String source) => fromMap(json.decode(source));
}
