import 'package:firebase_database/firebase_database.dart';

class User {

  final String name;
  final String surname;

  const User({
    required this.name,
    required this.surname,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
      name: map['name'],
      surname: map['phoneNumber'],
    );
  }
}