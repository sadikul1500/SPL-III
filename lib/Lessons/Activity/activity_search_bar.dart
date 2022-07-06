import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Activity/activity_list_box.dart';
import 'package:kids_learning_tool/Model/activity_list.dart';

class ActivitySearch extends SearchDelegate<String> {
  ActivityList activityList = ActivityList();
  List<String> data = [];
  List<ActivityItem> activities = [];

  ActivitySearch(this.activities) {
    for (ActivityItem activity in activities) {
      data.add(activity.text);
    }
  }

  Future loadData() async {
    activities = activityList.getList();
    //await Future.delayed(const Duration(milliseconds: 500)); check without delay......
    return activities;
    // if (activities.isEmpty) {
    //   return [];
    // }
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
        var activity = listToShow[i];

        return ListTile(
          title: Text(activity),
          onTap: () => close(context, activity),
        );
      },
    );
  }
}
