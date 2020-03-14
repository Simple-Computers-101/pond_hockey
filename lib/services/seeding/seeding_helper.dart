import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';
import 'package:pond_hockey/services/seeding/bracket_helper.dart';
import 'package:pond_hockey/services/seeding/qualifiers.dart';
import 'package:pond_hockey/services/seeding/semi_finals.dart';
import 'package:uuid/uuid.dart';

class SeedingHelper {
  static void seedGames(
    Division div,
    GameType type,
    int semiFinalTeams,
    String tournamentId, {
    void Function(String) onError,
  }) async {
    if (type == GameType.qualifier) {
      await GamesRepository().deleteGamesFromTournament(tournamentId, div);
    }
    var teams = await TeamsRepository().getTeamsFromTournamentId(
      tournamentId,
      division: div,
    );
    if (teams.length < 4 && type != GameType.closing) {
      onError('not_enough_teams');

      return;
    }
    var bracket = <List<Team>>[];
    var qualifiersBracket = <String, List<List<Team>>>{};
    switch (type) {
      case GameType.qualifier:
        qualifiersBracket = QualifiersSeeding.start(teams);
        qualifiersBracket.removeWhere(
          (key, value) => value.expand((element) => element).contains('0'),
        );
        break;
      case GameType.semiFinal:
        if (await GamesRepository()
            .areAllGamesCompleted(tournamentId, division: div)) {
          var semiTeams = await _getSemiTeams(
            tournamentId,
            semiFinalTeams,
            div,
          );
          bracket = SemiFinalsSeeding.start(semiTeams);
        } else {
          return onError('incomplete');
        }
        break;
      case GameType.closing:
        if (await GamesRepository()
            .areAllGamesCompleted(tournamentId, division: div)) {
          var teams = await TeamsRepository().getTeamsFromPointDiff(
            tournamentId,
            2,
            division: div,
            type: GameType.semiFinal,
          );
          var game = Game(
            id: Uuid().v4(),
            tournament: tournamentId,
            teamOne: GameTeam.fromTeam(teams[0]),
            teamTwo: GameTeam.fromTeam(teams[1]),
            type: GameType.closing,
            division: div,
            round: 1,
          );
          GamesRepository().addGame(game);
        } else {
          return onError('incomplete');
        }
        break;
    }
    if (bracket.isNotEmpty) {
      var games = BracketHelper.convertToGames(bracket, type);
      for (final game in games) {
        await GamesRepository().addGame(game);
      }
      return;
    }
    if (qualifiersBracket.isNotEmpty) {
      final rounds = qualifiersBracket.keys.length;
      for (var i = 1; i <= rounds; i++) {
        var thing = qualifiersBracket['round$i'];
        for (var teams in thing) {
          var game = Game(
            id: Uuid().v4(),
            tournament: tournamentId,
            teamOne: GameTeam.fromTeam(teams[0]),
            teamTwo: GameTeam.fromTeam(teams[1]),
            type: type,
            division: div,
            round: i,
          );
          await GamesRepository().addGame(game);
        }
      }
    }
  }

  static Future<List<Team>> _getSemiTeams(
      String tournamentId, int semiFinalTeams, Division div) async {
    List<Team> semiTeams;
    if (await GamesRepository().alreadySemiFinalGames(tournamentId)) {
      semiTeams = await TeamsRepository().getTeamsFromPointDiff(
        tournamentId,
        semiFinalTeams,
        division: div,
      );
    } else {
      semiTeams = await TeamsRepository().getTeamsFromPointDiff(
        tournamentId,
        semiFinalTeams,
        division: div,
      );
    }
    return semiTeams;
  }
}
