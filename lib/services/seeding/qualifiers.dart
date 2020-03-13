import 'package:pond_hockey/models/team.dart';

/// Seeding algorithm
/// Each team plays three times
/// Shouldn't play the same team

class QualifiersSeeding {
  static List<List<Team>> start(List<Team> origTeams) {
    if (origTeams.length < 4) return null;

    final teams = origTeams.map((e) => e.id).toList();
    var maxRounds = 3;

    if (teams.length.isOdd) {
      teams.add('0');
      maxRounds = 4;
    }

    final splitTeams = _splitList(teams);
    var rotatedTeams = splitTeams;
    final bracket = <List<Team>>[];

    Team getTeam(String id) {
      if (id == '0') return null;
      return origTeams.firstWhere((element) => element.id == id);
    }

    for (var i = 1; i <= maxRounds; i++) {

      print('Round $i');

      for (var b = 0; b < teams.length ~/ 2; b++) {
        var teamOne = getTeam(rotatedTeams[0][b]);
        var teamTwo = getTeam(rotatedTeams[1][b]);
        print('${rotatedTeams[0][b]} vs. + ${rotatedTeams[1][b]}');
        if (teamOne == null || teamTwo == null) continue;
        bracket.add([teamOne, teamTwo]);
      }
      rotatedTeams = _rotateTeams(splitTeams);
    }
    return bracket;
  }

  static List<List<String>> _splitList(List<String> split) {
    var first = split.sublist(0, split.length ~/ 2);
    var last = split.sublist(split.length ~/ 2);
    return []..add(first)..add(last.reversed.toList());
  }

  static List<List<String>> _rotateTeams(List<List<String>> rotate) {
    var firstList = rotate[0];
    var secondList = rotate[1];
    var itemToMove = firstList.removeLast();
    secondList.add(itemToMove);
    var moveToFirst = secondList.removeAt(0);
    firstList.insert(1, moveToFirst);
    return []..add(firstList)..add(secondList);
  }
}
