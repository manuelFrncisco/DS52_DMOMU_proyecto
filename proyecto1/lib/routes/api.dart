import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto1/models/Lodging.dart';
import 'package:proyecto1/models/User.dart';
import 'package:proyecto1/models/Comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Lodging>> fetchLodgings() async {
  final response = await http
      .get(Uri.parse('https://amavizca.terrabyteco.com/api/lodgings'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    List<Lodging> lodgings =
        jsonList.map((lodgingJson) => Lodging.fromJson(lodgingJson)).toList();
    return lodgings;
  } else {
    throw Exception('Failed to load lodgings');
  }
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<List<Comment>> fetchCommentsByLodging(int id) async {
  final String? token = await getToken();

  if (token == null) {
    throw Exception('No se pudo obtener el token de autorización');
  }

  final response = await http.get(
    Uri.parse('https://amavizca.terrabyteco.com/api/lodgings/$id/comments'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData
        .map((commentJson) => Comment.fromJson(commentJson))
        .toList();
  } else {
    throw Exception('Failed to load comments');
  }
}



Future<Lodging> fetchLodging(int id) async {
  final response = await http
      .get(Uri.parse('https://amavizca.terrabyteco.com/api/lodgings/$id'));
  if (response.statusCode == 200) {
    return Lodging.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load lodging');
  }
}

Future<User> fetchUserData() async {
  try {
    final response = await http
        .get(Uri.parse('https://amavizca.terrabyteco.com/api/profile'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load user data: $e');
  }
}
