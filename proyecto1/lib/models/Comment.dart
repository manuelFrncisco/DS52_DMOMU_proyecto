import 'package:proyecto1/models/User.dart';

class Comment {
  final int id;
  final String messaje;
  final User user;

  Comment({
    required this.id,
    required this.messaje,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      messaje: json['messaje'] ?? '',
      user: User.fromJson(json['user'])
    );
  }
}
