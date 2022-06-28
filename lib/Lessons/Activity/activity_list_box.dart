import 'package:kids_learning_tool/Model/activity_list.dart';
import 'package:kids_learning_tool/boxes.dart';

class ActivityList {
  List<ActivityItem> activity = [];

  final box = Boxes.getActivity();

  ActivityList() {
    loadData();
  }

  loadData() {
    activity = box.values.toList().cast<ActivityItem>();
  }

  Future addActivity(String text, String meaning, 
      String video) async {
    final newActivityItem = ActivityItem(text, meaning, video);

    try{box.add(newActivityItem);}catch(error){//throw exception
    }
  }

  void removeItem(ActivityItem activity) {
    try{activity.delete();}catch(error){//throw exception
    }
  }

  List<ActivityItem> getList() {
    return activity;
  }
}
