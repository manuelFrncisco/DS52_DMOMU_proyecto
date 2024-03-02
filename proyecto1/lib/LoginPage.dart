import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proyecto1/routes/api.dart';
import 'package:proyecto1/models/Lodging.dart';
import 'package:proyecto1/LodgingPageid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Lodging>> futureLodging;

  @override
  void initState() {
    super.initState();
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
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Perfil'),
             
             
            ),
            ListTile(
              title: const Text('Editar Perfil'),
      
              
           
            ),
            
          ],
        ),
      ),


      body: FutureBuilder<List<Lodging>>(
        future: futureLodging,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Lodging> lodgings = snapshot.data!;

            return ListView.builder(
              itemCount: lodgings.length,
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
                                    id: lodgings[index].id,
                                    title: '',
                                  ))));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(lodgings[index].image,
                            width: 100, height: 100),
                        Text(lodgings[index].name),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AutofillHints.countryName',
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                            text: (lodgings[index].description),
                          ),
                        ),
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
    );
  }
}





