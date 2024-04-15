class CustomUser {
  final String id;
  final String username;
  final String email;
  final String? profilePictureUrl;

  CustomUser({
    required this.id,
    required this.username,
    required this.email,
    this.profilePictureUrl,
  });

  factory CustomUser.fromMap(Map<String, dynamic> data, String id) {
    return CustomUser(
      id: id,
      username: data['username'],
      email: data['email'],
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
