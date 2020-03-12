import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/enums/viewing_mode.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_viewing.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournaments_list.dart';
import 'package:pond_hockey/services/databases/tournaments_repository.dart';

class TournamentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repo = TournamentsRepository();
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

    Widget buildScorerOrEditorView(String uid) {
      if (canEdit()) {
        return ManageableTournamentsList(uid: uid, editor: true);
      } else if (isScoring()) {
        return ManageableTournamentsList(uid: uid);
      }
      return SizedBox();
    }

    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !canEditOrScore()) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Tournaments',
            ),
            body: SingleChildScrollView(
              child: buildAllTournaments(),
            ),
          );
        }
        final uid = (snapshot.data as FirebaseUser).uid;
        return Scaffold(
          appBar: CustomAppBar(
            title: canEdit()
                ? 'Manage Tournaments'
                : isScoring() ? 'Score Tournaments' : 'Error',
          ),
          floatingActionButton: canEdit()
              ? FloatingActionButton(
                  onPressed: () async {
                    Router.navigator.pushNamed(Router.addTournament);
//                    if (uid != "Vpdl33VmgzU6hyOhbrIKsHNvumt2" &&
//                        Platform.isAndroid) {
//                      showDialog(
//                          context: context,
//                          builder: (_) => AlertDialog(
//                                title: Text(
//                                    "Adding tournament feature will
//                                    come soon"),
//                                actions: <Widget>[
//                                  FlatButton(
//                                    child: Text("Ok"),
//                                    onPressed: () {
//                                      Navigator.of(context).pop();
//                                    },
//                                  )
//                                ],
//                              ));
//                    } else {
//                      Router.navigator.pushNamed(Router.addTournament);
//                    }
                  },
                  child: Icon(Icons.add),
                )
              : null,
          body: SingleChildScrollView(
            child: buildScorerOrEditorView(uid),
          ),
        );
      },
    );
  }
}

class ManageableTournamentsList extends StatelessWidget {
  const ManageableTournamentsList({
    @required this.uid,
    this.editor = false,
  });

  final String uid;
  final bool editor;

  @override
  Widget build(BuildContext context) {
    final repo = TournamentsRepository();
    return FutureBuilder(
      future: editor
          ? repo.getEditableTournaments(uid)
          : repo.getScorerTournaments(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.isNotEmpty) {
            return TournamentsList(
              documents: snapshot.data,
            );
          } else {
            return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
        return null;
      },
    );
  }
}
