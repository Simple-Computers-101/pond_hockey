import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/screens/tournaments/widgets/games_list.dart';

class ScoreTournament extends StatelessWidget {
  const ScoreTournament({this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Score Games'),
      body: GamesList(
        tournamentId: tournament.id,
        isManaging: true,
      ),
    );
  }
}
