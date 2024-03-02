import 'package:flutter/material.dart';

class MyReservationPage extends StatefulWidget {
  const MyReservationPage({super.key, required this.title});
  final String title;

  @override
  State<MyReservationPage> createState() => _MyReservationPageState();
}

class _MyReservationPageState extends State<MyReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(children: []),
        ));
  }
}