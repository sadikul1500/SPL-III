import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:kids_learning_tool/Quiz/Puzzle/jigsaw_puzzle_data.dart';
//import 'package:jigsaw_puzzle_demo/jigsaw_puzzle/jigsaw_puzzle_data.dart';

class JigsawPuzzlePickAreaWidget extends StatelessWidget {
  ui.Image srcImage;
  List<int> correctIdList;

  JigsawPuzzlePickAreaWidget({
    required this.srcImage,
    required this.correctIdList,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPickAreaWidget(context, _generatePickCardMap(correctIdList));
  }

  Widget _buildPickAreaWidget(
      BuildContext context, Map<int, Widget> pickCardMap) {
    List<Widget> widgetList = pickCardMap.keys.map((key) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: pickCardMap[key],
      );
    }).toList();

    widgetList.shuffle();

    return Expanded(
      flex: 440,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 52),
        child: Column(
          children: widgetList,
        ),
      ),
    );
  }

  Map<int, Widget> _generatePickCardMap(List<int> correctIdList) {
    //correctIdList.shuffle();
    Map<int, Widget> dataMap =
        JigsawPuzzleDataGenerator.generatePickJigsawPuzzleCardWidgetMap(
      image: srcImage,
      correctIdList: correctIdList,
    );
    List<int> keys = dataMap.keys.toList();

    Map<int, Widget> pickCardMap = {};
    for (var element in keys) {
      if (dataMap[element] != null) {
        pickCardMap[element] = dataMap[element]!;
      }
    }
    pickCardMap;
    return pickCardMap;
  }
}
