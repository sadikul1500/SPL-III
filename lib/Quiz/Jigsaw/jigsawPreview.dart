import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kids_learning_tool/Quiz/Jigsaw/puzzlePiece.dart';

//2X2 puzzle
class ItemModel {
  Uint8List bytes;
  bool accepting; //on will accept
  bool isSuccessful;
  ItemModel(this.bytes, {this.accepting = false, this.isSuccessful = false});
}

class JigsawPreview extends StatefulWidget {
  late List<File> files;
  String level;
  String topic;
  JigsawPreview(this.files, this.level, this.topic);
  @override
  State<JigsawPreview> createState() => _JigsawPreviewState();
}

class _JigsawPreviewState extends State<JigsawPreview> {
  late List<Uint8List> puzzlePieces; // = PuzzlePiece(widget.file)
  double? height = 400;
  double? width = 400;
  List<ItemModel> draggableObjects = [];
  List<ItemModel> dragTargetObjects = [];
  List<bool> selected = [];
  // List<File> assignToStudent = [];

  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  int currentIndex = 0;
  int len = 0;
  String level = '2', topic = '';

  @override
  void initState() {
    super.initState();
    len = widget.files.length;
    level = widget.level;
    topic = widget.topic;
    for (int i = 0; i < len; i++) {
      selected.add(false);
    }
    loadPuzzlePiece();
    loadAudio();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future loadAudio() async {
    await audioPlayer.setAudioSource(
        AudioSource.uri(Uri.file('D:/Sadi/spl3/assets/Audios/win.wav')),
        initialPosition: Duration.zero,
        preload: true);

    audioPlayer
        .setLoopMode(LoopMode.off); //off- play once... on- continues playing..
    audioPlayer.playerStateStream.listen((state) {
      setState(() {});
    });
    audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration!;
      });
    });
    audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    return audioPlayer;
  }

  Future<void> audioPlay() async {
    audioPlayer.play();

    Future.delayed(duration, () => audioPlayer.pause());
  }

  void loadPuzzlePiece() {
    piecePuzzle(currentIndex);
    dragTargetObjects.clear();
    draggableObjects.clear();
    for (int i = 0; i < 4; i++) {
      draggableObjects.add(ItemModel(puzzlePieces[i]));
      dragTargetObjects.add(ItemModel(puzzlePieces[i]));
    }
    draggableObjects.shuffle();
  }

  void piecePuzzle(int index) {
    final object = PuzzlePiece(widget.files[index], level.split('X').last);
    puzzlePieces = object.splitImage();
    try {
      height = Image.memory(puzzlePieces[0]).height;
      width = Image.memory(puzzlePieces[0]).width;
    } on Exception catch (_) {
      throw Exception();
      // print('empty puzzle list');
    }
  }

  @override
  Widget build(BuildContext context) {
    //loadPuzzlePiece();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ধাঁধা প্রিভিউ'), //'Jigsaw Puzzle Preview'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
              'ডানপাশ থেকে ড্র্যাগ করে বামপাশের সাথে ম্যাচ করুন', //'Drag from right side and drop to the left side',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        constraints: const BoxConstraints(
                            minHeight: 350,
                            maxHeight: 400,
                            minWidth: 500,
                            maxWidth: 550),
                        // width: 550,
                        // height: 400,
                        color: Colors.grey[500],
                        child: Center(
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 2,
                            runSpacing: 2,
                            children: dragTargetObjects.map((item) {
                              return DragTarget<ItemModel>(
                                onAccept: (receivedItem) async {
                                  if (item.bytes == receivedItem.bytes) {
                                    setState(() {
                                      item.accepting = false;
                                      item.isSuccessful = true;
                                      draggableObjects.remove(receivedItem);
                                    });
                                    await audioPlay();
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
                                    if (!item.isSuccessful) {
                                      item.accepting = true;
                                    }
                                  });
                                  return true;
                                },
                                builder: (context, acceptedItem,
                                        rejectedItem) =>
                                    Container(
                                        decoration: BoxDecoration(
                                            color: item.accepting
                                                ? Colors.red
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: item.isSuccessful
                                                    ? Colors.black
                                                    : Colors.black12,
                                                width:
                                                    item.isSuccessful ? 2 : 1)),
                                        height: height,
                                        width: width,
                                        child: Image.memory(item.bytes,
                                            fit: BoxFit.contain,
                                            filterQuality: FilterQuality.high,
                                            colorBlendMode: BlendMode.modulate,
                                            color: item.isSuccessful
                                                ? Colors.white.withOpacity(1.0)
                                                : item.accepting
                                                    ? Colors.white
                                                        .withOpacity(0.1)
                                                    : Colors.white
                                                        .withOpacity(0.6))),
                              );
                            }).toList(),
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: [
                    // const SizedBox(height: 55),
                    Container(
                        constraints: const BoxConstraints(
                            minHeight: 350,
                            maxHeight: 400,
                            minWidth: 500,
                            maxWidth: 550),
                        // width: 300,
                        //height: 600,
                        color: draggableObjects.isNotEmpty
                            ? Colors.grey[500]
                            : Colors.transparent,
                        child: Center(
                            child: Wrap(
                          spacing: 2,
                          runSpacing: 2,
                          direction: Axis.horizontal,
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
                        ))),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // if (assignToStudent.isNotEmpty) {
          assignContentToStudent();
          // } else {
          // showMaterialDialog();
          // }
        },
        icon: const Icon(Icons.add),
        label: const Text('শিক্ষার্থীকে এসাইন করুন', //'Assign to Student',
            style: TextStyle(
              fontSize: 18,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future assignContentToStudent() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle:
            'শিক্ষার্থীর ফোল্ডার নির্বাচন করুন'); //'Choose student\'s folder');

    if (selectedDirectory == null) {
      // User canceled the picker
    } else {
      selectedDirectory.replaceAll('\\', '/');
      File(selectedDirectory + '/Quiz/jigsaw/jigsaw.txt')
          .createSync(recursive: true);
      //.createSync(recursive: true);
      _write(File(selectedDirectory + '/Quiz/jigsaw/jigsaw.txt'));
      copyImage(selectedDirectory + '/Quiz/jigsaw');
    }
    // }
  }

  Future<void> copyImage(String destination) async {
    final newDir = Directory(destination); //.create(recursive: true);
    for (File file in widget.files) {
      await file.copy('${newDir.path}/${file.path.split("\\").last}');
    }
  }

  Future _write(File file) async {
    // for (File imageFile in selectedItems) {
    // print('called _write function ${file.path}');
    try {
      await file.writeAsString(
          widget.files[0].path.split('\\').last +
              '; ' +
              level.split('X').last +
              '; ' +
              topic +
              '\n',
          mode: FileMode.append);
    } catch (e) {
      throw Exception(e);
    }
    // }
  }

  void showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
                'কোনো আইটেম নির্বাচন করা হয়নি'), //'No item was selected'),
            content: const Text(
                'কমপক্ষে একটি আইটেম নির্বাচন করুন'), //'Please select at least one item before assigning'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ঠিক আছে ')),
            ],
          );
        });
  }
}





//checkbox.....
// SizedBox(
                //   width: 400,
                //   child: Row(
                //     //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: <Widget>[
                //       Checkbox(
                //           value: selected[currentIndex],
                //           onChanged: (value) {
                //             setState(() {
                //               selected[currentIndex] =
                //                   !selected[currentIndex];
                //               if (selected[currentIndex]) {
                //                 assignToStudent
                //                     .add(widget.files[currentIndex]);
                //               } else {
                //                 assignToStudent
                //                     .remove(widget.files[currentIndex]);
                //               }
                //             });
                //           }),
                //       const Spacer(),
                //       IconButton(
                //           onPressed: () {
                //             setState(() {
                //               widget.files.removeAt(currentIndex);
                //               selected.removeAt(currentIndex);
                //               len -= 1;
                //             });
                //           },
                //           icon: const Icon(Icons.delete_forever_rounded)),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 15),








//prev next

// const SizedBox(height: 20),
                // SizedBox(
                //   width: 400,
                //   child: Row(
                //     //mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       ElevatedButton.icon(
                //         onPressed: () {
                //           //stop();

                //           setState(() {
                //             //_isPlaying = false;

                //             try {
                //               currentIndex = (currentIndex - 1) % len;
                //               loadPuzzlePiece();
                //             } catch (e) {
                //               //print(e);
                //             }
                //           });
                //         },
                //         label: const Text(
                //           'Prev',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 17,
                //           ),
                //         ),
                //         icon: const Icon(
                //           Icons.navigate_before,
                //         ),
                //         style: ElevatedButton.styleFrom(
                //           alignment: Alignment.center,
                //           minimumSize: const Size(100, 42),
                //         ),
                //       ),
                //       const Spacer(),
                //       //const SizedBox(width: 30),
                //       // IconButton(
                //       //     icon: (_isPaused)
                //       //         ? const Icon(Icons.play_circle_outline)
                //       //         : const Icon(Icons.pause_circle_filled),
                //       //     iconSize: 40,
                //       //     onPressed: () {
                //       //       if (!_isPaused) {
                //       //         //print('---------is playing true-------');
                //       //         pause(); //stop()
                //       //       } else {
                //       //         //print('-------is playing false-------');
                //       //         play();
                //       //       }
                //       //     }),
                //       //const SizedBox(width: 30),
                //       ElevatedButton(
                //         onPressed: () {
                //           //stop();
                //           setState(() {
                //             try {
                //               currentIndex = (currentIndex + 1) % len;
                //               loadPuzzlePiece();
                //             } catch (e) {
                //               //print(e);
                //             }
                //           });
                //         },
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           children: const <Widget>[
                //             Text('Next',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 17,
                //                 )),
                //             SizedBox(
                //               width: 5,
                //             ),
                //             Icon(Icons.navigate_next_rounded),
                //           ],
                //         ),
                //         style: ElevatedButton.styleFrom(
                //           alignment: Alignment.center,
                //           minimumSize: const Size(100, 42),
                //         ),
                //       ),
                //     ],
                //   ),
                // )