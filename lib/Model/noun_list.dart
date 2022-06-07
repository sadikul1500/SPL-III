import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
part 'noun_list.g.dart';

@HiveType(typeId: 0)
class NounItem extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late String meaning;

  @HiveField(2)
  late String dir;

  @HiveField(3)
  late String audio;

  bool isSelected = false;
  List<String> imgList = [];

  NounItem(this.text, this.meaning, this.dir, this.audio) {
    listDir(dir).then((data) {
      imgList = data;
    });
  }

  List<String> getImgList() {
    return imgList;
  }

  Future listDir(String folderPath) async {
    var directory = Directory(folderPath);
    //print(directory);

    var exists = await directory.exists();
    if (exists) {
      directory
          .list(recursive: true, followLinks: false)
          .listen((FileSystemEntity entity) {
        String path = entity.path.replaceAll('\\', '/');
        imgList.add(path);
      });
    }

    return imgList;
  }
}
