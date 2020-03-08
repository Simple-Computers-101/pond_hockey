import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/buttons/gradient_btn.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/manage_tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/game_item.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_division_dialog.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';
import 'package:pond_hockey/services/seeding/bracket_helper.dart';
import 'package:pond_hockey/services/seeding/qualifiers.dart';
import 'package:pond_hockey/services/seeding/semi_finals.dart';

class ManageGamesView extends StatefulWidget {
  const ManageGamesView({this.tournamentId, this.seeding = true});

  final String tournamentId;
  final bool seeding;

  @override
  _ManageGamesViewState createState() => _ManageGamesViewState();
}

class _ManageGamesViewState extends State<ManageGamesView> {
  Division division;
  bool empty = true;

  @override
  Widget build(BuildContext context) {
    void seedGames(GameType type) async {
      await GamesRepository().deleteGamesFromTournament(widget.tournamentId);
      var teams =
          await TeamsRepository().getTeamsFromTournamentId(widget.tournamentId);
      if (teams.length < 4) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('You need at least four teams.'),
          duration: Duration(seconds: 2),
        ));
        return null;
      }
      var bracket = <List<Team>>[];
      switch (type) {
        case GameType.qualifier:
          bracket = QualifiersSeeding.start(teams);
          bracket.removeWhere((element) => element.contains('0'));
          break;
        case GameType.semiFinal:
          bracket = SemiFinalsSeeding.start(teams);
          break;
        case GameType.closing:
          // TODO: create closing seeding algorithm
          break;
      }
      if (bracket == null) {
        throw Exception('No matching game type to seed.');
      }
      var games = BracketHelper.convertToGames(bracket, type);
      for (final game in games) {
        await GamesRepository().addGameToTournament(game);
      }
    }

    void _showChooseGameTypeDialog() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ChooseGameTypeDialog(
            onSubmit: seedGames,
          );
        },
      );
    }

    void _showFilterDivisionDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return FilterDivisionDialog(
            division: division,
            onDivisionChanged: (value) {
              setState(() {
                division = value;
              });
            },
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200])),
        color: Color(0xFFE9E9E9),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          if (!empty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: _showFilterDivisionDialog,
                ),
                if (widget.seeding)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      tooltip: 'Re-seed games',
                      onPressed: _showChooseGameTypeDialog,
                    ),
                  ),
              ],
            ),
          Expanded(
            child: FirestoreAnimatedList(
              query: GamesRepository().getGamesFromTournamentId(
                widget.tournamentId,
                division,
              ),
              padding: widget.seeding
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(vertical: 24),
              onLoaded: (snap) {
                setState(() {
                  empty = snap.documents.isEmpty;
                });
              },
              shrinkWrap: true,
              itemBuilder: (cntx, doc, anim, indx) {
                var game = Game.fromDocument(doc);
                return GameItem(
                  gameId: game.id,
                  onTap: () {
                    Router.navigator.pushNamed(
                      Router.manageGame,
                      arguments: game,
                    );
                  },
                );
              },
              emptyChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('There are no games.'),
                  Text('Click below to create some.'),
                  GradientButton(
                    onTap: _showChooseGameTypeDialog,
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.09,
                    colors: [
                      Color(0xFFC84E89),
                      Color(0xFFF15F79),
                    ],
                    text: 'Seed Games',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
