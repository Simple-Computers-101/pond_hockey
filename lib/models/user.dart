class User {
  int credits;
  String email;
  String uid;
  
  User({
    this.credits,
    this.email,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'credits': credits,
      'email': email,
      'uid': uid,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      credits: map['credits'],
      email: map['email'],
      uid: map['uid'],
    );
  }
}
