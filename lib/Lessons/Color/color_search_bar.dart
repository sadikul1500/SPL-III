import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Color/addToDb.dart';
import 'package:kids_learning_tool/Model/color_list.dart';
//import 'package:kids_learning_tool/Lessons/Nouns/names.dart';

//import 'package:kids_learning_tool/Lessons/Nouns/noun.dart';
//thanks Ryan
class ColorSearch extends SearchDelegate<String> {
  ColorList colorList = ColorList();
  List<String> data = [];
  List<ColorItem> colors = [];

  ColorSearch(this.colors) {
    for (ColorItem color in colors) {
      data.add(color.text);
    }
  }

  Future loadData() async {
    colors = colorList.getList();
    await Future.delayed(const Duration(milliseconds: 500));

    if (colors.isEmpty) {
      return [];
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    // print('building.......');
    List<String> listToShow;
    if (query.isNotEmpty) {
      listToShow = data
          .where((e) =>
              e.toLowerCase().contains(query.toLowerCase()) &&
              e.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    } else {
      listToShow = data;
    }

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var colour = listToShow[i];
        // print('calling listview builder...');
        return ListTile(
          title: Text(colour),
          onTap: () => close(context, colour),
        );
      },
    );
  }
}
