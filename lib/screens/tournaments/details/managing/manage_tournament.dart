import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/tabbar.dart';
import 'package:pond_hockey/components/dialog/dialog_buttons.dart';
import 'package:pond_hockey/enums/division.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/add_a_game.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/manage_contributers.dart';
import 'package:pond_hockey/screens/tournaments/widgets/filter_division_dialog.dart';
import 'package:pond_hockey/screens/tournaments/widgets/games_list.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';
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
            GamesList(
              tournamentId: tournament.id,
              isManaging: true,
            ),
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

class _ManageTeamsView extends StatefulWidget {
  const _ManageTeamsView({@required this.tournament});

  final Tournament tournament;

  @override
  _ManageTeamsViewState createState() => _ManageTeamsViewState();
}

class _ManageTeamsViewState extends State<_ManageTeamsView> {
  Division division;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Router.navigator.pushNamed(
            Routes.addTeams,
            arguments: widget.tournament,
          );
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200])),
          color: Color(0xFFE9E9E9),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 24, top: 12),
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
                      itemCount: snap.data.documents.length,
                      itemBuilder: (context, index) {
                        var team = Team.fromMap(
                          snap.data.documents[index].data,
                        );
                        return _ManageTeamItem(team: team);
                      },
                      padding: const EdgeInsets.all(24),
                      separatorBuilder: (_, __) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        );
                      },
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'You don\'t have any teams in this division.',
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
                              color: Color(0xFF808080),
                            ),
                          ),
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
}

class _ManageTeamItem extends StatelessWidget {
  const _ManageTeamItem({Key key, this.team}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(24),
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
                        SecondaryDialogButton(
                          text: 'No',
                          onPressed: Router.navigator.pop,
                        ),
                        PrimaryDialogButton(
                          text: 'Yes',
                          onPressed: () {
                            Router.navigator.pop();
                            Router.navigator.pop();
                            TournamentsRepository()
                                .deleteTournament(tournamentId);
                          },
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _SettingsList(tournamentId: tournamentId),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: buildDeleteTournamentButton(),
            ),
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

    return Column(
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
          text: 'Add a game',
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AddAGameDialog(tournamentId: tournamentId);
              },
            );
          },
          icon: Icons.edit,
        ),
      ],
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
