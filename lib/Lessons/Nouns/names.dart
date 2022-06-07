import 'dart:async';
import 'dart:io';

class Name {
  late String text;
  late String meaning;
  late String dir;
  late String audio;
  List<String> imgList = [];
  bool isSelected = false;

  Name(this.text, this.meaning, this.dir, this.audio) {
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
