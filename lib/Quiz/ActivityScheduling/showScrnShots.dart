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
  //List<Directory> directories = [];
  List<FileSystemEntity> _folders = [];
  int current_index = 0;

  List<FileSystemEntity> files = [];
  // List<File> files = [
  //   File(
  //       'D:/Sadi/spl3/assets/ActivitySnapShots/Brush Teeth/screenshot_2022-07-02T16-36-18-541160.png'),
  //   File(
  //       'D:/Sadi/spl3/assets/ActivitySnapShots/Brush Teeth/screenshot_2022-07-02T16-36-34-098376.png')
  // ];

  @override
  initState() {
    super.initState();
    listDirectories();
  }

  void listDirectories() async {
    _folders = directory.listSync(recursive: false, followLinks: false);
    print(_folders[current_index]);
    // for (var item in _folders) {
    //   if (item is File) {
    //     _folders.remove(item);
    //   }
    // }
    // await for (var folder in directory.list(recursive: false)) {
    //   if (folder is Directory) {
    //     directories.add(folder);
    //   }
    // }
    //print(120);
    //print(directories);
  }

  void listFiles() async {
    final dir = _folders[current_index].path;
    final directory = Directory(dir);
    for (var file in directory.listSync(recursive: false, followLinks: false)){
      // if (_folders.isNotEmpty) {
      //   for (var file in _folders[current_index]) {
          //.listSync(recursive: false)
          if (file is File) {
            files.add(file);
        //   }
         }
      }
    //return files;
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
      body: const Text('ok')
      
    ); //directories.isEmpty?noDataFound():files.isEmpty?noFileFound()
  }

  Widget noDataFound() {
    return const Center(child: Text('no Data Found'));
  }

  //#directories[current_index].list().isEmpty
  Widget noFileFound() {
    // listFiles().then((data) {
    //   if (files.isEmpty) {
    //     return const Center(child: Text('no Data Found'));
    //   } else {
    //     return const CircularProgressIndicator();
    //   }
    // });
    return const Text('hiii');
    // if(){
    //   return const Center(child: Text('no Data Found'));
    // }
    // return const Center(child: Text('no Data Found'));
  }
}
