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
  final File file;

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

  @override
  void initState() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jigsaw Puzzle')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 550,
                height: 400,
                color: Colors.grey[300],
                child: Center(
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    children: dragTargetObjects.map((item) {
                      return DragTarget<ItemModel>(
                        onAccept: (receivedItem) async {
                          if (item.bytes == receivedItem.bytes) {
                            setState(() {
                              item.accepting = false;
                              item.isSuccessful = true;
                              draggableObjects.remove(receivedItem);
                            });
                          } else {
                            setState(() {
                              item.accepting = false;
                            });
                          }
                        },
                        onLeave: (receivedItem) {
                          setState(() {
                            item.accepting = false;
                          });
                        },
                        onWillAccept: (receivedItem) {
                          setState(() {
                            if (!item.isSuccessful) item.accepting = true;
                          });
                          return true;
                        },
                        builder: (context, acceptedItem, rejectedItem) =>
                            Container(
                                decoration: BoxDecoration(
                                    color: item.accepting
                                        ? Colors.red
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.black,
                                        width: item.isSuccessful ? 2 : 0)),
                                height: height,
                                width: width,
                                child: Image.memory(item.bytes,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                    colorBlendMode: BlendMode.modulate,
                                    color: item.isSuccessful
                                        ? Colors.white.withOpacity(1.0)
                                        : item.accepting
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.white.withOpacity(0.6))),
                      );
                    }).toList(),
                  ),
                )),
            Container(
                constraints: const BoxConstraints(minHeight: 400),
                width: 300,
                color: draggableObjects.isNotEmpty
                    ? Colors.grey[300]
                    : Colors.transparent,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Center(
                        child: Wrap(
                      spacing: 10,
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
      ),
    );
  }
}
