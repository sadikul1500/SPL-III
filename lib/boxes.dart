import 'package:hive/hive.dart';
import 'package:kids_learning_tool/Model/activity_list.dart';
import 'package:kids_learning_tool/Model/association_list.dart';
// import 'package:kids_learning_tool/Model/color_list.dart';
import 'package:kids_learning_tool/Model/graph_data.dart';

import 'package:kids_learning_tool/Model/noun_list.dart';
import 'package:kids_learning_tool/Model/reward_list.dart';
import 'package:kids_learning_tool/Model/verb_list.dart';

class Boxes {
  static Box<NounItem> getNouns() => Hive.box<NounItem>('nouns');
  static Box<VerbItem> getVerbs() => Hive.box<VerbItem>('verbs');
  // static Box<ColorItem> getColors() => Hive.box<ColorItem>('colors');
  static Box<ActivityItem> getActivity() => Hive.box<ActivityItem>('activity');
  static Box<AssociationItem> getAssociation() =>
      Hive.box<AssociationItem>('association');
  static Box<RewardItem> getReward() => Hive.box<RewardItem>('reward');
  static Box<Person> getPersons() => Hive.box<Person>('person');
}
