import 'package:flutter/material.dart';
import 'package:pond_hockey/components/dialog/dialog_buttons.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';
import 'package:uuid/uuid.dart';

class AddAGameDialog extends StatefulWidget {
  const AddAGameDialog({@required this.tournamentId});

  final String tournamentId;

  @override
  _AddAGameDialogState createState() => _AddAGameDialogState();
}

class _AddAGameDialogState extends State<AddAGameDialog> {
  List<Team> _teams;
  Team teamOne;
  Team teamTwo;
  Division division;
  GameType gameType;
  int round = 1;

  @override
  void initState() {
    super.initState();
    _getTeams();
  }

  void _getTeams() async {
    var teams = await TeamsRepository().getTeamsFromTournamentId(
      widget.tournamentId,
      division: division,
    );
    if (mounted) {
      setState(() {
        _teams = teams;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_teams == null) {
      return Center(child: CircularProgressIndicator());
    }
    return AlertDialog(
      scrollable: true,
      content: Column(
        children: <Widget>[
          DropdownButton<Division>(
            isExpanded: true,
            items: [
              DropdownMenuItem(
                child: Text('Open'),
                value: Division.open,
              ),
              DropdownMenuItem(
                child: Text('Recreational'),
                value: Division.rec,
              ),
            ],
            value: division,
            onChanged: (value) {
              setState(() {
                division = value;
                _getTeams();
              });
            },
            hint: Text('Division'),
          ),
          DropdownButton(
            isExpanded: true,
            items: _teams
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e.name),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                teamOne = value;
              });
            },
            hint: Text('Team'),
            value: teamOne,
          ),
          DropdownButton(
            isExpanded: true,
            items: _teams
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e.name),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                teamTwo = value;
              });
            },
            hint: Text('Team'),
            value: teamTwo,
          ),
          DropdownButton<GameType>(
            isExpanded: true,
            items: [
              DropdownMenuItem(
                child: Text('Qualifier'),
                value: GameType.qualifier,
              ),
              DropdownMenuItem(
                child: Text('Quarter-finals'),
                value: GameType.quarterFinals,
              ),
              DropdownMenuItem(
                child: Text('Semi-final'),
                value: GameType.semiFinal,
              ),
              DropdownMenuItem(
                child: Text('Finals'),
                value: GameType.finals,
              ),
            ],
            onChanged: (value) {
              setState(() {
                gameType = value;
              });
            },
            hint: Text('Game type'),
            value: gameType,
          ),
          DropdownButton<int>(
            isExpanded: true,
            items: [
              DropdownMenuItem(
                child: Text('1'),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text('2'),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text('3'),
                value: 3,
              ),
              DropdownMenuItem(
                child: Text('4'),
                value: 4,
              ),
            ],
            onChanged: (value) {
              setState(() {
                round = value;
              });
            },
            hint: Text('Round'),
            value: round,
          ),
        ],
      ),
      actions: <Widget>[
        SecondaryDialogButton(
          text: 'Cancel',
          onPressed: Router.navigator.pop,
        ),
        PrimaryDialogButton(
          text: 'Submit',
          onPressed: () {
            if (teamOne == null || teamTwo == null) return;
            var game = Game(
              division: division,
              id: Uuid().v4(),
              teamOne: GameTeam.fromTeam(teamOne),
              teamTwo: GameTeam.fromTeam(teamTwo),
              tournament: widget.tournamentId,
              type: gameType,
              round: round,
            );
            GamesRepository().addGame(game);
            Router.navigator.pop();
          },
        ),
      ],
    );
  }
}
