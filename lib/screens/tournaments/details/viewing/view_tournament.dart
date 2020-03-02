import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
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

class _GamesPage extends StatelessWidget {
  const _GamesPage({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: FirestoreAnimatedList(
        query: GamesRepository().getGamesFromTournamentId(tournamentId),
        duration: Duration(milliseconds: 600),
        padding: const EdgeInsets.all(24),
        itemBuilder: (cntx, doc, anim, indx) {
          var game = Game.fromDocument(doc);
          return FadeTransition(
            opacity: anim,
            child: GameItem(gameId: game.id),
          );
        },
      ),
    );
  }
}

class _TeamsPage extends StatelessWidget {
  const _TeamsPage({@required this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Router.navigator.pushNamed(
            Router.addTeams,
            arguments: tournament,
          );
        },
        child: Icon(Icons.add),
      ),
      body: FirestoreAnimatedList(
        query: TeamsRepository().getTeamsStreamFromTournamentId(tournament.id),
        padding: const EdgeInsets.all(24),
        shrinkWrap: true,
        itemBuilder: (cntx, doc, anim, indx) {
          final team = Team.fromMap(doc.data);
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
      ),
    );
  }
}
