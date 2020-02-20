import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_item.dart';

class TournamentsList extends StatelessWidget {
  const TournamentsList({Key key, this.documents}) : super(key: key);

  final List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarColor(Color(0xFFE9E9E9));

    final tournaments = documents.map(
      (snapshot) => Tournament.fromMap(snapshot.data),
    );
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE9E9E9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(50))
      ),
      child: ListView(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        children: tournaments.map((e) {
          return TournamentItem(e);
        }).toList(),
      ),
    );
  }
}
