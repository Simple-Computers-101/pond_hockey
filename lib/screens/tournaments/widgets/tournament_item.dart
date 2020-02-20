import 'package:flutter/material.dart';
import 'package:pond_hockey/models/tournament.dart';

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
          onTap: () {},
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
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          tournament.year.toString(),
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text(
                          tournament.location ?? 'Nowhere',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  tournament.details ?? '',
                  maxLines: 1,
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
