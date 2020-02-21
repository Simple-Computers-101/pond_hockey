import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
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
          return Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Visibility(
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
                ),
              ),
            ],
          );
        },
      );
    }

    Widget buildScorerOrEditorView() {
      if (canEdit()) {
        return ManageTournamentView(uid: uid, editor: true);
      } else if (canScore()) {
        return ManageTournamentView(uid: uid);
      }
      return SizedBox();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: canEdit()
            ? 'Manage Tournaments'
            : canScore() ? 'Score Tournaments' : 'Tournaments',
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

class ManageTournamentView extends StatelessWidget {
  const ManageTournamentView({
    @required this.uid,
    this.editor = false,
  });

  final String uid;
  final bool editor;

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<TournamentsRepository>(context);
    return Column(
      children: <Widget>[
        if (editor)
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
            future: editor
                ? repo.getOwnedTournaments(uid)
                : repo.getScorerTournaments(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return TournamentsList(
                    documents: snapshot.data,
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
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
                  );
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
