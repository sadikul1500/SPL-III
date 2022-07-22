import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Quiz/Jigsaw/puzzlePiece.dart';

//2X2 puzzle
class ItemModel {
  Uint8List bytes;
  bool accepting; //on will accept
  bool isSuccessful;
  ItemModel(this.bytes, {this.accepting = false, this.isSuccessful = false});
}

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
  List<ItemModel> draggableObjects = [];
  List<ItemModel> dragTargetObjects = [];
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
    for (int i = 0; i < 4; i++) {
      draggableObjects.add(ItemModel(puzzlePieces[i]));
      dragTargetObjects.add(ItemModel(puzzlePieces[i]));
    }
    draggableObjects.shuffle();
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
    // print(height);
    // print(width);
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
              height: double.infinity,
              color: Colors.amberAccent[100],
              child: SingleChildScrollView(
                  child: Center(
                      child: Wrap(
                spacing: 5,
                direction: Axis.vertical,
                children: draggableObjects.map((item) {
                  return Draggable<ItemModel>(
                    data: item,
                    childWhenDragging: Container(
                        alignment: Alignment.center,
                        height: height,
                        width: width,
                        child: Image.memory(item.bytes,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            colorBlendMode: BlendMode.modulate,
                            color: Colors.white.withOpacity(0.4))),
                    feedback: SizedBox(
                        //child that I drop....
                        height: height,
                        width: width,
                        child: Image.memory(
                          item.bytes,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        )),
                    child: SizedBox(
                        height: height,
                        width: width,
                        //alignment: Alignment.center,
                        child: Image.memory(
                          item.bytes,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        )),
                  );
                }).toList(),
              ))))
        ],
      ),
    );
  }
}
