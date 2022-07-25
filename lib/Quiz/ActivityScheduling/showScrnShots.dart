import 'dart:io';

import 'package:flutter/material.dart';

class ShowActivityScreenShots extends StatefulWidget {
  // final List<File> files;
  // const ShowCapturedWidget({Key? key, required this.files}) : super(key: key);
  @override
  State<ShowActivityScreenShots> createState() =>
      _ShowActivityScreenShotsState();
}

class _ShowActivityScreenShotsState extends State<ShowActivityScreenShots> {
  final Directory directory =
      Directory('D:/Sadi/spl3/assets/ActivitySnapShots');
  List<Directory> directories = [];
  int current_index = 0;
  List<File> files = [];
  @override
  initState() {
    super.initState();
    listDirectories();
  }

  listDirectories() async {
    await for (var folder in directory.list(recursive: false)) {
      if (folder is Directory) {
        directories.add(folder);
      }
    }
  }

  listFiles() async {
    files = [];
    await for (var file in directories[current_index].list(recursive: false)) {
      if (file is File) {
        files.add(file);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Activity scheduling test'),
          centerTitle: true,
        ),
        body: Container());
  }
}
