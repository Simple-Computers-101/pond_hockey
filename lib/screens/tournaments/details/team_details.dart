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
        child: Text(team.name),
      ),
    );
  }
}