import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pond_hockey/models/tournament.dart';

class TournamentsRepository {
  final CollectionReference ref = Firestore.instance.collection('tournaments');

  Future<void> addTournament(Tournament tournament) {
    return ref.document(tournament.id).setData(tournament.toMap());
  }

  Future<void> updateTournament(String id, Map<String, dynamic> newData) {
    return ref.document(id).updateData(newData);
  }

  Future<Tournament> getTournament(String id) async {
    if ((await ref.document(id).get()).exists == false) {
      return null;
    }
    return Tournament.fromDocument(await ref.document(id).get());
  }

  Future<List<Tournament>> getOwnedTournaments(String uid) async {
    final query = await ref.where('owner', isEqualTo: uid).getDocuments();
    return query.documents.map(Tournament.fromDocument).toList();
  }

  Future<void> deleteTournament(String tournamentId) {
    return ref.document(tournamentId).delete();
  }

  Future<List<Tournament>> getScorerTournaments(String uid) async {
    final query = await ref.where('scorers', arrayContains: uid).getDocuments();
    final ownedTournaments = await getOwnedTournaments(uid);

    final scorableTournaments =
        query.documents.map(Tournament.fromDocument).toList();
    final overlappingTournaments = scorableTournaments
      ..addAll(ownedTournaments);

    return overlappingTournaments.toSet().toList();
  }
}
