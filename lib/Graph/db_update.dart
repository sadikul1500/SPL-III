import 'dart:io';

import 'package:kids_learning_tool/Model/graph_data.dart';
import 'package:kids_learning_tool/boxes.dart';

class DatabaseUpdate {
  File file;
  var box;
  String id;
  List<String> entries = ['', '', '', ''];

  DatabaseUpdate(this.file, this.id) {
    box = Boxes.getPersons();
    readFile();
  }

  void readFile() {
    List<String> lines = file.readAsLinesSync();
    for (var line in lines) {
      if (line.split('; ').first == 'matching') {
        entries[0] = line;
      } else if (line.split('; ').first == 'drag & drop') {
        entries[1] = line;
      } else if (line.split('; ').first == 'activity scheduling') {
        entries[2] = line;
      } else {
        entries[3] = line;
      }
    }
    addData();
  }

  void addData() {
    print('add data called');
    if (entries[0].isNotEmpty) {
      //matching
      var values = entries[0].split('; ');
      box.add(Person(
          id: id,
          category: values[0],
          time: int.parse(values[1]),
          numberOfAttempts: int.parse(values[2]),
          dateTime: DateTime.parse(values[3]),
          topic: values[4]));
    }
    if (entries[1].isNotEmpty) {
      //drag & drop
      var values = entries[1].split('; ');
      box.add(Person(
          id: id,
          category: values[0],
          time: int.parse(values[1]),
          numberOfAttempts: int.parse(values[2]),
          dateTime: DateTime.parse(values[3]),
          topic: ''));
    }
    if (entries[2].isNotEmpty) {
      //activity scheduling
      var values = entries[2].split('; ');
      box.add(Person(
          id: id,
          category: values[0],
          time: int.parse(values[1]),
          numberOfAttempts: int.parse(values[2]),
          dateTime: DateTime.parse(values[3]),
          topic: values[4]));
    }
    if (entries[3].isNotEmpty) {
      //jigsaw puzzle
      var values = entries[3].split('; ');
      box.add(Person(
          id: id,
          category: 'matching',
          time: int.parse(values[1]),
          numberOfAttempts: int.parse(values[2]),
          dateTime: DateTime.parse(values[3]),
          topic: values[4]));
    }

    print('added');
  }
}
