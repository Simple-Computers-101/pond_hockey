import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/game_item.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';

class ViewTournament extends StatefulWidget {
  const ViewTournament({@required this.tournament});

  final Tournament tournament;

  @override
  _ViewTournamentState createState() => _ViewTournamentState();
}

class _ViewTournamentState extends State<ViewTournament> {
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
                  widget.tournament.name,
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
          body: Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
            //   color: Color(0xFFE9E9E9),
            // ),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                _GamesPage(tournamentId: widget.tournament.id),
                _TeamsPage(tournament: widget.tournament),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GamesPage extends StatefulWidget {
  _GamesPage({this.tournamentId});

  final String tournamentId;

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<_GamesPage> {
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _getGames();
  }

  void _getGames() async {
    var games =
        await GamesRepository().getGamesFromTournamentId(widget.tournamentId);
    setState(() {
      _games = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_games == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return GameItem(gameId: game.id);
        },
      ),
    );
  }
}

class _TeamsPage extends StatelessWidget {
  const _TeamsPage({
    @required this.tournament,
  });

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Router.navigator.pushNamed(
            Router.addTeams,
            arguments: tournament,
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: TeamsRepository().getTeamsStreamFromTournament(tournament.id),
        builder: (context, stream) {
          if ((stream.connectionState == ConnectionState.active ||
                  stream.connectionState == ConnectionState.done) &&
              stream.hasData) {
            var data = (stream.data as QuerySnapshot).documents;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final team = Team.fromMap(data[index].data);
                return ListTile(
                  title: Text(team.name),
                  onTap: () => Router.navigator.pushNamed(
                    Router.teamDetails,
                    arguments: team,
                  ),
                );
              },
            );
          } else if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return SizedBox();
        },
      ),
    );
  }
}
