import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/game_item.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_division_dialog.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_gametype_dialog.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';

class ViewTournament extends StatelessWidget {
  const ViewTournament({this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                centerTitle: true,
                title: Text(
                  tournament.name,
                  // style: Theme.of(context).textTheme.headline5,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'CircularStd',
                    fontSize: 24,
                  ),
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Results'),
                    Tab(text: 'Teams'),
                  ],
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Color(0xFF1a73e8),
                  unselectedLabelColor: Color(0xFF5f6368),
                  indicator: MD2Indicator(
                    indicatorHeight: 3,
                    indicatorColor: Color(0xFF1a73e8),
                    indicatorSize: MD2IndicatorSize.normal,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              _GamesPage(tournament: tournament),
              _TeamsPage(tournament: tournament),
            ],
          ),
        ),
      ),
    );
  }
}

class _GamesPage extends StatefulWidget {
  const _GamesPage({this.tournament});

  final Tournament tournament;

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<_GamesPage> {
  Division _selectedDivision;
  GameType _selectedGameType;

  void _showFilterGameTypeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FilterGameTypeDialog(
          gameType: _selectedGameType,
          onGameTypeChanged: (value) {
            setState(() {
              _selectedGameType = value;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: _showFilterDivisionDialog,
                ),
                Text(
                  'Current Division: ${divisionMap[_selectedDivision] ?? 'All'}',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: _showFilterGameTypeDialog,
                ),
                Text(
                  'Current Type: ${gameType[_selectedGameType] ?? 'All'}',
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: GamesRepository().getGamesStreamFromTournamentId(
                  widget.tournament.id,
                  division: _selectedDivision,
                  pGameType: _selectedGameType,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var data = snapshot.data as QuerySnapshot;
                  if (data.documents.isNotEmpty) {
                    var docs = data.documents;
                    var games = docs.map(Game.fromDocument);
                    var qualifiers = games
                        .where((element) => element.type == GameType.qualifier)
                        .toList();
                    var semiFinals = games
                        .where((element) => element.type == GameType.semiFinal)
                        .toList();
                    var closings = games
                        .where((element) => element.type == GameType.closing)
                        .toList();
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Text(
                          'Qualifiers',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CircularStd',
                          ),
                        ),
                        ListView.separated(
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
                        Text(
                          'Semi-finals',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CircularStd',
                          ),
                        ),
                        ListView.separated(
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          'Closings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CircularStd',
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        ListView.separated(
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
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(':('),
                          Text('There\'s nothing here!'),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDivisionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDivisionDialog(
          division: _selectedDivision,
          onDivisionChanged: (value) {
            setState(() {
              _selectedDivision = value;
            });
          },
        );
      },
    );
  }
}

class _TeamsPage extends StatefulWidget {
  const _TeamsPage({@required this.tournament});

  final Tournament tournament;

  @override
  __TeamsPageState createState() => __TeamsPageState();
}

class __TeamsPageState extends State<_TeamsPage> {
  Division division;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 24),
            alignment: FractionalOffset.centerLeft,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => FilterDivisionDialog(
                        onDivisionChanged: (div) {
                          setState(() {
                            division = div;
                          });
                        },
                        division: division,
                      ),
                    );
                  },
                ),
                Text('Current Division: ${divisionMap[division] ?? 'All'}')
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: TeamsRepository().getTeamsStreamFromTournamentId(
                widget.tournament.id,
                division: division,
              ),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snap.data.documents.isNotEmpty) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemBuilder: (context, indx) {
                      final team = Team.fromMap(snap.data.documents[indx].data);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(team.name),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () => Router.navigator.pushNamed(
                            Router.teamDetails,
                            arguments: team,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, indx) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      );
                    },
                    itemCount: snap.data.documents.length,
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(':('),
                        Text('There\'s nothing here!'),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
