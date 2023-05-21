class User {
  final int id;
  final String username;
  final String password;
  final String? message;

  const User({
    required this.id,
    required this.username,
    required this.password,
    this.message,
  });

  @override
  String toString() {
    return "{id = $id, username = $username, password = $password, message = $message}";
  }
}
