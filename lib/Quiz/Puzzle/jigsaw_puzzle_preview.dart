import 'dart:ui' as ui;

import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kids_learning_tool/Quiz/Puzzle/jigsaw_puzzle_card_border_light.dart';
import 'package:kids_learning_tool/Quiz/Puzzle/jigsaw_puzzle.dart';
import 'package:kids_learning_tool/Quiz/Puzzle/jigsaw_puzzle_data.dart';

class JigsawPuzzlePreviewWidget extends StatefulWidget {
  ui.Image srcImage;
  Function(int) correctCallback;

  JigsawPuzzlePreviewWidget(
    this.srcImage,
    this.correctCallback,
  );

  @override
  _JigsawPuzzlePreviewWidgetState createState() =>
      _JigsawPuzzlePreviewWidgetState();
}

class _JigsawPuzzlePreviewWidgetState extends State<JigsawPuzzlePreviewWidget> {
  final Map<int, Widget> _previewImageCardMap = {};
  final List<Widget> _jigsawPuzzleCardLightBorderList = [];

  @override
  void initState() {
    super.initState();
    _generateJigsawPuzzleCardWidgetList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTargetAreaWidget(context);
  }

  void _generateJigsawPuzzleCardWidgetList() {
    //print('called');
    _previewImageCardMap.clear();
    _previewImageCardMap.addAll(
        JigsawPuzzleDataGenerator.generatePreviewImageJigsawPuzzleCardWidgetMap(
      image: widget.srcImage,
      onCorrectCallback: (int id, JigsawPuzzleData data) {
        setState(() {
          _jigsawPuzzleCardLightBorderList
              .add(_buildCorrectBorderLightWidget(data));
          widget.correctCallback(id);
        });
      },
      onErrorCallback: (int id, JigsawPuzzleData data) {
        setState(() {
          _jigsawPuzzleCardLightBorderList
              .add(_buildErrorBorderLightWidget(data));
        });
      },
    ));

    if (_previewImageCardMap.isEmpty) {
      print('Loading failed, please try again'); //加载失败，请重试
    } else {
      setState(() {});
    }
  }

  Widget _buildTargetAreaWidget(BuildContext context) {
    return Expanded(
      flex: 840,
      child: Center(
        child: _buildPreviewImageWidget(),
      ),
    );
  }

  Widget _buildPreviewImageWidget() {
    return SizedBox(
      width: 480,
      height: 480,
      child: Stack(
        children: [
          ..._previewImageCardMap.values,
          ..._jigsawPuzzleCardLightBorderList,
        ],
      ),
    );
  }

  // correct matching
  Widget _buildCorrectBorderLightWidget(JigsawPuzzleData data) {
    return Positioned(
      left: data.left,
      top: data.top,
      child: OpacityAnimatedWidget(
        enabled: true,
        duration: const Duration(milliseconds: 2000),
        values: const [0, 1, 0],
        child: JigsawPuzzleCardBorderLightWidget(
          data: data,
          color: const Color(0XFFFFF662),
        ),
        animationFinished: (_) {
          setState(() {
            _jigsawPuzzleCardLightBorderList.clear();
          });
        },
      ),
    );
  }

  // Mis match
  Widget _buildErrorBorderLightWidget(JigsawPuzzleData data) {
    return Positioned(
      left: data.left,
      top: data.top,
      child: OpacityAnimatedWidget(
        enabled: true,
        duration: const Duration(milliseconds: 2000),
        values: const [0, 1, 0, 1, 0, 1, 0],
        child: JigsawPuzzleCardBorderLightWidget(
          data: data,
          color: const Color(0XFFFF7C6E),
        ),
        animationFinished: (_) {
          setState(() {
            _jigsawPuzzleCardLightBorderList.clear();
          });
        },
      ),
    );
  }
}
