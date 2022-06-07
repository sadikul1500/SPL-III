import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Nouns/name_list.dart';
//import 'package:kids_learning_tool/Lessons/Nouns/names.dart';
import 'package:kids_learning_tool/Model/noun_list.dart';

//import 'package:kids_learning_tool/Lessons/Nouns/noun.dart';
//thanks Ryan
class CustomDelegate extends SearchDelegate<String> {
  NameList nameList = NameList();
  List<String> data = [];
  List<NounItem> names = [];
  //Noun nouns = Noun();

  CustomDelegate(this.names) {
    //loading();
    // loadData().then((data) {
    //names = data;
    // });
    //names = nouns.names
    // print(names.length);
    for (NounItem name in names) {
      data.add(name.text);
    }
    // print(data);
    //print('reached');
  }

  Future loadData() async {
    names = nameList.getList();
    await Future.delayed(const Duration(milliseconds: 500));

    if (names.isEmpty) {
      return [];
    }
    // print(1223);
    // print(names);
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
        // print('calling listview builder...');
        return ListTile(
          title: Text(noun),
          onTap: () => close(context, noun),
        );
      },
    );

    // return FutureBuilder(
    //   future: loadData(),
    //   builder: (context, AsyncSnapshot snapshot) {
    //     print(snapshot.hasData);
    //     if (!snapshot.hasData) {
    //       return Center(child: CircularProgressIndicator());
    //     } else {
    //       return Container(
    //           child: ListView.builder(
    //         itemCount: names.length,
    //         scrollDirection: Axis.horizontal,
    //         itemBuilder: (_, i) {
    //           var noun = names[i].text;
    //           print('calling listview builder...');
    //           return ListTile(
    //             title: Text(noun),
    //             onTap: () => close(context, noun),
    //           );
    //         },
    //       ));
    //     }
    //   },
    // );
  }
}
