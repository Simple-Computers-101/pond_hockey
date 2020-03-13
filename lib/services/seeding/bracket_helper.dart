import 'package:pond_hockey/enums/game_status.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:uuid/uuid.dart';

class BracketHelper {
  static List<Game> convertToGames(List<List<Team>> bracket, GameType type) {
    var games = <Game>[];

    for (var teams in bracket) {
      if (teams.length != 2) continue;
      if (teams[0].currentTournament != teams[1].currentTournament) {
        throw Exception('Team\'s tournaments don\'t match!');
      }
      if (teams[0].division != teams[1].division) {
        continue;
      }
      games.add(
        Game(
          id: Uuid().v4(),
          division: teams[0].division,
          status: GameStatus.notStarted,
          teamOne: GameTeam.fromTeam(teams[0]),
          teamTwo: GameTeam.fromTeam(teams[1]),
          tournament: teams[0].currentTournament,
          type: type,
          round: null
        ),
      );
    }
    return games;
  }
}
