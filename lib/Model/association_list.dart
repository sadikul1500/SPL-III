//either image+audio+text or video
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
part 'association_list.g.dart';

@HiveType(typeId: 3)
class AssociationItem extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late String meaning;

  @HiveField(2)
  late String dir;

  @HiveField(3)
  late String audio;

  @HiveField(4)
  late String video;

  bool isSelected = false;
  List<String> imgList = [];

  AssociationItem(this.text, this.meaning, this.dir, this.audio, this.video) {
    if (dir.isNotEmpty) {
      listDir(dir).then((data) {
        imgList = data;
      });
    }
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
