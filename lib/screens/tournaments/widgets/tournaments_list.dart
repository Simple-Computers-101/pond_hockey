import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_item.dart';

class TournamentsList extends StatelessWidget {
  const TournamentsList({Key key, this.documents}) : super(key: key);

  final List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    final tournaments = documents.map(
      (snapshot) => Tournament.fromMap(snapshot.data),
    );
    return ListView(
      primary: false,
      children: tournaments.map((e) {
        return TournamentItem(e);
      }).toList(),
    );
  }
}
