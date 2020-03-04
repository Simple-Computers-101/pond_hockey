/// Seeding algorithm
/// Each team plays three times
/// Shouldn't play the same team

class ThreeGGAlgorithm {
  static List<List<String>> start(List<String> origTeams) {
    if (origTeams.length < 4) {
      return null;
    }
    var teams = List<String>.from(origTeams);
    var maxRounds = 3;
    if (teams.length.isOdd) {
      teams.add('0');
      maxRounds = 4;
    }
    // maxRounds = (teams.length - 1);
    var splitTeams = _splitList(teams);
    var rotatedTeams = splitTeams;
    var bracket = <List<String>>[];
    for (var i = 1; i <= maxRounds; i++) {
      for (var b = 0; b < rotatedTeams[0].length; b++) {
        bracket.add([rotatedTeams[0][b], rotatedTeams[1][b]]);
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
