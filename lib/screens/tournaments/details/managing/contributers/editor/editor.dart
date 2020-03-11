import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/router/router.gr.dart';

class ManageEditors extends StatefulWidget {
  ManageEditors({this.tournamentId});
  final String tournamentId;

  @override
  State<StatefulWidget> createState() {
    return _EditorState();
  }
}

class _EditorState extends State<ManageEditors> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection("tournaments")
          .document(widget.tournamentId)
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
      var tournament = Tournament.fromDocument(snapshot.data);
      if (tournament.editors == null) {
        return ListView(
          children: <Widget>[
            _newEditor(context),
            SizedBox(
              height: 50.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text("There are no editors."),
            ),
          ],
        );
      }
      return Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: tournament.editors.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                  radius: 30.0,
                ),
                title: Text(tournament.name),
                subtitle: Text(tournament.editors[index]['email']),
                trailing: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      color: Color(0xFF167F67),
                    ),
                  ),
                  onTap: () {
                    _deleteUserDialog(tournament, index);
                  },
                ),
              );
            },
          ),
          Divider(),
          _newEditor(context),
        ],
      );
    } else {
      return Center(
        child: Text("Uh oh! Something went wrong"),
      );
    }
  }

  void _deleteUserDialog(Tournament tournament, int index) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text("Are you sure to remove this user?"),
        actions: <Widget>[
          FlatButton(
            onPressed: Router.navigator.pop,
            child: Text("Cancel"),
          ),
          FlatButton(
            onPressed: () async {
              try {
                await Firestore.instance
                    .collection("tournament")
                    .document(widget.tournamentId)
                    .updateData({
                  'editors': FieldValue.arrayRemove(
                    [tournament.editors[index]],
                  )
                });

                ///here delete data
                Router.navigator.pop();
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
          ),
        ],
      ),
    );
  }

  Widget _newEditor(BuildContext context) {
    return ListTile(
      title: Text("New editor"),
      subtitle: Text("Tap here to add new editor"),
      leading: CircleAvatar(
        child: Icon(Icons.add),
        radius: 30.0,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return EditorDialog(
              tournamentId: widget.tournamentId,
            );
          },
        );
      },
    );
  }
}

class EditorDialog extends StatefulWidget {
  EditorDialog(
      {@required this.tournamentId});
  final String tournamentId;
  @override
  State<StatefulWidget> createState() {
    return _EditorDialogState();
  }
}

class _EditorDialogState extends State<EditorDialog> {
  var database = Firestore.instance;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var errorMessage = "";
  var isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add editor'),
      content: Wrap(
        children: <Widget>[
          isProcessing ? LinearProgressIndicator() : SizedBox.shrink(),
          Form(
            key: _formKey,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
              ),
              validator: validateEmail,
            ),
          ),
          Text(
            errorMessage,
            style: TextStyle(
              color: Colors.red,
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
                        .collection("tournament")
                        .document(widget.tournamentId)
                        .setData({"editors": ""});
                    ///here add new data

                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    errorMessage =
                        "User with this email address does not exist";
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

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
