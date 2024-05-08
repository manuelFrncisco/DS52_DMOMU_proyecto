import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto1/MyHomePage.dart';
import 'dart:convert';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController namelController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const SizedBox(height: 16),
        const Text(
          'Completa todo los campos.',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: namelController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: surnameController,
          decoration: const InputDecoration(
            labelText: 'Apellido',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Correo',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Telefono',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
          ),
        ),
        TextFormField(
          controller: imageController,
          decoration: const InputDecoration(
            labelText: 'Imagen',
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final String url = 'https://amavizca.terrabyteco.com/api/register';
            final Map<String, dynamic> body = {
              'name': namelController.text,
              'surname': surnameController.text,
              'email': emailController.text,
              'phone': phoneController.text,
              'password': passwordController.text,
              'image': imageController.text,
            };

            try {
              final http.Response response = await http.post(
                Uri.parse(url),
                headers: {"Content-type": "application/json"},
                body: json.encode(body),
              );
              if (response.statusCode == 200) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(title: 'Registro exitoso!'),
                  ),
                );
              } else {
                // Si la solicitud falló, puedes mostrar un mensaje de error
                print('Error: ${response.body}');
              }
            } catch (e) {
              print('Error: $e');
            }
          },
          child: const Text('Registrarse'),
        ),
      ],
    ));
  }

  
}
