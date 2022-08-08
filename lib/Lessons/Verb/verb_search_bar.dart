import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Verb/verb_list_db.dart';

import 'package:kids_learning_tool/Model/verb_list.dart';

//thanks Ryan
class CustomDelegate extends SearchDelegate<String> {
  VerbList verbList = VerbList();
  List<String> data = [];
  List<VerbItem> verbs = [];

  CustomDelegate(this.verbs) {
    for (VerbItem verb in verbs) {
      data.add(verb.text);
    }
  }

  Future loadData() async {
    verbs = verbList.getList();
    await Future.delayed(const Duration(milliseconds: 500));

    if (verbs.isEmpty) {
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
        var noun = listToShow[i];

        return ListTile(
          title: Text(noun),
          onTap: () => close(context, noun),
        );
      },
    );
  }
}
