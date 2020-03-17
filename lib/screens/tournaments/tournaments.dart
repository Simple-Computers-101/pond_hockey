import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/enums/viewing_mode.dart';
import 'package:pond_hockey/models/user.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_viewing.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournaments_list.dart';
import 'package:pond_hockey/services/databases/tournaments_repository.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';

class TournamentsScreen extends StatelessWidget {
  final repo = TournamentsRepository();

  @override
  Widget build(BuildContext context) {
    var mode = TournamentViewing.of(context).mode;

    bool canEditOrScore() {
      return mode == ViewingMode.editing || mode == ViewingMode.scoring;
    }

    bool canEdit() {
      return mode == ViewingMode.editing;
    }

    bool isScoring() {
      return mode == ViewingMode.scoring;
    }

    Widget buildLoading() {
      return Center(child: CircularProgressIndicator());
    }

    Widget buildError(Object error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Uh oh!',
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(error.toString()),
        ],
      );
    }

    Widget buildAllTournaments() {
      return StreamBuilder<QuerySnapshot>(
        stream: repo.ref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return buildLoading();
          } else if (snapshot.hasError) {
            return buildError(snapshot.error);
          }
          return Visibility(
            visible: snapshot.data.documents.isNotEmpty,
            child: TournamentsList(
              documents: snapshot.data.documents,
            ),
            replacement: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'There are no tournaments!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Check back later.',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          );
        },
      );
    }

    void _showInsufficientCreditsDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Insufficient credits'),
            content: Text(
              'You need more credits in order to create a tournament.',
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: Router.navigator.pop,
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<User>(
      future: UserRepository().getCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !canEditOrScore()) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Tournaments'),
            body: SingleChildScrollView(child: buildAllTournaments()),
          );
        }
        final user = snapshot.data;
        return Scaffold(
          appBar: CustomAppBar(
            title: canEdit()
                ? 'Manage Tournaments'
                : isScoring() ? 'Score Tournaments' : 'Error',
          ),
          floatingActionButton: canEdit()
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    if (user.credits == 0) {
                      _showInsufficientCreditsDialog();
                    } else {
                      Router.navigator.pushNamed(Router.addTournament);
                    }
                  },
                )
              : null,
          body: ManageableTournamentsList(user: user, editor: canEdit()),
        );
      },
    );
  }
}

class ManageableTournamentsList extends StatelessWidget {
  const ManageableTournamentsList({
    @required this.user,
    this.editor = false,
  });

  final User user;
  final bool editor;

  @override
  Widget build(BuildContext context) {
    final repo = TournamentsRepository();
    return FutureBuilder(
      future: editor
          ? repo.getEditableTournaments(user.uid)
          : repo.getScorerTournaments(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.isNotEmpty) {
            return ListView(
              children: <Widget>[
                Text('Credits: ${user.credits}'),
                TournamentsList(documents: snapshot.data),
              ],
            );
          } else {
            return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Credits: ${user.credits}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    'You don\'t have any tournaments!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Create some or be invited.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            );
          }
        }
        return SizedBox();
      },
    );
  }
}
