import 'package:flutter/material.dart';

class MyOffertPage extends StatefulWidget {
  const MyOffertPage({super.key, required this.title});
  final String title;

  @override
  State<MyOffertPage> createState() => _MyOffertPageState();
}

class _MyOffertPageState extends State<MyOffertPage> {
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