import 'package:flutter/material.dart';
import 'package:proyecto1/admin/CommentPage.dart';
import 'package:proyecto1/admin/LocationPage.dart';
import 'package:proyecto1/admin/OfertPage.dart';
import 'package:proyecto1/admin/RatingPage.dart';
import 'package:proyecto1/admin/ReservationPage.dart';
import 'package:proyecto1/admin/UserPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 50,
            color: const Color.fromRGBO(230, 12, 74, 1),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MyLocationPage(
                              title: 'Locations',
                            ))));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Locations')],
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MyCommentPage(
                              title: 'Comments',
                            ))));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Comment')],
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.blue[50],
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MyHomePage(
                              title: 'Lodgings',
                            ))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text('Lodgings')],
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.blue[50],
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MyRatingPage(
                              title: 'Ratings',
                            ))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text('Ratings')],
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.blue[50],
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MyOffertPage(
                              title: 'Offerts',
                            ))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text('Offerts')],
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.blue[50],
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MyUserPage(
                              title: 'Users',
                            ))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text('Users')],
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.blue[50],
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MyReservationPage(
                              title: 'Reservations',
                            ))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text('Reservations')],
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}