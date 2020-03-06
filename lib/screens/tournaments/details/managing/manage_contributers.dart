import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/bloc/add_contributers_form/add_contributers_form.dart';
import 'package:pond_hockey/components/appbar/tabbar.dart';
import 'package:pond_hockey/models/tournament.dart';

class ManageContributors extends StatelessWidget {
  const ManageContributors({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddContributorsFormBloc(),
      child: Builder(
        builder: (context) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: CustomAppBarWithTabBar(
                title: 'Manage Contributors',
                transparentBackground: true,
                tabs: <Widget>[
                  Tab(text: 'Editors'),
                  Tab(text: 'Scorers'),
                ],
              ),
              extendBodyBehindAppBar: true,
              body: TabBarView(
                children: <Widget>[
                  _ManageEditors(tournamentId: tournamentId),
                  _ManageScorers(tournamentId: tournamentId),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ManageEditors extends StatelessWidget {
  const _ManageEditors({this.tournamentId});

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
            break;
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              var _tournament = Tournament.fromDocument(snapshot.data);
              return ListView.builder(
                itemCount: _tournament.editors.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      //  showUser(_tournament.editors[index],_tournament.name),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                          radius: 30.0,
                        ),
                        title: Text(_tournament.name),
                        subtitle: Text(_tournament.editors[index]),
                        trailing: Icon(
                          Icons.delete,
                          color: Color(0xFF167F67),
                        ),
                      ),
                      Divider(),
                      _newEditor()
                    ],
                  );
                },
              );
            } else {
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text("Uh oh! You didn't add any Editors"),
                  ),
                  _newEditor()
                ],
              );
            }
            break;
        }
        return Center(
          child: Text("Uh oh! Something went wrong"),
        );
      },
    );
  }

  Widget _newEditor() {
    return ListTile(
      title: Text("New editor"),
      subtitle: Text("Tap here to add new editor"),
      leading: CircleAvatar(
        child: Icon(Icons.add),
        radius: 30.0,
      ),
      onTap: () {},
    );
  }
}

class _ManageScorers extends StatelessWidget {
  const _ManageScorers({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: null,
      itemBuilder: null,
    );
  }
}

//Widget showUser(String email, String name) {
//  var item = Card(
//    child: Container(
//      child: Center(
//        child: Row(
//          children: <Widget>[
//            CircleAvatar(radius: 30.0, child: Icon(Icons.person)),
//            Expanded(
//              child: Padding(
//                padding: EdgeInsets.all(10.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      name,
//                      style: TextStyle(
//                        fontSize: 18.0,
//                      ),
//                    ),
//                    Text(
//                      email ?? 'No email',
//                      // set some style to text
//                      style: TextStyle(fontSize: 14.0),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                IconButton(
//                  icon: const Icon(
//                    Icons.edit,
//                    color: Color(0xFF167F67),
//                  ),
//                  onPressed: () {},
//                ),
//                IconButton(
//                  icon: Icon(Icons.delete_forever, color: Color(0xFF167F67)),
//                  onPressed: () {},
//                ),
//              ],
//            ),
//          ],
//        ),
//      ),
//      padding: const EdgeInsets.only(left: 10),
//    ),
//  );
//
//  return item;
//}
