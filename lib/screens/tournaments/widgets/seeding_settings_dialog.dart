import 'package:flutter/material.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/router/router.gr.dart';

class SeedingSettingsDialog extends StatefulWidget {
  const SeedingSettingsDialog({this.onSubmit});

  final Function(Division, GameType, int) onSubmit;

  @override
  _SeedingSettingsDialogState createState() => _SeedingSettingsDialogState();
}

class _SeedingSettingsDialogState extends State<SeedingSettingsDialog> {
  GameType gameType = GameType.qualifier;
  Division division = Division.open;
  int semiFinalTeams;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Seeding settings'),
      content: Column(
        children: <Widget>[
          DropdownButton<Division>(
            isExpanded: true,
            items: [
              DropdownMenuItem(child: Text('Open'), value: Division.open),
              DropdownMenuItem(
                child: Text('Recreational'),
                value: Division.rec,
              ),
            ],
            value: division,
            onChanged: (value) {
              setState(() {
                division = value;
              });
            },
          ),
          DropdownButton<GameType>(
            isExpanded: true,
            items: [
              DropdownMenuItem(
                child: Text('Qualifier'),
                value: GameType.qualifier,
              ),
              DropdownMenuItem(
                child: Text('Semi-finals'),
                value: GameType.semiFinal,
              ),
              DropdownMenuItem(
                child: Text('Closing'),
                value: GameType.closing,
              ),
            ],
            value: gameType,
            onChanged: (type) {
              setState(() {
                gameType = type;
              });
            },
          ),
          if (gameType == GameType.semiFinal)
            DropdownButton<int>(
              isExpanded: true,
              hint: Text('Semi-final teams'),
              items: [
                DropdownMenuItem(
                  child: Text('4'),
                  value: 4,
                ),
                DropdownMenuItem(
                  child: Text('6'),
                  value: 6,
                ),
                DropdownMenuItem(
                  child: Text('8'),
                  value: 8,
                ),
                DropdownMenuItem(
                  child: Text('10'),
                  value: 10,
                ),
                DropdownMenuItem(
                  child: Text('12'),
                  value: 12,
                ),
              ],
              value: semiFinalTeams,
              onChanged: (value) {
                setState(() {
                  semiFinalTeams = value;
                });
              },
            ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Router.navigator.pop();
            widget.onSubmit(division, gameType, semiFinalTeams);
          },
          child: Text('Submit'),
        ),
        FlatButton(
          onPressed: Router.navigator.pop,
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
