import 'dart:io';

import 'package:flutter/material.dart';

class ActivityOptions extends StatefulWidget {
  @override
  State<ActivityOptions> createState() => _ActivityOptionsState();
}

class _ActivityOptionsState extends State<ActivityOptions> {
  final Directory directory =
      Directory('D:/Sadi/spl3/assets/ActivitySnapShots');
  List<Directory> directories = [];
  @override
  initState() async {
    super.initState();
  }

  listDirectories() async {
    await for (var folder in directory.list(recursive: false)) {
      if (folder is Directory) {
        directories.add(folder);
      }
    }
  }

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
