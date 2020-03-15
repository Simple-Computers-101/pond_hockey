import 'package:flutter/material.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/router/router.gr.dart';

class FilterGameTypeDialog extends StatefulWidget {
  FilterGameTypeDialog({this.gameType, this.onGameTypeChanged});

  final GameType gameType;
  final ValueChanged<GameType> onGameTypeChanged;

  @override
  _FilterGameTypeDialogState createState() => _FilterGameTypeDialogState();
}

class _FilterGameTypeDialogState extends State<FilterGameTypeDialog> {
  GameType _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.gameType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Game Type'),
      content: DropdownButton<GameType>(
        items: [
          DropdownMenuItem(
            child: Text('All'),
            value: null,
          ),
          DropdownMenuItem(
            child: Text('Qualifiers'),
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
        value: _selected,
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _selected = value;
          });
        },
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Router.navigator.pop();
            widget.onGameTypeChanged(_selected);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
