import 'package:kids_learning_tool/Model/association_list.dart';
import 'package:kids_learning_tool/boxes.dart';

class AssociationList {
  List<AssociationItem> association = [];

  final box = Boxes.getAssociation();

  AssociationList() {
    loadData();
  }

  loadData() {
    association = box.values.toList().cast<AssociationItem>();
  }

  Future addAssociation(String text, String meaning, String dir, String audio,
      String video) async {
    final association = AssociationItem(text, meaning, dir, audio, video);

    box.add(association);
  }

  void removeItem(AssociationItem association) {
    association.delete();
  }

  List<AssociationItem> getList() {
    return association;
  }
}
