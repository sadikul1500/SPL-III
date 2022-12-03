import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Graph/db_update.dart';
import 'package:kids_learning_tool/Graph/id_selection.dart';

class GraphHomePage extends StatefulWidget {
  // const GraphHomePage({Key? key}) : super(key: key);

  @override
  _GraphHomePageState createState() => _GraphHomePageState();
}

class _GraphHomePageState extends State<GraphHomePage> {
  String _selectedFile = '';
  List<File> files = [];
  bool isLoading = false;
  List<String> dropDownValues = ['2X2', '2X3'];
  // String level = '2X2';
  TextEditingController id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ডাটাবেস আপডেট'),//'Update Data'),
        centerTitle: true,
      ),
      body: Container(
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
                  'লগ ফাইল নির্বাচন করুন',//'Select a Log File',
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
            // const SizedBox(height: 10),

            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                controller: id,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'শিক্ষার্থীর আইডি দিন',//'Enter Student Id',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60), elevation: 3),
              onPressed: () {
                if (_selectedFile.isNotEmpty && id.text.isNotEmpty) {
                  DatabaseUpdate(files[0], id.text);
                  setState(() {
                    isLoading = true;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      isLoading = false;
                      _selectedFile = '';
                      id.text = '';
                      files.clear();
                    });
                  });
                }
              },
              child: !isLoading
                  ? const Text(
                      'আপডেট',//'Update',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )
                  : const Text(
                      'আপডেট..',//'Updating..',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60), elevation: 3),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DropdownButtonExample()));
                // if (_selectedFile.isNotEmpty && id.text.isNotEmpty) {
                //   await assignToStudent();
                // }
              },
              child: const Text(
                'গ্রাফ দেখুন',//'Show Graph',
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
        allowedExtensions: ['txt'],
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
}
