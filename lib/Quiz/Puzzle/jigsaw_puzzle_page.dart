import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Quiz/Puzzle/jigsaw_puzzle_pick_area.dart';
import 'package:kids_learning_tool/Quiz/Puzzle/jigsaw_puzzle_preview.dart';
import 'package:kids_learning_tool/Quiz/Puzzle/utils.dart';

class PuzzlePage extends StatefulWidget {
  final File file;
  const PuzzlePage({Key? key, required this.file}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  ui.Image? _srcImage;

  final List<int> _correctIdList = [];
  late JigsawPuzzlePreviewWidget preview;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    _srcImage = await ImageUtils.loadImage(widget.file);
    preview = JigsawPuzzlePreviewWidget(
      _srcImage!,
      (id) {
        setState(() {
          _correctIdList.add(id);
        });
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve the puzzle'),
        centerTitle: true,
      ),
      body: _srcImage == null
          ? const Text('No image found')
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: const ui.Color.fromARGB(255, 97, 110, 116),
              child: Row(
                children: [
                  preview,
                  JigsawPuzzlePickAreaWidget(
                    srcImage: _srcImage!,
                    correctIdList: _correctIdList,
                  ),
                ],
              ),
            ), //JigsawPuzzlePage(widget.file),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //_corre
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => PuzzlePage(file: widget.file),
          //   ),
          // );
          setState(() {
            _correctIdList.clear();

            preview = JigsawPuzzlePreviewWidget(
              _srcImage!,
              (id) {
                setState(() {
                  _correctIdList.add(id);
                });
              },
            );
          });
        },
        icon: const Icon(Icons.refresh_rounded),
        label: const Text(''),
      ),
    );
  }
}

// class JigsawPuzzlePage extends StatefulWidget {
//   //final ui.Image _srcImage;
//   final File file;
//   JigsawPuzzlePage(this.file);
//   @override
//   _JigsawPuzzlePageState createState() => _JigsawPuzzlePageState();
// }

// class _JigsawPuzzlePageState extends State<JigsawPuzzlePage> {
//   ui.Image? _srcImage;

//   List<int> _correctIdList = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadImage();
//   }

//   void _loadImage() async {
//     _srcImage = await ImageUtils.loadImage(widget.file);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_srcImage == null) {
//       return Container();
//     }
//     return _buildPageContentWidget();
//   }

//   Widget _buildPageContentWidget() {
//     return WillPopScope(
//       onWillPop: () {
//         //trigger leaving and use own data
//         Navigator.pop(context);
//         //we need to return a future
//         return Future.value(false);
//       },
//       child: Container(
//         width: double.infinity,
//         height: double.infinity,
//         color: Colors.blueGrey,
//         child: Row(
//           children: [
//             JigsawPuzzlePreviewWidget(
//               srcImage: _srcImage!,
//               correctCallback: (id) {
//                 setState(() {
//                   _correctIdList.add(id);
//                 });
//               },
//             ),
//             JigsawPuzzlePickAreaWidget(
//               srcImage: _srcImage!,
//               correctIdList: _correctIdList,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
