import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pond_hockey/models/tournament.dart';

class ManageScorers extends StatelessWidget {
  ManageScorers({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection("tournaments")
          .document(tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("Uh oh! Something went wrong"),
            );
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            return buildView(snapshot, context);
          case ConnectionState.done:
            return buildView(snapshot, context);
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('??'),
            Text('How\'d you get here?!'),
          ],
        );
      },
    );
  }

  Widget buildView(AsyncSnapshot snapshot, BuildContext context) {
    if (snapshot.hasData) {
      var _tournament = Tournament.fromDocument(snapshot.data);
      if (_tournament.scorers == null) {
        return ListView(
          children: <Widget>[
            _newScorer(context),
            SizedBox(
              height: 50.0,
            ),
            Center(child: Text("There are no scorers.")),
          ],
        );
      }
      return Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: _tournament.scorers.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                  radius: 30.0,
                ),
                title: Text(_tournament.scorers[index]['email']),
                trailing: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      color: Color(0xFF167F67),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Text("Are you sure to remove this user"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    try {
                                      await Firestore.instance
                                          .collection("tournaments")
                                          .document(tournamentId)
                                          .updateData({
                                        'scorers': FieldValue.arrayRemove(
                                          [_tournament.scorers[index]],
                                        )
                                      });

                                      ///here delete data
                                      Navigator.of(context).pop();
                                      // ignore: avoid_catches_without_on_clauses
                                    } catch (error) {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error.code),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("Yes"),
                                )
                              ],
                            ));
                  },
                ),
              );
            },
          ),
          Divider(),
          _newScorer(context)
        ],
      );
    } else {
      return Center(
        child: Text("Uh oh! Something went wrong"),
      );
    }
  }

  Widget _newScorer(BuildContext context) {
    return ListTile(
      title: Text("New scorer"),
      subtitle: Text("Tap here to add new scorer"),
      leading: CircleAvatar(
        child: Icon(Icons.add),
        radius: 30.0,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return ScorerDialog(
                tournamentId: tournamentId,
              );
            });
      },
    );
  }
}

class ScorerDialog extends StatefulWidget {
  ScorerDialog({
    @required this.tournamentId,
  });
  final String tournamentId;
  @override
  State<StatefulWidget> createState() {
    return _ScorerDialogState();
  }
}

class _ScorerDialogState extends State<ScorerDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var database = Firestore.instance;

  var errorMessage;
  var isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Scorer'),
      scrollable: true,
      content: Column(
        children: <Widget>[
          isProcessing ? LinearProgressIndicator() : SizedBox.shrink(),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                errorText: errorMessage,
                focusedBorder: UnderlineInputBorder(),
              ),
              validator: FormBuilderValidators.email(
                errorText: 'Invalid email',
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              setState(() {
                isProcessing = true;
              });
              try {
                // TODO: use query
                final documents =
                    await database.collection("users").getDocuments();
                var uid;
                for (var element in documents.documents) {
                  if (element.data["email"] == _emailController.text) {
                    uid = element["uid"];
                  }
                }
                if (uid != null) {
                  await database
                      .collection("tournaments")
                      .document(widget.tournamentId)
                      .setData({
                    "scorers": FieldValue.arrayUnion(
                      [
                        {"email": _emailController.text, "uid": uid}
                      ],
                    ),
                  }, merge: true);

                  ///here new data
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    errorMessage =
                        "No account with that email";
                    isProcessing = false;
                  });
                }
              }
              // ignore: avoid_catches_without_on_clauses
              catch (error) {
                setState(() {
                  errorMessage = error.code;
                  isProcessing = false;
                });
              }
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
