import 'package:kids_learning_tool/Model/color_list.dart';
import 'package:kids_learning_tool/boxes.dart';

class ColorList {
  List<ColorItem> colors = [];

  final box = Boxes.getColors();

  ColorList() {
    loadData();
  }

  loadData() {
    colors = box.values.toList().cast<ColorItem>();
  }

  Future addColor(String text, String meaning, String dir, String audio) async {
    final color = ColorItem(text, meaning, dir, audio);

    box.add(color);
  }

  void removeItem(ColorItem noun) {
    noun.delete();
  }

  List<ColorItem> getList() {
    colors.sort((a, b) => a.text.compareTo(b.text));
    return colors;
  }
}
