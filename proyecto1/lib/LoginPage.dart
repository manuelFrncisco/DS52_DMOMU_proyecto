import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proyecto1/PerfilPage.dart';
import 'package:proyecto1/routes/api.dart';
import 'package:proyecto1/models/Lodging.dart';
import 'package:proyecto1/LodgingPageid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto1/MyHomePage.dart';
import 'package:proyecto1/PerfilEditPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, this.message})
      : super(key: key);

  final String title;
  final String? message;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Lodging>> futureLodging;
  String _searchTerm = '';
  String? message;

  @override
  void initState() {
    super.initState();
    if (widget.message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.message!)),
        );
      });
    }
    futureLodging = fetchLodgings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 239, 173, 18),
              ),
              child: Text('WelcomeNest'),
            ),
            ListTile(
              title: const Text('Perfil'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => ProfilePage())));
              },
            ),
            ListTile(
              title: const Text('Editar Perfil'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => EditUserPage())));
              },
            ),
            ListTile(
              title: const Text('Cerrar Sesion'),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove('token');
                // Volver a la página de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(title: 'Iniciar sesión')),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Buscar alojamiento por nombre',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchTerm = value.toLowerCase();
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Lodging>>(
              future: futureLodging,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Lodging> lodgings = snapshot.data!;
                  List<Lodging> filteredLodgings = lodgings
                      .where((lodging) =>
                          lodging.name.toLowerCase().contains(_searchTerm))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredLodgings.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(25),
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(224, 243, 227, 192),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => MyLodgingPageId(
                                      id: filteredLodgings[index].id,
                                      title: '',
                                    )),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                  filteredLodgings[index].image.toString(),
                                  width: 500,
                                  height: 300),
                              Container(
                                padding: EdgeInsets.only(top: 15, left: 5),
                                child: Text(
                                  filteredLodgings[index].name.toString(),
                                  style: const TextStyle(fontSize: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
