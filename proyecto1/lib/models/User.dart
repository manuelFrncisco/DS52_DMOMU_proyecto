import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String phone;
  final String image;
  final String password;

  const User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.image,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('access_token')) {
      final profile = json['profile'];
      return User(
        id: profile['id'] as int,
        name: profile['name'] as String,
        surname: profile['surname'] as String,
        email: profile['email'] as String,
        phone: profile['phone'] as String,
        image: profile['image'] as String,
        password: '',
      );
    } else {
      throw FormatException('Token not found in response');
    }
  }
}
