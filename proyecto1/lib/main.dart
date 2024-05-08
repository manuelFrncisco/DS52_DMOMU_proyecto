import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Obtener el token guardado en SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MaterialApp(
    title: 'Proyecto #3',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 253, 181, 0)),
      useMaterial3: true,
    ),
    home: token != null ? MyHomePage(title: 'WelcomeNest') : LoginPage(title: 'Login'),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Proyecto #3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 253, 181, 0)),
        useMaterial3: true,
      ),
       home:  const LoginPage(title: 'Login')
      
    );
  }
}
