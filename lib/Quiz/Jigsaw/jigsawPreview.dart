import 'dart:io';
import 'dart:typed_data';

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
  late List<Uint8List> puzzlePieces; // = PuzzlePiece(widget.file)
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
      height = Image.memory(puzzlePieces[0]).height;
      width = Image.memory(puzzlePieces[0]).width;
    } on Exception catch (_) {
      print('empty puzzle list');
    }
    print(height);
    print(width);
  }

  Widget getItem(Uint8List bytes) {
    //print(123);
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
        height: height,
        width: width,
        child: Image.memory(
          bytes,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ));
  }

  List<Widget> items() {
    List<Widget> items = [];
    //print(1000);
    //print(puzzlePieces.length);
    for (Uint8List piece in puzzlePieces) {
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
              //constraints: const BoxConstraints(minHeight: 400, minwidth:6),
              width: 550,
              height: 400,
              color: Colors.grey[100],
              child: Center(
                child: Wrap(
                    // alignment: WrapAlignment.spaceEvenly,
                    // runAlignment: WrapAlignment.spaceEvenly,
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    children: items()),
              )),
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
