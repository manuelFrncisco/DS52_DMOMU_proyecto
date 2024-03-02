import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proyecto1/routes/api.dart';
import 'package:proyecto1/models/Lodging.dart';

class MyLodgingPageId extends StatefulWidget {
  final int id;

  const MyLodgingPageId({Key? key, required this.title, required this.id})
      : super(key: key);

  final String title;

  @override
  State<MyLodgingPageId> createState() => _MyLodgingPageIdState();
}

class _MyLodgingPageIdState extends State<MyLodgingPageId> {
  late Future<Lodging> futureLodging;

  @override
  void initState() {
    super.initState();
    futureLodging = fetchLodging(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: FutureBuilder<Lodging>(
            future: futureLodging,
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
                        Text(snapshot.data!.description),
                        Text(snapshot.data!.backroom.toString()),
                        Text(snapshot.data!.start_range),
                        Text(snapshot.data!.start_range)
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
