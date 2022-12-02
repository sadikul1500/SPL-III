import 'package:hive/hive.dart';
part 'graph_data.g.dart';

@HiveType(typeId: 1)
class Person {
  Person(
      {required this.id,
      required this.category,
      this.level =
          0, // 0 means there's no level.. 1 means jigsaw 2X2 and 2 means jigsaw 2X3
      required this.time,
      required this.numberOfAttempts,
      required this.dateTime,
      this.topic = ''});

  @HiveField(0)
  String id;

  @HiveField(1)
  String category;

  @HiveField(2)
  int level;

  @HiveField(3)
  int time;

  @HiveField(4)
  int numberOfAttempts;

  @HiveField(5)
  DateTime dateTime;

  @HiveField(6)
  String topic;
}
