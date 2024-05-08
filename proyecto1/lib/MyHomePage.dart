import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto1/LoginPage.dart';
import 'package:proyecto1/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveCredentials(
      String email, String password, int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setInt('userId', userId);

    final String? savedEmail = prefs.getString('email');
    final String? savedPassword = prefs.getString('password');
    final int? savedUserId = prefs.getInt('userId');

    if (savedEmail != null && savedPassword != null && savedUserId != null) {
      print(
          'Credenciales guardadas correctamente: Email: $savedEmail, Password: $savedPassword, UserId: $savedUserId');
    } else {
      print('No se pudieron guardar las credenciales');
    }
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final String url = 'https://amavizca.terrabyteco.com/api/login';
    final Map<String, dynamic> body = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? token = responseData['token'];
        final int? userId = responseData['profile']['id'];
        if (token != null && userId != null) {
          await saveToken(token);
          await saveCredentials(
              emailController.text, passwordController.text, userId);

          // Establecer MyHomePage como la página raíz
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'WelcomeNest'),
          ));
        } else {
          setState(() {
            errorMessage = 'No se pudo obtener el token de la respuesta';
          });
        }
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          errorMessage = responseData['message'];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de conexión: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Inicio de sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(bottom:20, top: 20),
              child: ElevatedButton(
                onPressed: isLoading ? null : _login,
                child: Text('Iniciar sesión'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                );
              },
              child: Text('Register'),
            ),
            
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
