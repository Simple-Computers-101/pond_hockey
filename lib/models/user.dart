class User {
  int coins;
  String email;
  String uid;
  
  User({
    this.coins,
    this.email,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'coins': coins,
      'email': email,
      'uid': uid,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      coins: map['coins'],
      email: map['email'],
      uid: map['uid'],
    );
  }
}
