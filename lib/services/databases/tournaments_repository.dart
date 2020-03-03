import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pond_hockey/models/tournament.dart';

class TournamentsRepository {
  final CollectionReference ref = Firestore.instance.collection('tournaments');

  Future<void> addTournament(Tournament tournament) {
    return ref.document(tournament.id).setData(tournament.toMap());
  }

  Future<Tournament> getTournament(String id) async {
    if ((await ref.document(id).get()).exists == false) {
      return null;
    }
    return Tournament.fromDocument(await ref.document(id).get());
  }

  Future<void> addScorer(String tournamentId, String uid) {
    return ref.document(tournamentId).setData({
      'scorers': [uid]
    }, merge: true);
  }

  Future<void> addEditor(String tournamentId, String uid) {
    return ref.document(tournamentId).setData({
      'editors': [uid]
    }, merge: true);
  }

  Future<List<Tournament>> getEditableTournaments(String uid) async {
    final ownedTournamentsQuery =
        await ref.where('owner', isEqualTo: uid).getDocuments();
    final editableTournamentsQuery =
        await ref.where('editors', arrayContains: uid).getDocuments();

    final ownedTournaments =
        ownedTournamentsQuery.documents.map(Tournament.fromDocument);
    final editableTournaments =
        editableTournamentsQuery.documents.map(Tournament.fromDocument);

    final overlappedTournaments = []
      ..addAll(ownedTournaments)
      ..addAll(editableTournaments);

    return overlappedTournaments.toSet().toList().cast<Tournament>();
  }

  Future<void> deleteTournament(String tournamentId) {
    return ref.document(tournamentId).delete();
  }

  Future<List<Tournament>> getScorerTournaments(String uid) async {
    final query = await ref.where('scorers', arrayContains: uid).getDocuments();
    final editableTournaments = await getEditableTournaments(uid);

    final scorableTournaments =
        query.documents.map(Tournament.fromDocument).toList();

    final overlappingTournaments = []
      ..addAll(scorableTournaments)
      ..addAll(editableTournaments);

    return overlappingTournaments.toSet().toList();
  }
}
