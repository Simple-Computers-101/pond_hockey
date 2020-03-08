import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/tabbar.dart';
import 'package:pond_hockey/enums/game_type.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/manage_contributers.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';
import 'package:pond_hockey/screens/tournaments/widgets/manage_games_view.dart';
import 'package:pond_hockey/services/databases/tournaments_repository.dart';

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
            ManageGamesView(tournamentId: tournament.id),
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
    Widget buildDeleteTournamentButton() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete Tournament'),
                      content: Text(
                        'Are you SURE that you want to delete this tournament?',
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Router.navigator.pop();
                            Router.navigator.pop();
                            TournamentsRepository()
                                .deleteTournament(tournamentId);
                          },
                          child: Text('YES'),
                        ),
                        FlatButton(
                          onPressed: Router.navigator.pop,
                          child: Text('NO'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'DELETE TOURNAMENT',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.red,
            ),
            Text(
              'Warning: This action CANNOT be undone!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _SettingsList(tournamentId: tournamentId),
            ),
            Expanded(child: const SizedBox()),
            buildDeleteTournamentButton(),
          ],
        ),
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList({
    Key key,
    @required this.tournamentId,
  }) : super(key: key);

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

    return Material(
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
