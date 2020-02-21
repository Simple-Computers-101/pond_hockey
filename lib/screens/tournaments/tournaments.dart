import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/components/loading/loading.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournaments_list.dart';
import 'package:pond_hockey/services/databases/tournaments_repository.dart';
import 'package:provider/provider.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen(
      {Key key, this.scoringMode = false, this.editMode = false})
      : super(key: key);

  final bool scoringMode;
  final bool editMode;

  @override
  _TournamentsScreenState createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  bool canEditOrScore() {
    return widget.scoringMode == true || widget.editMode == true;
  }

  bool canEdit() {
    return widget.editMode == true;
  }

  bool canScore() {
    return widget.scoringMode == true || widget.editMode == true;
  }

  String uid;

  @override
  void initState() {
    super.initState();
    _getUID();
  }

  void _getUID() async {
    uid = (await FirebaseAuth.instance.currentUser()).uid;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<TournamentsRepository>(context);

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
          return TournamentsList(
            documents: snapshot.data.documents,
          );
        },
      );
    }

    Widget buildScorerOrEditorView() {
      if (canEdit()) {
        return TournamentEditorView(uid);
      } else if (canScore()) {
        return TournamentScorerView(uid);
      }
      return SizedBox();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: canEditOrScore() ? 'Your Tournaments' : 'Tournaments',
      ),
      floatingActionButton: canEdit()
          ? FloatingActionButton(
              onPressed: () {
                Router.navigator.pushNamed(Router.addTournament);
              },
              child: Icon(Icons.add),
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE9E9E9),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        child: !canEditOrScore()
            ? buildAllTournaments()
            : buildScorerOrEditorView(),
      ),
    );
  }
}

class TournamentEditorView extends StatelessWidget {
  const TournamentEditorView(this.uid);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: <Widget>[
                Text('Coins'),
                Text('0'),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: FutureBuilder(
            future: Provider.of<TournamentsRepository>(context)
                .getOwnedTournaments(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TournamentsList(
                  documents: snapshot.data,
                );
              } else {
                return LoadingScreen();
              }
            },
          ),
        ),
      ],
    );
  }
}

class TournamentScorerView extends StatelessWidget {
  const TournamentScorerView(this.uid);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          child: FutureBuilder(
            future: Provider.of<TournamentsRepository>(context)
                .getScorerTournaments(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TournamentsList(
                  documents: snapshot.data,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
