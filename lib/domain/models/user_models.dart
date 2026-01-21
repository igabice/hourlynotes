
class User {
  final String displayName;
  final String photoUrl;
  final String email;

  User({
    this.displayName = '',
    this.photoUrl = '',
    this.email = '',
  });

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'photoUrl': photoUrl,
    'email': email,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      email: json['email'],
    );
  }
}
