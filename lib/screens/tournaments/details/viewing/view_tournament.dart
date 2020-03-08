import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/game_item.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_division_dialog.dart';
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
  Division division;
  bool empty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Column(
        children: <Widget>[
          if (!empty)
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                showDialog(
                  context: context,
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
              },
            ),
          Expanded(
            child: StreamBuilder(
              stream: GamesRepository().getGamesFromTournamentId(
                widget.tournament.id,
                division: division,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.isNotEmpty) {
                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    padding: const EdgeInsets.all(24),
                    itemBuilder: (cntx, indx) {
                      var game = Game.fromDocument(snapshot.data[indx]);
                      return GameItem(gameId: game.id);
                    },
                    separatorBuilder: (cntx, _) => Spacer(),
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
                division,
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
