// import 'package:flutter_chart_graph/boxes.dart';
// import 'package:flutter_chart_graph/data_model.dart';
import 'package:kids_learning_tool/Model/graph_data.dart';
import 'package:kids_learning_tool/boxes.dart';

class ReadDB {
  List<Person> persons = [];
  Set<String> ids = {};

  ReadDB() {
    final box = Boxes.getPersons();
    persons = box.values.toList().cast<Person>();
    setIdList();
  }

  void setIdList() {
    // persons.id
    for (Person person in persons) {
      ids.add(person.id);
    }
  }
}
