import 'package:flutter/material.dart';

class MyCommentPage extends StatefulWidget {
  const MyCommentPage({super.key, required this.title});
  final String title;

  @override
  State<MyCommentPage> createState() => _MyCommentPageState();
}

class _MyCommentPageState extends State<MyCommentPage> {
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
