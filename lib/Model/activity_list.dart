import 'package:hive_flutter/hive_flutter.dart';
part 'activity_list.g.dart';

@HiveType(typeId: 2)
class ActivityItem extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late String meaning;

  @HiveField(2)
  late String video;

  bool isSelected = false;

  ActivityItem(this.text, this.meaning, this.video);
}
