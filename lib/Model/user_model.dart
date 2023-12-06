const String userTable = 'users';

class UserFields {
  static final List<String> values = [
    email, name, password, role
  ];

  static const String email = 'email';
  static const String name = 'name';
  static const String password = 'password';
  static const String role = 'role';
}

class User {
  final String email;
  final String name;
  final String password;
  final String? role;

  const User({
    required this.email,
    required this.name,
    required this.password,
    this.role,
});

  static User fromJson(Map<String, Object?> json) => User(
    email: json[UserFields.email] as String,
    name: json[UserFields.name] as String,
    password: json[UserFields.password] as String,
    role: json[UserFields.role] as String?
  );

  Map<String, Object?> toJson() => {
    UserFields.email: email,
    UserFields.name: name,
    UserFields.password: password,
    UserFields.role: role
  };

}