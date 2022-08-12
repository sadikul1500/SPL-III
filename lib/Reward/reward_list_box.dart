import 'package:kids_learning_tool/Model/reward_list.dart';
import 'package:kids_learning_tool/boxes.dart';

class RewardList {
  List<RewardItem> reward = [];

  final box = Boxes.getReward();

  RewardList() {
    loadData();
  }

  loadData() {
    reward = box.values.toList().cast<RewardItem>();
  }

  Future addReward(String title, String image, String video) async {
    final newRewardItem = RewardItem(title, image, video);

    try {
      box.add(newRewardItem);
    } catch (error) {
      //throw exception
    }
  }

  void removeItem(RewardItem reward) {
    try {
      reward.delete();
    } catch (error) {
      //throw exception
    }
  }

  List<RewardItem> getList() {
    return reward;
  }
}
