import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as imglib;

class PuzzlePiece {
  late imglib.Image image;
  final File file;
  late Uint8List bytes;
  List<Uint8List> splitImages = [];

  PuzzlePiece(this.file) {
    bytes = file.readAsBytesSync();
    image = imglib.decodeImage(bytes)!;
  }

  //2X2
  List<Uint8List> splitImage() {
    int x = 0, y = 0;
    int imageHeight = image.height > 350 ? 350 : image.height;
    int imageWidth = image.width > 500 ? 500 : image.width;

    image = imglib.copyResize(image, height: imageHeight, width: imageWidth);
    int width = (imageWidth / 2).floor();
    int height = (imageHeight / 2).floor();

    List<imglib.Image> parts = <imglib.Image>[];
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        parts.add(imglib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    for (var part in parts) {
      Uint8List uint8list = Uint8List.fromList(imglib.encodeJpg(part));
      splitImages.add(uint8list);
    }
    print(12345);
    print(splitImages.length);
    return splitImages;
  }
}
