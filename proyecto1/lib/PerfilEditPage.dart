import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto1/LoginPage.dart';

class EditUserPage extends StatefulWidget {
  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  Map<String, dynamic>? userData;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _imageController;
  late String _updateMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    final String url = 'https://amavizca.terrabyteco.com/api/profile';
    final Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final http.Response response =
          await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          userData = responseData['profile'];
          _nameController = TextEditingController(text: userData!['name']);
          _surnameController =
              TextEditingController(text: userData!['surname'] ?? '');
          _emailController = TextEditingController(text: userData!['email']);
          _phoneController =
              TextEditingController(text: userData!['phone'] ?? '');
          _imageController =
              TextEditingController(text: userData!['image'] ?? '');
        });
      } else {
        print('Error al cargar los datos del usuario: ${response.body}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    const String apiUrl = 'https://amavizca.terrabyteco.com/api/profile/update';
    final String? token = await getToken();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      _updateMessage = 'Usuario actualizado correctamente';
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyHomePage(title: 'WelcomeNest', message: _updateMessage),
        ),
      );
    } else {
      throw Exception('Failed to update user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: userData != null
          ? Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      hintText: userData!['name'],
                    ),
                  ),
                  TextField(
                    controller: _surnameController,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      hintText: userData!['surname'] ?? '',
                    ),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      hintText: userData!['phone'] ?? '',
                    ),
                  ),
                  TextField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: 'Imagen',
                      hintText: userData!['image'] ?? '',
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: userData!['email'],
                    ),
                  ),
                   Container(
                    padding: EdgeInsets.only(top: 20),
                    child: 
                  ElevatedButton(
                    onPressed: () async {
                      await updateUser({
                        'name': _nameController.text,
                        'surname': _surnameController.text,
                        'email': _emailController.text,
                        'phone': _phoneController.text,
                        'image': _imageController.text,
                      });
                    },
                    child: Text('Guardar'),
                  ),
                  )
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
