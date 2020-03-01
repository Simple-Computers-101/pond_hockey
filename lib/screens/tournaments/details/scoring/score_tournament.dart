import 'package:flutter/material.dart';
import 'package:pond_hockey/models/tournament.dart';

class ScoreTournament extends StatelessWidget {
  const ScoreTournament({this.tournament});
  
  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, child: FlutterLogo());
  }
}
