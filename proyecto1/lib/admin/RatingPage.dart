import 'package:flutter/material.dart';

class MyRatingPage extends StatefulWidget {
  const MyRatingPage({super.key, required this.title});
  final String title;

  @override
  State<MyRatingPage> createState() => _MyRatingPageState();
}

class _MyRatingPageState extends State<MyRatingPage> {
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