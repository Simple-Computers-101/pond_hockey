import 'package:flutter/material.dart';
import 'package:pond_hockey/components/dialog/dialog_buttons.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/router/router.gr.dart';

typedef SeedingSubmit = void Function(Division, GameType, int);

class SeedingSettingsDialog extends StatefulWidget {
  const SeedingSettingsDialog({this.onSubmit});

  final SeedingSubmit onSubmit;

  @override
  _SeedingSettingsDialogState createState() => _SeedingSettingsDialogState();
}

class _SeedingSettingsDialogState extends State<SeedingSettingsDialog> {
  GameType gameType = GameType.qualifier;
  Division division = Division.open;
  int quarterFinalTeams;

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
                child: Text('Quarter-finals'),
                value: GameType.quarterFinals,
              ),
              DropdownMenuItem(
                child: Text('Semi-finals'),
                value: GameType.semiFinal,
              ),
              DropdownMenuItem(
                child: Text('Finals'),
                value: GameType.finals,
              ),
            ],
            value: gameType,
            onChanged: (type) {
              setState(() {
                gameType = type;
              });
            },
          ),
          if (gameType == GameType.quarterFinals)
            DropdownButton<int>(
              isExpanded: true,
              hint: Text('Quarter-final teams'),
              items: [
                DropdownMenuItem(
                  child: Text('8'),
                  value: 8,
                ),
                DropdownMenuItem(
                  child: Text('16'),
                  value: 16,
                ),
              ],
              value: quarterFinalTeams,
              onChanged: (value) {
                setState(() {
                  quarterFinalTeams = value;
                });
              },
            ),
        ],
      ),
      actions: <Widget>[
        SecondaryDialogButton(onPressed: Router.navigator.pop, text: 'Cancel'),
        PrimaryDialogButton(
          text: 'Submit',
          onPressed: () {
            Router.navigator.pop();
            widget.onSubmit(division, gameType, quarterFinalTeams);
          },
        ),
      ],
    );
  }
}
