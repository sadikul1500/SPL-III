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
  String _selectedFiles = '';
  List<File> files = [];

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
                  'Select Images',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            const SizedBox(height: 5),
            Text(
              _selectedFiles,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ), //files.last.path.split('\\').last
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60), elevation: 3),
              onPressed: () {
                if (_selectedFiles.isNotEmpty) {
                  Navigator.of(context).push(
                    // With MaterialPageRoute, you can pass data between pages,
                    // but if you have a more complex app, you will quickly get lost.
                    MaterialPageRoute(
                      builder: (context) => JigsawPreview(files),
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
                if (_selectedFiles.isNotEmpty) {
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
        allowMultiple: true);

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      //file = File((result.files.single.path)!);
      setState(() {
        for (File file in files) {
          _selectedFiles += file.path.split('\\').last + ' ';
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

      // File(selectedDirectory + '/noun.txt').createSync(recursive: true);
      // _write(File(selectedDirectory + '/noun.txt'));
      copyImage(selectedDirectory);
      // copyAudio(selectedDirectory);
    }
    // }
  }

  Future<void> copyImage(String destination) async {
    final newDir =
        await Directory(destination + '/Quiz/jigsaw').create(recursive: true);
    for (File file in files) {
      file.copy('${newDir.path}/${file.path.split("\\").last}');
    }
  }
}
