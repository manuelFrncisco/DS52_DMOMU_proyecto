import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proyecto1/routes/api.dart';
import 'package:proyecto1/models/User.dart';

class MyPerfilPage extends StatefulWidget {
    final int id;
  const MyPerfilPage({Key? key, required this.title, required this.id})
      : super(key: key);

  final String title;

  @override
  State<MyPerfilPage> createState() => _MyPerfilPageState();
}

class _MyPerfilPageState extends State<MyPerfilPage> {
 late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(widget.id);
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
       body: Center(
          child: FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(children: [
                        Image.network(snapshot.data!.image,
                            width: 100, height: 100),
                        Text(snapshot.data!.name),
                        Text(snapshot.data!.surname),
                        Text(snapshot.data!.email),
                        Text(snapshot.data!.phone)
                      ]),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
