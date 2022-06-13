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

  // @HiveField(3)
  // late String audio;

  bool isSelected = false;
  // List<String> imgList = [];

  ActivityItem(this.text, this.meaning, this.video) {
    // listDir(dir).then((data) {
    //   imgList = data;
    // });
  }

  // List<String> getImgList() {
  //   return imgList;
  // }

  // Future listDir(String folderPath) async {
  //   var directory = Directory(folderPath);
  //   //print(directory);

  //   var exists = await directory.exists();
  //   if (exists) {
  //     directory
  //         .list(recursive: true, followLinks: false)
  //         .listen((FileSystemEntity entity) {
  //       String path = entity.path.replaceAll('\\', '/');
  //       imgList.add(path);
  //     });
  //   }

  //   return imgList;
  // }
}
