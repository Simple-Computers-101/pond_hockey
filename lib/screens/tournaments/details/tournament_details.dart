import 'package:flutter/material.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFF0094FF),
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
                  IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () => Router.navigator.pushNamed(
                      Router.addTeams,
                      arguments: widget.tournament,
                    ),
                  ),
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Divisions'),
                    Tab(text: 'Teams'),
                  ],
                  isScrollable: false,
                  indicator: UnderlineTabIndicator(
                    insets: const EdgeInsets.symmetric(horizontal: 150),
                    borderSide: BorderSide(
                      width: 2,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              color: Color(0xFFE9E9E9),
            ),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  color: Colors.green,
                ),
                _TeamsPage(tournamentId: widget.tournament.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamsPage extends StatefulWidget {
  const _TeamsPage({
    Key key,
    @required this.tournamentId,
  }) : super(key: key);

  final String tournamentId;

  @override
  __TeamsPageState createState() => __TeamsPageState();
}

class __TeamsPageState extends State<_TeamsPage> {
  List<Team> _teams;

  @override
  void initState() {
    super.initState();
    _getTeams();
  }

  void _getTeams() async {
    var teams =
        await TeamsRepository().getTeamsFromTournamentId(widget.tournamentId);
    setState(() {
      _teams = teams ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_teams == null) {
      return CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        final team = _teams[index];
        return ListTile(
          title: Text(team.name),
          onTap: () => Router.navigator.pushNamed(
            Router.teamDetails,
            arguments: TeamDetailsScreenArguments(team: team),
          ),
        );
      },
    );
  }
}
