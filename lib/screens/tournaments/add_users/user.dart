import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _id;
  String _email;
  String _name;

  User(this._id, this._email, this._name);

  String get email => _email;
  String get id => _id;

  String get name => _name;

  User.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.documentID;
    _email = snapshot.data['email'];
    _name = snapshot.data['name'];
  }
}
