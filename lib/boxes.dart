import 'package:hive/hive.dart';
import 'package:kids_learning_tool/Model/color_list.dart';

import 'package:kids_learning_tool/Model/noun_list.dart';

class Boxes {
  static Box<NounItem> getNouns() => Hive.box<NounItem>('nouns');
  static Box<ColorItem> getColors() => Hive.box<ColorItem>('colors');
}
