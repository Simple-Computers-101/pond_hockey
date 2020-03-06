import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/tabbar.dart';
import 'package:pond_hockey/components/buttons/gradient_btn.dart';
import 'package:pond_hockey/enums/game_status.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/manage_contributers.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/game_item.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';
import 'package:pond_hockey/services/seeding/three_gg_algorithm.dart';
import 'package:uuid/uuid.dart';

class ManageTournament extends StatelessWidget {
  const ManageTournament({@required this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBarWithTabBar(
          title: 'Manage Tournament',
          tabs: [
            Tab(text: 'Games'),
            Tab(text: 'Teams'),
            Tab(text: 'Options'),
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            _ManageGamesView(tournamentId: tournament.id),
            _ManageTeamsView(tournament: tournament),
            _TournamentOptionsView(
              tournamentId: tournament.id,
            ),
          ],
        ),
      ),
    );
  }
}

class _ManageGamesView extends StatelessWidget {
  const _ManageGamesView({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    void seedGames(GameType type) async {
      await GamesRepository().deleteGamesFromTournament(tournamentId);
      var teams =
          await TeamsRepository().getTeamsFromTournamentId(tournamentId);
      if (teams.length < 4) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('You need at least four teams.'),
          duration: Duration(seconds: 2),
        ));
        return null;
      }
      var teamIds = teams.map((e) => e.id).toList();
      var bracket = ThreeGGAlgorithm.start(teamIds);
      bracket.removeWhere((element) => element.contains('0'));
      var games = bracket.map((e) async {
        var teamOne = await TeamsRepository().getTeamFromId(e[0]);
        var teamTwo = await TeamsRepository().getTeamFromId(e[1]);

        return Game(
          id: Uuid().v4(),
          status: GameStatus.notStarted,
          teamOne: GameTeam(
            id: teamOne.id,
            name: teamOne.name,
            differential: 0,
            score: 0,
          ),
          teamTwo: GameTeam(
            id: teamTwo.id,
            name: teamTwo.name,
            differential: 0,
            score: 0,
          ),
          tournament: tournamentId,
          type: type,
        );
      });
      var matches = await Future.wait(games);
      for (final match in matches) {
        await GamesRepository().addGameToTournament(match);
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

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200])),
        color: Color(0xFFE9E9E9),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Re-seed games',
              onPressed: _showChooseGameTypeDialog,
            ),
          ),
          Expanded(
            child: FirestoreAnimatedList(
              query: GamesRepository().getGamesFromTournamentId(tournamentId),
              padding: EdgeInsets.zero,
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

class ChooseGameTypeDialog extends StatefulWidget {
  const ChooseGameTypeDialog({this.onSubmit});

  final ValueChanged<GameType> onSubmit;

  @override
  _ChooseGameTypeDialogState createState() => _ChooseGameTypeDialogState();
}

class _ChooseGameTypeDialogState extends State<ChooseGameTypeDialog> {
  GameType chosen = GameType.qualifier;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: DropdownButton<GameType>(
        isExpanded: true,
        items: [
          DropdownMenuItem(
            child: Text('Qualifier'),
            value: GameType.qualifier,
          ),
          DropdownMenuItem(
            child: Text('Semi-finals'),
            value: GameType.semiFinal,
          ),
          DropdownMenuItem(
            child: Text('Closing'),
            value: GameType.closing,
          ),
        ],
        value: chosen,
        onChanged: (type) {
          setState(() {
            chosen = type;
          });
        },
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Router.navigator.pop();
            widget.onSubmit(chosen);
          },
          child: Text('Submit'),
        ),
        FlatButton(
          onPressed: Router.navigator.pop,
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

class _ManageTeamsView extends StatelessWidget {
  const _ManageTeamsView({@required this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Router.navigator.pushNamed(Router.addTeams, arguments: tournament);
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200])),
          color: Color(0xFFE9E9E9),
        ),
        child: FirestoreAnimatedList(
          primary: false,
          padding: const EdgeInsets.all(24),
          duration: Duration(milliseconds: 500),
          query: TeamsRepository().getTeamsStreamFromTournamentId(
            tournament.id,
          ),
          itemBuilder: (cntx, doc, anim, indx) {
            var team = Team.fromMap(doc.data);
            return FadeTransition(
              opacity: anim,
              child: ManageTeamItem(team: team),
            );
          },
          emptyChild: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You don\'t have any teams.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Add some with the button below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ManageTeamItem extends StatelessWidget {
  const ManageTeamItem({Key key, this.team}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        // needed because we need a border radius for the splash
        // otherwise it will go out of the container
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: ListTile(
            title: Text(team.name),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}

class _TournamentOptionsView extends StatelessWidget {
  _TournamentOptionsView({this.tournamentId});
  final String tournamentId;
  @override
  Widget build(BuildContext context) {
    Widget buildDivider() {
      return const Divider(
        height: 15,
        indent: 15,
        endIndent: 15,
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: ListView(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: <Widget>[
                _SettingsTile(
                  text: 'Contributers',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ManageContributors(
                          tournamentId: tournamentId,
                        ),
                      ),
                    );
                  },
                  icon: Icons.people,
                ),
                buildDivider(),
                _SettingsTile(
                  text: 'Another Setting',
                  onTap: () {},
                  icon: Icons.edit,
                ),
                buildDivider(),
                _SettingsTile(
                  text: 'Another Setting',
                  onTap: () {},
                  icon: Icons.edit,
                ),
                buildDivider(),
                _SettingsTile(
                  text: 'Another Setting',
                  onTap: () {},
                  icon: Icons.edit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    @required this.icon,
    @required this.text,
    @required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 25,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Icon(
          icon,
          color: Colors.blueAccent,
        ),
      ),
      title: Text(text),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right, color: Colors.black),
    );
  }
}
