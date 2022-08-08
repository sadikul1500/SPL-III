//import 'package:kids_learning_tool/Lessons/Nouns/names.dart';
//import 'package:path_provider/path_provider.dart';
//import 'dart:io';

import 'package:kids_learning_tool/Model/verb_list.dart';
import 'package:kids_learning_tool/boxes.dart';

class VerbList {
  List<VerbItem> verbs = [];

  final box = Boxes.getVerbs();

  VerbList() {
    loadData();
  }

  loadData() {
    //Iterable keyItems = box.keys;

    verbs = box.values.toList().cast<VerbItem>();
  }

  Future addVerb(String text, String meaning, String dir, String audio) async {
    final verb = VerbItem(text, meaning, dir, audio);

    box.add(verb);
  }

  void removeItem(VerbItem verb) {
    for (var key in box.keys) {
      final item = box.get(key);
      if (item!.text == verb.text &&
          item.audio == verb.audio &&
          item.dir == verb.dir &&
          item.meaning == verb.meaning) {
        box.delete(key);
        break;
      }
    }
    //box.delete(0);
  }

  List<VerbItem> getList() {
    verbs.sort((a, b) => a.text.compareTo(b.text));

    return verbs;
  }
}
