import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Model/reward_list.dart';
import 'package:kids_learning_tool/Reward/reward_list_box.dart';

class RewardSearch extends SearchDelegate<String> {
  RewardList rewardList = RewardList();
  List<String> data = [];
  List<RewardItem> rewards = [];

  RewardSearch(this.rewards) {
    for (RewardItem reward in rewards) {
      data.add(reward.title);
    }
  }

  Future loadData() async {
    rewards = rewardList.getList();
    await Future.delayed(const Duration(milliseconds: 500));

    if (rewards.isEmpty) {
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
