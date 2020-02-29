import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/models/team.dart';

class TeamDetailsScreen extends StatelessWidget {
  const TeamDetailsScreen({Key key, this.team}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '"${team.name}"'),
      body: Center(
          child: Column(
        children: <Widget>[
          Text("Team Information"),
          ListTile(
            title: Text('Division'),
            subtitle: Text(
              EnumToString.parse(team.division) ?? 'No division',
            ),
          ),
          ListTile(
            title: Text('Games Played'),
            subtitle: Text(team.gamesPlayed.toString()),
          ),
          ListTile(
            title: Text('Games Won'),
            subtitle: Text(team.gamesWon.toString()),
          ),
          ListTile(
            title: Text('Games Lost'),
            subtitle: Text(team.gamesLost.toString()),
          )
        ],
      )),
    );
  }
}
