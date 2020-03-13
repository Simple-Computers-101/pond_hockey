import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';

class TeamsRepository {
  final db = Firestore.instance;
  static CollectionReference ref = Firestore.instance.collection('teams');

  Future<void> addTeamsToTournament(List<Team> teams) {
    var batch = db.batch();
    for (var team in teams) {
      batch.setData(ref.document(team.id), team.toMap());
    }
    return batch.commit();
  }

  Future<Team> getTeamFromId(String teamId) async {
    var teams = await ref.where('id', isEqualTo: teamId).getDocuments();
    if (teams.documents.isEmpty) {
      throw Exception('The requested team is not found');
    }
    var team = Team.fromMap(teams.documents.first.data);
    return team;
  }

  Future<void> calculateDifferential(String teamId) async {
    var differential =
        await GamesRepository().getDifferentialFromTeamId(teamId);

    return ref.document(teamId).updateData({'pointDifferential': differential});
  }

  Future<List<Team>> getTeamsFromPointDiff(String tournament, int number,
      {Division division, GameType gameType, bool useWins = false}) async {
    var teams = await getTeamsFromTournamentId(tournament, division: division);
    if (number > teams.length) {
      return [];
    }
    if (useWins) {
      teams.sort((teamOne, teamTwo) {
        return teamOne.gamesWon.compareTo(teamTwo.gamesWon);
      });
    } else {
      teams.sort((teamOne, teamTwo) {
        return teamOne.pointDifferential.compareTo(teamTwo.pointDifferential);
      });
    }
    return teams.reversed.take(number).toList();
  }

  Future<void> addTeamVictory(String teamId) async {
    var doc = await ref.document(teamId).get();
    var team = Team.fromMap(doc.data);
    var victories = team.gamesWon + 1;
    return ref.document(teamId).updateData(
      {'gamesWon': victories++},
    );
  }

  Future<void> addTeamLoss(String teamId) async {
    var doc = await ref.document(teamId).get();
    var team = Team.fromMap(doc.data);
    var losses = team.gamesLost + 1;
    return doc.reference.updateData(
      {'gamesLost': losses++},
    );
  }

  Future<void> addGamePlayed(String teamId) async {
    var doc = await ref.document(teamId).get();
    var team = Team.fromMap(doc.data);
    var plays = team.gamesPlayed + 1;
    return doc.reference.updateData({'gamesPlayed': plays});
  }

  Future<List<Team>> getTeamsFromTournamentId(String id,
      {Division division}) async {
    QuerySnapshot query;
    if (division != null) {
      query = await ref
          .where('currentTournament', isEqualTo: id)
          .where('division', isEqualTo: divisionMap[division])
          .getDocuments();
    } else {
      query =
          await ref.where('currentTournament', isEqualTo: id).getDocuments();
    }

    return query.documents.map((e) => Team.fromMap(e.data)).toList();
  }

  Stream<QuerySnapshot> getTeamsStreamFromTournamentId(String id,
      {Division division}) {
    if (division != null) {
      var normal = ref
          .where('currentTournament', isEqualTo: id)
          .where('division', isEqualTo: divisionMap[division])
          .snapshots();

      return normal;
    }
    return ref.where('currentTournament', isEqualTo: id).snapshots();
  }
}
