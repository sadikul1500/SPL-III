//import 'package:firebase_core/firebase_core.dart';
//import 'package:firedart/firedart.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:kids_learning_tool/Home/home.dart';
import 'package:kids_learning_tool/Lessons/Activity/activity_new.dart';
import 'package:kids_learning_tool/Lessons/Activity/activity_form.dart';
import 'package:kids_learning_tool/Lessons/Association/association.dart';
import 'package:kids_learning_tool/Lessons/Association/association_form.dart';
import 'package:kids_learning_tool/Lessons/Color/color.dart';
import 'package:kids_learning_tool/Lessons/Maths/addition.dart';
import 'package:kids_learning_tool/Lessons/Maths/numeracy.dart';
import 'package:kids_learning_tool/Lessons/Nouns/noun.dart';
import 'package:kids_learning_tool/Lessons/Nouns/noun_form.dart';
import 'package:kids_learning_tool/Lessons/Verb/verb.dart';
import 'package:kids_learning_tool/Lessons/Verb/verb_form.dart';
import 'package:kids_learning_tool/Model/activity_list.dart';
import 'package:kids_learning_tool/Model/association_list.dart';
import 'package:kids_learning_tool/Model/color_list.dart';
import 'package:kids_learning_tool/Model/noun_list.dart';
import 'package:kids_learning_tool/Model/reward_list.dart';
import 'package:kids_learning_tool/Model/verb_list.dart';
//import 'package:kids_learning_tool/Quiz/DragDrop/audio_test.dart';
//import 'package:kids_learning_tool/Quiz/DragDrop/audioTest.dart';
//import 'package:kids_learning_tool/Quiz/DragDrop/drag.dart';
import 'package:kids_learning_tool/Quiz/DragDrop/drag_form.dart';
//import 'package:kids_learning_tool/Quiz/Matching/preview.dart';
//import 'package:kids_learning_tool/Quiz/Matching/question.dart';
import 'package:kids_learning_tool/Quiz/quiz.dart';
import 'package:kids_learning_tool/Reward/reward.dart';
import 'package:kids_learning_tool/Reward/reward_form.dart';
import 'package:libwinmedia/libwinmedia.dart';

import 'Quiz/Matching/matching.dart';
//import 'package:kplayer/kplayer.dart';

Future<void> main() async {
  LWM.initialize();

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NounItemAdapter());
  Hive.registerAdapter(ColorItemAdapter());
  Hive.registerAdapter(AssociationItemAdapter());
  Hive.registerAdapter(ActivityItemAdapter());
  Hive.registerAdapter(VerbItemAdapter());
  Hive.registerAdapter(RewardItemAdapter());
  await Hive.openBox<NounItem>('nouns');
  await Hive.openBox<VerbItem>('verbs');
  await Hive.openBox<ColorItem>('colors');
  await Hive.openBox<ActivityItem>('activity');
  await Hive.openBox<AssociationItem>('association');
  await Hive.openBox<RewardItem>('reward');
  //await FlutterNativeView.ensureInitialized();//DartVLC.initialize();
  await DartVLC.initialize(useFlutterNativeView: true);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/noun': (context) => Noun(),
      '/nounForm': (context) => NounForm(), //NounForm(),
      '/verb': (context) => Verb(),
      '/verbForm': (context) => VerbForm(),
      '/quiz': (context) => Quiz(),
      '/matching': (context) => Matching(),
      '/drag': (context) => DragForm(), //MyApp(), //DragForm(),
      '/numeracy': (context) => Number(),
      '/addition': (context) => Addition(),
      '/color': (context) => BasicColor(),
      '/activity': (context) => Activity(),
      '/activityForm': (context) => ActivityForm(),
      '/association': (context) => Association(),
      '/associationForm': (context) => AssociationForm(),
      '/reward': (context) => Reward(),
      '/rewardForm': (context) => RewardForm(),
    },
  ));
}


//const projectId = 'crested-plexus-330007';
//Firestore.initialize(projectId);
//AudioPlayer.setMockInitialValues({});
//'/preview': (context) => Preview(question);