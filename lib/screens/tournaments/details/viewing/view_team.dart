import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/models/team.dart';

class TeamDetailsScreen extends StatelessWidget {
  const TeamDetailsScreen({this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '"${team.name}"'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Team Information"),
            ListTile(
              title: Text('Division'),
              subtitle: Text(
                divisionMap[team.division] ?? 'No division',
              ),
            ),
            ListTile(
              title: Text('Games Played'),
              subtitle: Text('${team.gamesPlayed}'),
            ),
            ListTile(
              title: Text('Games Won'),
              subtitle: Text('${team.gamesWon}'),
            ),
            ListTile(
              title: Text('Games Lost'),
              subtitle: Text('${team.gamesLost}'),
            ),
            ListTile(
              title: Text('Point Differential'),
              subtitle: Text('${team.pointDifferential}'),
            ),
          ],
        ),
      ),
    );
  }
}
