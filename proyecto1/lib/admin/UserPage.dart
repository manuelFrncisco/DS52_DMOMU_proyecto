import 'package:flutter/material.dart';

class MyUserPage extends StatefulWidget {
  const MyUserPage({super.key, required this.title});
  final String title;

  @override
  State<MyUserPage> createState() => _MyUserPageState();
}

class _MyUserPageState extends State<MyUserPage> {
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