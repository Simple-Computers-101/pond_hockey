import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/models/tournament.dart';

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
      var _tournament = Tournament.fromDocument(snapshot.data);
      if (_tournament.editors == null) {
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
            itemCount: _tournament.editors.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                  radius: 30.0,
                ),
                title: Text(_tournament.name),
                subtitle: Text(_tournament.editors[index]['email']),
                trailing: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      color: Color(0xFF167F67),
                    ),
                  ),
                  onTap: () {},
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return EditorDialog();
                      });
                },
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
              return null;
            });
      },
    );
  }


}

class EditorDialog extends StatefulWidget {
  EditorDialog({this.isEdit});
  final bool isEdit;
  @override
  State<StatefulWidget> createState() {
    return _EditorDialogState();
  }

}

class _EditorDialogState extends State<EditorDialog> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Edit detail!': 'Add editor'),
      content: Wrap(
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(hintText: "Email"),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Text("Edit"),
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