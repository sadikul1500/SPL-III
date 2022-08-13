//either image or video
//flutter packages pub run build_runner build
// import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
part 'reward_list.g.dart';

@HiveType(typeId: 5)
class RewardItem extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String image; //single image

  @HiveField(2)
  late String video;

  // @HiveField(3)
  // late String audio;

  // @HiveField(4)
  // late String video;

  bool isSelected = false;
  String category = 'all';
  //List<String> imgList = [];

  RewardItem(this.title, this.image, this.video);  
  

  
}
