//import 'package:kids_learning_tool/Lessons/Nouns/names.dart';
//import 'package:path_provider/path_provider.dart';
//import 'dart:io';

import 'package:kids_learning_tool/Model/noun_list.dart';
import 'package:kids_learning_tool/boxes.dart';

class NameList {
  //List<Name> names = [];
  List<NounItem> nouns = [];
  // File file =
  //     File('D:/Sadi/FlutterProjects/kids_learning_tool/nounList/noun.txt');
  //List<String> lines = [];
  final box = Boxes.getNouns();

  NameList() {
    loadData();
  }

  loadData() {
    nouns = box.values.toList().cast<NounItem>();
  }

  Future addNoun(String text, String meaning, String dir, String audio) async {
    final name = NounItem(text, meaning, dir, audio);
// ..text = text
//       ..meaning = meaning
//       ..dir = dir
//       ..audio = audio
    box.add(name);
  }

  void removeItem(NounItem noun) {
    noun.delete();
  }

  List<NounItem> getList() {
    nouns.sort((a, b) => a.text.compareTo(b.text));
    // print("12333333 name_list.dart");
    // print(nouns.length);
    // for (NounItem noun in nouns) {
    //   print(noun.text + " " + noun.dir + " " + noun.audio);
    // }
    // print(123333);
    return nouns;
  }
}



// final file = await File(
//     'D:/Sadi/FlutterProjects/kids_learning_tool/nounList/noun.txt');

// Write the file

//final Directory directory = await getApplicationDocumentsDirectory();
//final File file = File('${directory.path}/my_file.txt');


// Future addNoun(String text, String meaning, String dir, String audio) async {
//     names.add(Name(text, meaning, dir, audio));
//     await _write(text, meaning, dir, audio);
//   }



// void createNames() {
//     //print("lines length " + '${lines.length}');
//     if (names.length == lines.length) {
//       return;
//     }
//     for (String line in lines) {
//       final ln = line.split('; ');
//       names.add(Name(ln[0], ln[1], ln[2], ln[3]));
//     }
//   }

// Future loadData() async {
  //   await _read();
  //   createNames();
  // }


// List<Name> getList() {
//     if (names.isEmpty) {
//       //print('yes list is empty');
//       loadData();

//       //return [];
//     }
//     names.sort((a, b) => a.text.compareTo(b.text));
//     return names;
//   }


// Future _read() async {
//     //List<String> textLines = [];
//     try {
//       lines = await file.readAsLines();
//     } catch (e) {
//       print("Couldn't read file");
//     }
//     //return textLines;
//   }

// //write read write operations
//   Future<File> _write(
//       String text, String meaning, String dir, String audio) async {
//     String line = text + '; ' + meaning + '; ' + dir + '; ' + audio;
//     //addNoun(text, meaning, dir);
//     return await file.writeAsString('\n$line', mode: FileMode.append);
//   }



// void removeItem(String name) async {
//     names.removeWhere((element) => element.text == name);
//     final List<String> lines = await file.readAsLines();
//     lines.removeWhere((element) => element.split('; ').first == name);
//     await file.writeAsString(lines.join('\n'));
//   }