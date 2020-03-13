import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/buttons/gradient_btn.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/game_item.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_division_dialog.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_games_buttons.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_gametype_dialog.dart';
import 'package:pond_hockey/screens/tournaments/widgets/seeding_settings_dialog.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';
import 'package:pond_hockey/services/seeding/bracket_helper.dart';
import 'package:pond_hockey/services/seeding/qualifiers.dart';
import 'package:pond_hockey/services/seeding/semi_finals.dart';
import 'package:uuid/uuid.dart';

class ManageGamesView extends StatefulWidget {
  const ManageGamesView({this.tournamentId, this.isSeeding = true});

  final String tournamentId;
  final bool isSeeding;

  @override
  _ManageGamesViewState createState() => _ManageGamesViewState();
}

class _ManageGamesViewState extends State<ManageGamesView> {
  Division _selectedDivision;
  GameType _selectedGameType;

  @override
  Widget build(BuildContext context) {
    void seedGames(Division div, GameType type, int semiFinalTeams) async {
      if (type == GameType.qualifier) {
        await GamesRepository().deleteGamesFromTournament(
          widget.tournamentId,
          div,
        );
      }
      var teams = await TeamsRepository().getTeamsFromTournamentId(
        widget.tournamentId,
        division: div,
      );
      if (teams.length < 4 && type != GameType.closing) {
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
          if (await GamesRepository().areAllGamesCompleted(widget.tournamentId,
              division: _selectedDivision)) {
            var semiTeams;
            if (await GamesRepository()
                .alreadySemiFinalGames(widget.tournamentId)) {
              semiTeams = await TeamsRepository().getTeamsFromPointDiff(
                widget.tournamentId,
                semiFinalTeams,
                division: _selectedDivision,
                useWins: true,
              );
            } else {
              semiTeams = await TeamsRepository().getTeamsFromPointDiff(
                widget.tournamentId,
                semiFinalTeams,
                division: _selectedDivision,
              );
            }
            bracket = SemiFinalsSeeding.start(semiTeams);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('All games are not completed'),
              ),
            );
          }
          break;
        case GameType.closing:
          if (await GamesRepository().areAllGamesCompleted(widget.tournamentId,
              division: _selectedDivision)) {
            var teams = await TeamsRepository().getTeamsFromPointDiff(
              widget.tournamentId,
              2,
              division: _selectedDivision,
              gameType: GameType.semiFinal,
              useWins: true,
            );
            var game = Game(
              id: Uuid().v4(),
              tournament: widget.tournamentId,
              teamOne: GameTeam.fromTeam(teams[0]),
              teamTwo: GameTeam.fromTeam(teams[1]),
              type: GameType.closing,
              division: div,
            );
            GamesRepository().addGame(game);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('All games are not completed'),
              ),
            );
          }
          break;
      }
      if (bracket == null) {
        throw Exception('No matching game type to seed.');
      }
      var games = BracketHelper.convertToGames(bracket, type);
      for (final game in games) {
        await GamesRepository().addGame(game);
      }
    }

    List<Widget> buildNoGames() {
      return [
        if (widget.isSeeding) ...[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('There are no games.'),
              Text('Click below to create some.'),
              GradientButton(
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return SeedingSettingsDialog(
                        onSubmit: seedGames,
                      );
                    },
                  );
                },
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
        ] else
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('There are no games.'),
            ],
          ),
      ];
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE9E9E9),
      ),
      child: StreamBuilder(
        stream: GamesRepository().getGamesStreamFromTournamentId(
          widget.tournamentId,
          division: _selectedDivision,
          pGameType: _selectedGameType,
        ),
        builder: (cntx, snap) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: <Widget>[
              FilterGamesButtons(
                isSeeding: widget.isSeeding,
                onDivisionChanged: (value) {
                  setState(() {
                    _selectedDivision = value;
                  });
                },
                onGameTypeChanged: (value) {
                  setState(() {
                    _selectedGameType = value;
                  });
                },
                onSeedingSubmitted: seedGames,
                selectedDivision: _selectedDivision,
                selectedGameType: _selectedGameType,
              ),
              if (!snap.hasData)
                Center(child: CircularProgressIndicator())
              else if (snap.data?.documents?.isNotEmpty)
                ...buildGamesList(snap)
              else
                ...buildNoGames(),
            ],
          );
        },
      ),
    );
  }

  List<Widget> buildGamesList(AsyncSnapshot snap) {
    var docs = snap.data.documents as List<DocumentSnapshot>;
    var games = docs.map(Game.fromDocument);
    var qualifiers =
        games.where((element) => element.type == GameType.qualifier).toList();
    var semiFinals =
        games.where((element) => element.type == GameType.semiFinal).toList();
    var closings =
        games.where((element) => element.type == GameType.closing).toList();
    return [
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      Text(
        'Qualifiers',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'CircularStd',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: qualifiers.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (cntx, indx) {
          return GameItem(
            gameId: qualifiers[indx].id,
            onTap: () {
              Router.navigator.pushNamed(
                Router.manageGame,
                arguments: qualifiers[indx],
              );
            },
          );
        },
        separatorBuilder: (cntx, _) => Spacer(),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      Text(
        'Semi-finals',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'CircularStd',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: semiFinals.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (cntx, indx) {
          return GameItem(
            gameId: semiFinals[indx].id,
            onTap: () {
              Router.navigator.pushNamed(
                Router.manageGame,
                arguments: semiFinals[indx],
              );
            },
          );
        },
        separatorBuilder: (cntx, _) => Spacer(),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      Text(
        'Closings',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'CircularStd',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: closings.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (cntx, indx) {
          return GameItem(
            gameId: closings[indx].id,
            onTap: () {
              Router.navigator.pushNamed(
                Router.manageGame,
                arguments: closings[indx],
              );
            },
          );
        },
        separatorBuilder: (cntx, _) => Spacer(),
      ),
    ];
  }
}
