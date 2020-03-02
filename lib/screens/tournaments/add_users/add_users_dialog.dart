import 'package:flutter/material.dart';
import 'package:pond_hockey/screens/tournaments/add_users/user.dart';

class AddUserDialog {
  final teName = TextEditingController();
  final teEmail = TextEditingController();
  User user;

  static TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget buildAboutDialog(BuildContext context,
      AddUserCallback _myHomePageState, isEdit, User user) {
    if (user != null) {
      this.user = user;
      teEmail.text = user.email;
    }

    return AlertDialog(
      title: Text(isEdit ? 'Edit detail!' : 'Add new user!'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Name", teName),
            getTextField("Email", teEmail),
            GestureDetector(
              onTap: () => onTap(isEdit, _myHomePageState, context),
              child: Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(isEdit ? "Edit" : "Add",
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = Padding(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        controller: inputBoxController,
        decoration: InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
          color: Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  User getData(isEdit) {
    return User(isEdit ? user.id : "2GTuJtKvU3X9mBFJ5LGu4RuTRQt2", teEmail.text,
        teName.text);
  }

  onTap(isEdit, AddUserCallback _myHomePageState, BuildContext context) {
    if (isEdit) {
      _myHomePageState.update(getData(isEdit));
      Navigator.of(context).pop();
    } else {
      _myHomePageState.addUser(getData(isEdit));
      Navigator.of(context).pop();
    }
  }
}

abstract class AddUserCallback {
  void addUser(User user);

  void update(User user);
}
