import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/tabbar.dart';
import 'package:pond_hockey/components/buttons/gradient_btn.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/services/databases/teams_repository.dart';

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
            _ManageGamesView(),
            _ManageTeamsView(tournamentId: tournament.id),
            _TournamentOptionsView(),
          ],
        ),
      ),
    );
  }
}

class _ManageGamesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ManageTeamsView extends StatelessWidget {
  const _ManageTeamsView({@required this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200]))),
        child: FirestoreAnimatedList(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          query: TeamsRepository().getTeamsStreamFromTournament(tournamentId),
          itemBuilder: (cntx, doc, anim, indx) {
            var team = Team.fromMap(doc.data);
            return FadeTransition(
              opacity: anim,
              child: ManageTeamItem(team: team),
            );
          },
          emptyChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You don\'t have any teams.'),
              Text('Add some with the button below.'),
              GradientButton(
                colors: [
                  Color.fromRGBO(18, 194, 233, 1),
                  Color.fromRGBO(196, 113, 237, 1),
                  Color.fromRGBO(246, 79, 89, 1),
                ],
                text: 'Create Team',
                height: MediaQuery.of(context).size.height * 0.05,
                onTap: () {},
              ),
            ],
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
        color: Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(16),
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
                  text: 'Editors',
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
