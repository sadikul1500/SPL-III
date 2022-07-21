import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Quiz/Jigsaw/puzzlePiece.dart';

class JigsawPreview extends StatefulWidget {
  //final List<File> files;
  final File file;
  //List<ItemModel> values = [];
  //final List<ItemModel> items2;
  //final String question;
  const JigsawPreview(this.file);
  @override
  State<JigsawPreview> createState() => _JigsawPreviewState();
}

class _JigsawPreviewState extends State<JigsawPreview> {
  late List<Image> puzzlePieces; // = PuzzlePiece(widget.file)
  double? height = 400;
  double? width = 400;
  // final List<Widget> tests = [
  //   const Text('1'),
  //   const Text('2'),
  //   const Text('3')
  // ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    piecePuzzle();
  }

  void piecePuzzle() {
    final object = PuzzlePiece(widget.file);
    puzzlePieces = object.splitImage();
    try {
      height = puzzlePieces[0].height;
      width = puzzlePieces[0].width;
    } on Exception catch (_) {
      print('empty puzzle list');
    }
    print(height);
    print(width);
  }

  Widget getItem(Image img) {
    //print(123);
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
        height: 300,
        width: 300,
        child: img);
  }

  List<Widget> items() {
    List<Widget> items = [];
    //print(1000);
    //print(puzzlePieces.length);
    for (Image piece in puzzlePieces) {
      items.add(getItem(piece));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jigsaw Puzzle')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              constraints: const BoxConstraints(minHeight: 400),
              width: 700,
              color: Colors.amberAccent[100],
              child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runAlignment: WrapAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  spacing: 5,
                  runSpacing: 5,
                  children: items())),
          Container(
            constraints: const BoxConstraints(minHeight: 400),
            width: 400,
            color: Colors.amberAccent[100],
          )
        ],
      ),
    );
  }
}
