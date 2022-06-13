import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Association/association_list_box.dart';
import 'package:kids_learning_tool/Model/association_list.dart';

class AssociationSearch extends SearchDelegate<String> {
  AssociationList associationList = AssociationList();
  List<String> data = [];
  List<AssociationItem> associations = [];

  AssociationSearch(this.associations) {
    for (AssociationItem association in associations) {
      data.add(association.text);
    }
  }

  Future loadData() async {
    associations = associationList.getList();
    await Future.delayed(const Duration(milliseconds: 500));

    if (associations.isEmpty) {
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
