import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Quiz/Jigsaw/jigsawPreview.dart';
// import 'package:kids_learning_tool/Quiz/Puzzle/jigsaw_puzzle_page.dart';

class JigsawImageSelection extends StatelessWidget {
  //const NounForm({Key? key}) : super(key: key);

  static const String _title = 'Prepare a puzzle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        centerTitle: true,
      ),
      body: const PuzzleQuestion(),
    );
  }
}

class PuzzleQuestion extends StatefulWidget {
  const PuzzleQuestion({Key? key}) : super(key: key);

  @override
  _PuzzleQuestionState createState() => _PuzzleQuestionState();
}

class _PuzzleQuestionState extends State<PuzzleQuestion> {
  String _selectedFile = '';
  List<File> files = [];
  List<String> dropDownValues = ['2X2', '2X3'];
  String level = '2X2';
  TextEditingController topic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //trigger leaving and use own data
        Navigator.pop(context);
        //we need to return a future
        return Future.value(false);
      },
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
                onPressed: () {
                  _openFileExplorer();
                },
                child: const Text(
                  'Select an Image',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            const SizedBox(height: 5),
            Text(
              _selectedFile,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ), //files.last.path.split('\\').last
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Chart Type: ',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: level,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style:
                      const TextStyle(color: Color(0xFF673AB7), fontSize: 20),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      level = value!;
                    });
                  },
                  items: dropDownValues
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                controller: topic,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Topic Name',
                ),
                // validator: (String? value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Topic name can\'t be empty';
                //   }
                //   return null;
                // },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60), elevation: 3),
              onPressed: () {
                if (_selectedFile.isNotEmpty && topic.text.isNotEmpty) {
                  Navigator.of(context).push(
                    // With MaterialPageRoute, you can pass data between pages,
                    // but if you have a more complex app, you will quickly get lost.
                    MaterialPageRoute(
                      builder: (context) =>
                          JigsawPreview(files, level, topic.text),
                    ),
                  );
                }
              },
              child: const Text(
                'Preview',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60), elevation: 3),
              onPressed: () async {
                if (_selectedFile.isNotEmpty && topic.text.isNotEmpty) {
                  await assignToStudent();
                }
              },
              child: const Text(
                'Assign',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openFileExplorer() async {
    //File file;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        allowMultiple: false);

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      //file = File((result.files.single.path)!);
      setState(() {
        for (File file in files) {
          _selectedFile += file.path.split('\\').last; // + ' ';
        }
      });
    } else {
      // User canceled the picker
    }
  }

  Future assignToStudent() async {
    String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath(dialogTitle: 'Choose student\'s folder');

    if (selectedDirectory == null) {
      // User canceled the picker
    } else {
      selectedDirectory.replaceAll('\\', '/');

      File(selectedDirectory + '/Quiz/jigsaw/jigsaw.txt')
          .createSync(recursive: true);
      _write(File(selectedDirectory + '/Quiz/jigsaw/jigsaw.txt'));
      copyImage(selectedDirectory + '/Quiz/jigsaw');
      // copyAudio(selectedDirectory);
    }
    // }
  }

  Future<void> copyImage(String destination) async {
    final newDir = Directory(destination); //.create(recursive: true);
    for (File file in files) {
      file.copy('${newDir.path}/${file.path.split("\\").last}');
    }
  }

  Future _write(File file) async {
    // for (File imageFile in selectedItems) {
    await file.writeAsString(
        _selectedFile + '; ' + level.split('X').last + '; ' + topic.text + '\n',
        mode: FileMode.append);
    // }
  }
}
