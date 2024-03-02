import 'package:flutter/material.dart';
import 'package:proyecto1/LoginPage.dart';
import 'routes/api.dart';
import 'models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final String url = 'http://127.0.0.1:8000/api/login';
    final Map<String, dynamic> body = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      final http.Response response =
          await http.post(Uri.parse(url), body: body);
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => MyHomePage(
                      title: 'hola',
                    ))));
      } else {
        setState(() {
          errorMessage = responseData['message'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de conexión';
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: Text('Iniciar sesión'),
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
