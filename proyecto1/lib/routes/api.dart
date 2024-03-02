import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto1/models/Lodging.dart';
import 'package:proyecto1/models/User.dart';

Future<List<Lodging>> fetchLodgings() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/lodgings'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> jsonList = jsonDecode(response.body);
    List<Lodging> lodgings =
        jsonList.map((lodgingJson) => Lodging.fromJson(lodgingJson)).toList();
    return lodgings;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load lodgings');
  }
}

Future<Lodging> fetchLodging(int id) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/api/lodgings/$id'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Lodging.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load lodging');
  }

}

Future<User> fetchLogin(String name, String email, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/login'),
    body: {
      'email': email,
      'password': password,
    },
  );

  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    if (responseData.containsKey('token')) {
      return User.fromJson(responseData['perfil'] as Map<String, dynamic>);
    } else {
      throw Exception('Token not found in response');
    }
  } else {
    throw Exception('Failed to load user: ${response.statusCode}');
  }
}




