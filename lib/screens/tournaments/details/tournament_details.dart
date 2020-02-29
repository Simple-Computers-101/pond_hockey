import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/enums/viewing_mode.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/game_item.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_viewing.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';

class TournamentDetails extends StatefulWidget {
  const TournamentDetails({Key key, this.tournament}) : super(key: key);

  final Tournament tournament;

  @override
  _TournamentDetailsState createState() => _TournamentDetailsState();
}

class _TournamentDetailsState extends State<TournamentDetails> {
  @override
  Widget build(BuildContext context) {
    var mode = TournamentViewing.of(context).mode;
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
                  style: Theme.of(context).textTheme.headline5,
                ),
                actions: <Widget>[
                  if (mode != ViewingMode.viewing) ...[
                    if (mode == ViewingMode.scoring ||
                        mode == ViewingMode.editing)
                      IconButton(
                        icon: Icon(Icons.score),
                        onPressed: () {},
                      ),
                    if (mode == ViewingMode.editing)
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () => Router.navigator.pushNamed(
                          Router.tournamentSettings,
                          arguments: TournamentSettingsScreenArguments(
                            tournament: widget.tournament,
                          ),
                        ),
                      ),
                  ],
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Results'),
                    Tab(text: 'Teams'),
                  ],
                  isScrollable: false,
                  indicator: UnderlineTabIndicator(
                    insets: const EdgeInsets.symmetric(horizontal: 150),
                    borderSide: BorderSide(
                      width: 0.75,
                    ),
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
  _GamesPage({Key key, this.tournamentId}) : super(key: key);

  final String tournamentId;

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<_GamesPage> {
  List<Game> _games;

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
          return GameItem(game: game);
        },
      ),
    );
  }
}

class _TeamsPage extends StatelessWidget {
  const _TeamsPage({
    Key key,
    @required this.tournament,
  }) : super(key: key);

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
                    arguments: TeamDetailsScreenArguments(team: team),
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
