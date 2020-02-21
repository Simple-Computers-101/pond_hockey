import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/tournament_details.dart';

class TournamentItem extends StatelessWidget {
  const TournamentItem(this.tournament, {Key key}) : super(key: key);

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            Router.navigator.push(
              MaterialPageRoute(
                builder: (_) => TournamentDetails(
                  tournament: tournament,
                ),
              ),
            );
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
                      child: TextOneLine(
                        tournament.name,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
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
