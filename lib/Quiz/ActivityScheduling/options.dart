import 'package:flutter/material.dart';

class ActivityOptions extends StatefulWidget {
  @override
  State<ActivityOptions> createState() => _ActivityOptionsState();
}

class _ActivityOptionsState extends State<ActivityOptions> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Activity scheduling test'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  //code goes here
                },
                child: const Text('Choose from saved items')),
            ElevatedButton(
                onPressed: () {
                  //code goes here
                },
                child: const Text('Create a new question'))
          ],
        )));
  }
}
