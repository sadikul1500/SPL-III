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

  late Future<dynamic> files;
  // List<File> files = [
  //   File(
  //       'D:/Sadi/spl3/assets/ActivitySnapShots/Brush Teeth/screenshot_2022-07-02T16-36-18-541160.png'),
  //   File(
  //       'D:/Sadi/spl3/assets/ActivitySnapShots/Brush Teeth/screenshot_2022-07-02T16-36-34-098376.png')
  // ];

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

  Future<List<File>> listFiles() async {
    files = null;
    if (directories.isNotEmpty) {
      await for (var file
          in directories[current_index].list(recursive: false)) {
        if (file is File) {
          files.add(file);
        }
      }
    }
    return files;
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
      body: FutureBuilder<List<File>>(
        future: files,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Text('The answer to everything is ${snapshot.data}');
          } else {
            return Text('Calculating answer...');
          }
        },
      ),
    ); //directories.isEmpty?noDataFound():files.isEmpty?noFileFound()
  }

  Widget noDataFound() {
    return const Center(child: Text('no Data Found'));
  }

  //#directories[current_index].list().isEmpty
  Widget noFileFound() {
    listFiles().then((data) {
      if (files.isEmpty) {
        return const Center(child: Text('no Data Found'));
      } else {
        return const CircularProgressIndicator();
      }
    });
    return const Text('hiii');
    // if(){
    //   return const Center(child: Text('no Data Found'));
    // }
    // return const Center(child: Text('no Data Found'));
  }
}
