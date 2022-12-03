import 'package:flutter/material.dart';
// import 'package:flutter_chart_graph/graph_by_id.dart';
import 'package:kids_learning_tool/Graph/graph_by_id.dart';
// import 'package:flutter_chart_graph/read_db.dart';
import 'package:kids_learning_tool/Graph/read_db.dart';

// const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

// void main() => runApp(const DropdownButtonApp());

// class DropdownButtonApp extends StatefulWidget {
//   const DropdownButtonApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('DropdownButton Sample')),
//         body: const Center(
//           child: DropdownButtonExample(),
//         ),
//       ),
//     );
//   }
// }

class DropdownButtonExample extends StatefulWidget {
  // const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = '';
  List<String> ids = [];
  ReadDB db = ReadDB();

  _DropdownButtonExampleState() {
    ids = db.ids.toList();
    dropdownValue = ids.first;
    // print(dropdownValue);
    // for (var value in ids) {
    //   print(value);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home:
    return Scaffold(
        appBar: AppBar(
          title: const Text('Student Id Selection'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Student id: ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 5),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFF673AB7)),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: ids.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: const TextStyle(fontSize: 22)),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 60), elevation: 3),
                  onPressed: () {
                    // print('calling page $dropdownValue');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowGraphById(
                                  id: dropdownValue,
                                  persons: db.persons,
                                )));
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 22),
                  ))
            ],
          ),
        ));
    // );
  }
}
