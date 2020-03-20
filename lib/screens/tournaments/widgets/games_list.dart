import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/buttons/gradient_btn.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_games_buttons.dart';
import 'package:pond_hockey/screens/tournaments/widgets/seeding_settings_dialog.dart';
import 'package:pond_hockey/screens/tournaments/widgets/sub_games_list.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/seeding/seeding_helper.dart';

class GamesList extends StatefulWidget {
  const GamesList({
    @required this.tournamentId,
    @required this.isManaging,
  });

  final String tournamentId;
  final bool isManaging;

  @override
  _GamesListState createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  Division _selectedDivision;
  GameType _selectedGameType;

  bool canUseColumns() {
    return kIsWeb && MediaQuery.of(context).size.width > 1024;
  }

  void _onSeedingSettingsComplete(Division div, GameType type, int teams) {
    SeedingHelper.seedGames(
      div,
      type,
      teams,
      widget.tournamentId,
      onError: (error) {
        Scaffold.of(context).hideCurrentSnackBar();
        switch (error) {
          case 'incomplete':
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('All games are not completed'),
              ),
            );
            break;
          case 'not_enough_teams':
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('You need at least four teams.'),
              duration: Duration(seconds: 2),
            ));
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildNoGames() {
      return [
        if (widget.isManaging) ...[
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
                        onSubmit: _onSeedingSettingsComplete,
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

    return ColoredBox(
      color: Color(0xFFE9E9E9),
      child: StreamBuilder(
        stream: GamesRepository().getGamesStreamFromTournamentId(
          widget.tournamentId,
          division: _selectedDivision,
          pGameType: _selectedGameType,
        ),
        builder: (cntx, snap) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            children: <Widget>[
              FilterGamesButtons(
                isSeeding: widget.isManaging,
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
                onSeedingSubmitted: _onSeedingSettingsComplete,
                selectedDivision: _selectedDivision,
                selectedGameType: _selectedGameType,
              ),
              if (!snap.hasData)
                Center(child: CircularProgressIndicator())
              else if (snap.data?.documents?.isNotEmpty)
                !canUseColumns()
                    ? buildGamesList(snap)
                    : buildWebGamesList(snap)
              else
                ...buildNoGames(),
            ],
          );
        },
      ),
    );
  }

  Widget buildWebGamesList(AsyncSnapshot snap) {
    final docs = snap.data.documents as List<DocumentSnapshot>;
    final games = docs.map(Game.fromDocument);
    final qualifiers =
        games.where((element) => element.type == GameType.qualifier).toList();
    if (canSortByDate(qualifiers)) {
      qualifiers.sort((gameOne, gameTwo) {
        return gameOne.startDate.compareTo(gameTwo.startDate);
      });
    }
    final qRoundOne =
        qualifiers.where((element) => element.round == 1).toList();
    final qRoundTwo =
        qualifiers.where((element) => element.round == 2).toList();
    final qRoundThree =
        qualifiers.where((element) => element.round == 3).toList();
    final qRoundFour =
        qualifiers.where((element) => element.round == 4).toList();
    final quarterFinals = games
        .where((element) => element.type == GameType.quarterFinals)
        .toList();
    final semiFinals =
        games.where((element) => element.type == GameType.semiFinal).toList();
    final closings =
        games.where((element) => element.type == GameType.finals).toList();

    if (canSortByDate(quarterFinals)) {
      quarterFinals.sort((gameOne, gameTwo) {
        return gameOne.startDate.compareTo(gameTwo.startDate);
      });
    }
    if (canSortByDate(semiFinals)) {
      semiFinals.sort((gameOne, gameTwo) {
        return gameOne.startDate.compareTo(gameTwo.startDate);
      });
    }
    var titleStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: 'CircularStd',
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 16),
        children: <Widget>[
          Text('Qualifiers', style: titleStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                decoration: BoxDecoration(
                  color: Color(0xFF4f4f4f),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: SubGamesList(
                  data: qRoundOne,
                  isManaging: widget.isManaging,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF4f4f4f),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SubGamesList(
                  data: qRoundTwo,
                  isManaging: widget.isManaging,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                decoration: BoxDecoration(
                  color: Color(0xFF4f4f4f),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: SubGamesList(
                  data: qRoundThree,
                  isManaging: widget.isManaging,
                ),
              ),
              if (qRoundFour.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                    color: Color(0xFF4f4f4f),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: SubGamesList(
                    data: qRoundFour,
                    isManaging: widget.isManaging,
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (quarterFinals.isNotEmpty) ...[
                Column(
                  children: [
                    Text('Quarter-finals', style: titleStyle),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      decoration: BoxDecoration(
                        color: Color(0xFF4f4f4f),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: SubGamesList(
                        data: quarterFinals,
                        isManaging: widget.isManaging,
                      ),
                    ),
                  ],
                ),
              ],
              if (semiFinals.isNotEmpty) ...[
                Column(
                  children: [
                    Text('Semi-finals', style: titleStyle),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      decoration: BoxDecoration(
                        color: Color(0xFF4f4f4f),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: SubGamesList(
                        data: semiFinals,
                        isManaging: widget.isManaging,
                      ),
                    ),
                  ],
                ),
              ],
              if (closings.isNotEmpty) ...[
                Column(
                  children: [
                    Text('Closings', style: titleStyle),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      decoration: BoxDecoration(
                        color: Color(0xFF4f4f4f),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: SubGamesList(
                        data: closings,
                        isManaging: widget.isManaging,
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  bool canSortByDate(List<Game> games) {
    for (final game in games) {
      if (game.startDate == null) {
        return false;
      }
    }
    return true;
  }

  Widget buildGamesList(AsyncSnapshot snap) {
    final docs = snap.data.documents as List<DocumentSnapshot>;
    final games = docs.map(Game.fromDocument);
    final qualifiers =
        games.where((element) => element.type == GameType.qualifier).toList();
    final qRoundOne =
        qualifiers.where((element) => element.round == 1).toList();
    final qRoundTwo =
        qualifiers.where((element) => element.round == 2).toList();
    final qRoundThree =
        qualifiers.where((element) => element.round == 3).toList();
    final qRoundFour =
        qualifiers.where((element) => element.round == 4).toList();
    final quarterFinals = games
        .where((element) => element.type == GameType.quarterFinals)
        .toList();
    final semiFinals =
        games.where((element) => element.type == GameType.semiFinal).toList();
    final closings =
        games.where((element) => element.type == GameType.finals).toList();
    if (canSortByDate(qualifiers)) {
      qualifiers.sort((gameOne, gameTwo) {
        return gameOne.startDate.compareTo(gameTwo.startDate);
      });
    }
    if (canSortByDate(semiFinals)) {
      semiFinals.sort((gameOne, gameTwo) {
        return gameOne.startDate.compareTo(gameTwo.startDate);
      });
    }
    final headingStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'CircularStd',
    );
    var titleStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: 'CircularStd',
    );
    var data = <Widget>[
      Text('Qualifiers', style: titleStyle),
      Text('Round 1', style: headingStyle),
      SubGamesList(data: qRoundOne, isManaging: widget.isManaging),
      Text('Round 2', style: headingStyle),
      SubGamesList(data: qRoundTwo, isManaging: widget.isManaging),
      Text('Round 3', style: headingStyle),
      SubGamesList(data: qRoundThree, isManaging: widget.isManaging),
      Text('Round 4', style: headingStyle),
      SubGamesList(data: qRoundFour, isManaging: widget.isManaging),
      Text('Quarter-finals', style: titleStyle),
      SubGamesList(data: quarterFinals, isManaging: widget.isManaging),
      Text('Semi-finals', style: titleStyle),
      SubGamesList(data: semiFinals, isManaging: widget.isManaging),
      Text('Closing Game', style: titleStyle),
      SubGamesList(data: closings, isManaging: widget.isManaging),
    ];
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (_, indx) => data[indx],
      separatorBuilder: (_, index) {
        return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
      },
      itemCount: data.length,
    );
  }
}
