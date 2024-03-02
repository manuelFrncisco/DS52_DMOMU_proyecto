import 'package:flutter/material.dart';

class Lodging {
  final int id;
  final String name;
  final String description;
  final int backroom;
  final String image;
  final String start_range;
  final String end_range;
  final int page;
  

  const Lodging({
    required this.id,
    required this.name,
    required this.description,
    required this.backroom,
    required this.image,
    required this.start_range,
    required this.end_range,
    required this.page
  });

  factory Lodging.fromJson(Map<String, dynamic> json) {
  return Lodging(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    backroom: json['backroom'] as int? ?? 0,
    image: json['image'] as String? ?? '',
    start_range: json['start_range'] as String? ?? '',
    end_range: json['end_range'] as String? ?? '',
    page: json['page'] as int? ?? 0,
  );
}

}