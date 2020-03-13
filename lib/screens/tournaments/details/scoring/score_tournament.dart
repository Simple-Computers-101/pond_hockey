import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/screens/tournaments/widgets/manage_games_view.dart';

class ScoreTournament extends StatelessWidget {
  const ScoreTournament({this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Score Games'),
      body: ManageGamesView(
        tournamentId: tournament.id,
        isSeeding: false,
      ),
    );
  }
}
