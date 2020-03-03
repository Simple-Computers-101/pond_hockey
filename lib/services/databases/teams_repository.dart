import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pond_hockey/models/team.dart';

class TeamsRepository {
  final CollectionReference ref = Firestore.instance.collection('teams');

  Future<void> addTeamsToTournament(List<Team> teams) async {
    for (var team in teams) {
      await ref.document(team.id).setData(team.toMap());
    }
  }

  Future<Team> getTeamFromId(String teamId) async {
    var teams = await ref.where('id', isEqualTo: teamId).getDocuments();
    var team = Team.fromMap(teams.documents.first.data);
    return team;
  }

  Future<List<Team>> getTeamsFromTournamentId(String id) async {
    var query =
        await ref.where('currentTournament', isEqualTo: id).getDocuments();

    return query.documents.map((e) => Team.fromMap(e.data)).toList();
  }

  Stream<QuerySnapshot> getTeamsStreamFromTournamentId(String id) {
    return ref.where('currentTournament', isEqualTo: id).snapshots();
  }
}
