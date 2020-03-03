import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/screens/tournaments/add_users/add_user_database_util.dart';
import 'package:pond_hockey/screens/tournaments/add_users/add_users_dialog.dart';
import 'package:pond_hockey/screens/tournaments/add_users/user.dart';

class UserDashboard extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UserDashboard> implements AddUserCallback {
  final _anchorToBottom = false;
  FirebaseDatabaseUtil databaseUtil = FirebaseDatabaseUtil();

  @override
  Widget build(BuildContext context) {
    Widget _buildTitle(BuildContext context) {
      return InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Mainteners',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> _buildActions() {
      return <Widget>[
        IconButton(
          icon: const Icon(
            Icons.group_add,
          ),
          onPressed: () => showEditWidget(null, false),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        actions: _buildActions(),
      ),
      body: FirestoreAnimatedList(
        key: ValueKey<bool>(_anchorToBottom),
        query: databaseUtil.getUser(),
        reverse: _anchorToBottom,
        itemBuilder: (context, snapshot, animation, index) {
          return SizeTransition(
            sizeFactor: animation,
            child: showUser(snapshot),
          );
        },
      ),
    );
  }

  @override
  void addUser(User user) {
    setState(() {
      databaseUtil.addUser(user);
    });
  }

  @override
  void update(User user) {
    setState(() {
      databaseUtil.updateUser(user);
    });
  }

  Widget showUser(DocumentSnapshot res) {
    var user = User.fromSnapshot(res);

    var item = Card(
      child: Container(
        child: Center(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                child: Text(getShortName(user)),
                backgroundColor: const Color(0xFF20283e),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.lightBlueAccent),
                      ),
                      Text(
                        user.email ?? 'No email',
                        // set some style to text
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.lightBlueAccent),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF167F67),
                    ),
                    onPressed: () => showEditWidget(user, true),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever, color: Color(0xFF167F67)),
                    onPressed: () => deleteUser(user),
                  ),
                ],
              ),
            ],
          ),
        ),
        padding: const EdgeInsets.only(left: 10),
      ),
    );

    return item;
  }

  String getShortName(User user) {
    var shortName = "";
    if (user.email == null) return shortName;
    if (!user.email.isEmpty) {
      shortName = user.email.substring(0, 1);
    }
    return shortName;
  }

  showEditWidget(User user, isEdit) {
    showDialog(
      context: context,
      builder: (context) =>
          AddUserDialog().buildAboutDialog(context, this, isEdit, user),
    );
  }

  deleteUser(User user) {
    setState(() {
      databaseUtil.deleteUser(user);
    });
  }
}
