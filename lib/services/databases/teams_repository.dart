import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pond_hockey/models/team.dart';

class TeamsRepository {
  final CollectionReference ref = Firestore.instance.collection('teams');

  // Future<List<Team>> getTeamsFromTournamentId(String tournamentId) async {
  //   var query = await ref
  //       .where('currentTournament', isEqualTo: tournamentId)
  //       .getDocuments();
  //   return query.documents
  //       .map((snapshot) => Team.fromMap(snapshot.data))
  //       .toList(growable: false);
  // }

  Future<void> addTeamsToTournament(List<Team> teams) async {
    for (var team in teams) {
      await ref.document(team.id).setData(team.toMap());
    }
  }

  Stream<QuerySnapshot> getTeamsStreamFromTournament(String id) {
    return ref.where('currentTournament', isEqualTo: id).snapshots();
  }
}
