import 'package:pond_hockey/models/team.dart';

class SemiFinalsSeeding {
  static List<List<Team>> start(List<Team> teams) {
    // Already got number of teams
    // Ties have to be sorted out before
    if (teams.length.isOdd) return null;
    final copy = List<Team>.from(teams);
    var bracket = <List<Team>>[];
    copy.sort((teamOne, teamTwo) {
      return teamOne.pointDifferential.compareTo(teamTwo.pointDifferential);
    });
    for (var i = 0; i < (copy.length) ~/ 2; i++) {
      var secondIndex = (copy.length - 1) - i;
      bracket.add([copy[i], copy[secondIndex]]);
    }
    return bracket;
  }
}
