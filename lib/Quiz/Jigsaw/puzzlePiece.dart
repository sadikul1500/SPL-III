import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

class PuzzlePiece {
  late imglib.Image image;
  final File file;
  List<Image> splitImages = [];

  PuzzlePiece(this.file) {
    image = imglib.decodeImage(file.readAsBytesSync())!;
  }

  //2X2
  List<Image> splitImage() {
    int x = 0, y = 0;

    int width = (image.width / 2).floor();
    int height = (image.height / 2).floor();

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
      splitImages.add(Image.memory(uint8list));
    }
    print(12345);
    print(splitImages.length);
    return splitImages;
  }
}
