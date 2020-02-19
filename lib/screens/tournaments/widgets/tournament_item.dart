import 'package:flutter/material.dart';
import 'package:pond_hockey/models/tournament.dart';

class TournamentItem extends StatelessWidget {
  const TournamentItem(this.tournament, {Key key}) : super(key: key);

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  tournament.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.display4,
                ),
              ),
              Text(
                tournament.year.toString(),
                style: Theme.of(context).textTheme.subtitle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
