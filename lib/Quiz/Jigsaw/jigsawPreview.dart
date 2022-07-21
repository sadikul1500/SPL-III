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
  }

  Widget getItem(Image img) {
    //print(123);
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
        height: 200,
        width: 200,
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
      body: Container(
          constraints: const BoxConstraints(minHeight: 400),
          width: 600,
          color: Colors.amberAccent[100],
          child: Wrap(
              direction: Axis.horizontal,
              spacing: 5,
              runSpacing: 5,
              children: items())),
    );
  }
}
