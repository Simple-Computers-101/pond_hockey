import 'package:flutter/material.dart';
import 'package:pond_hockey/enums/viewing_mode.dart';

class TournamentViewing extends StatefulWidget {
  TournamentViewing({@required this.child});

  final Widget child;

  static _TournamentViewingState of(BuildContext context) {
    return context.findAncestorStateOfType<_TournamentViewingState>();
  }

  @override
  _TournamentViewingState createState() => _TournamentViewingState();
}

class _TournamentViewingState extends State<TournamentViewing> {
  ViewingMode _mode;
  ViewingMode get mode => _mode;

  void changeMode(ViewingMode newMode) {
    setState(() {
      _mode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
