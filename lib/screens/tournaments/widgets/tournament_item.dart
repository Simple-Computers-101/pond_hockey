import 'package:flutter/material.dart';
import 'package:pond_hockey/enums/viewing_mode.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_viewing.dart';

class TournamentItem extends StatelessWidget {
  const TournamentItem(this.tournament);

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    var mode = TournamentViewing.of(context).mode;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            switch (mode) {
              case ViewingMode.viewing:
                Router.navigator.pushNamed(
                  Router.tournamentDetails,
                  arguments: tournament,
                );
                break;
              case ViewingMode.scoring:
                Router.navigator.pushNamed(
                  Router.scoreTournament,
                  arguments: tournament,
                );
                break;
              case ViewingMode.editing:
                Router.navigator.pushNamed(
                  Router.manageTournament,
                  arguments: tournament,
                );
                break;
            }
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.lightBlue.withOpacity(0.25),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        tournament.name,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.05,
                            ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          tournament.year.toString(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          tournament.location ?? 'Nowhere',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  indent: 30,
                  endIndent: 30,
                ),
                Text(
                  tournament.details.trim().isEmpty
                      ? tournament.name
                      : tournament.details,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
