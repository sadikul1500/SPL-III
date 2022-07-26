import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Quiz/ActivityScheduling/itemSelectionWidget.dart';

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
  List<File> files = [
    File(
        'D:/Sadi/spl3/assets/ActivitySnapShots/Brush Teeth/screenshot_2022-07-02T16-36-18-541160.png'),
    File(
        'D:/Sadi/spl3/assets/ActivitySnapShots/Brush Teeth/screenshot_2022-07-02T16-36-34-098376.png')
  ];

  @override
  initState() {
    super.initState();
    //listDirectories();
  }

  listDirectories() async {
    await for (var folder in directory.list(recursive: false)) {
      if (folder is Directory) {
        directories.add(folder);
      }
    }
    print(120);
    print(directories);
  }

  listFiles() async {
    files = [];
    if (directories.isNotEmpty) {
      await for (var file
          in directories[current_index].list(recursive: false)) {
        if (file is File) {
          files.add(file);
        }
      }
    }
    print(100);
    print(files);
  }

  @override
  Widget build(BuildContext context) {
    //listFiles();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Activity scheduling test'),
          centerTitle: true,
        ),
        body: Snapshot(files, bikolpoSetState: () {
          setState(() {
            print(1111111);
          });
        }));
  }
}
