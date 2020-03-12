import 'package:pond_hockey/models/team.dart';

class SemiFinalsSeeding {
  static List<List<Team>> start(List<Team> teams) {
    if (teams.length.isOdd) return null;
    final copy = List<Team>.from(teams);
    var bracket = <List<Team>>[];
    // sorts the copy of the list
    copy.sort((teamOne, teamTwo) {
      // compares the point differentials, sorts from low to high
      // ex.
      // -13
      // -10
      // -5
      // 1
      // 3
      // 8
      // 9
      // 13
      return teamOne.pointDifferential.compareTo(teamTwo.pointDifferential);
    });
    // loops through half the length of the list
    for (var i = 0; i < (copy.length) ~/ 2; i++) {
      // gets the index from the other side of the list
      var secondIndex = (copy.length - 1) - i;
      // adds the team with the first index (low point dif) 
      // with another team (high point dif)
      bracket.add([copy[i], copy[secondIndex]]);
    }
    return bracket;
  }
}
