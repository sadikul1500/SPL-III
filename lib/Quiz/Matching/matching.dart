/// Flutter code sample for Form

// This example shows a [Form] with one [TextFormField] to enter an email
// address and an [ElevatedButton] to submit the form. A [GlobalKey] is used here
// to identify the [Form] and validate input.
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/widgets/form.png)

import 'dart:io';

import 'package:file_picker/file_picker.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
//import 'package:kids_learning_tool/Lessons/Nouns/name_list.dart';
import 'package:kids_learning_tool/Quiz/Matching/preview.dart';
import 'package:kids_learning_tool/Quiz/Matching/question.dart';

//void main() => runApp(const MyApp());

/// This is the main application widget.
class Matching extends StatelessWidget {
  //const NounForm({Key? key}) : super(key: key);

  static const String _title = 'Prepare a question';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        centerTitle: true,
      ),
      body: const MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedFiles = '';
  //String _audioFile = '';
  String dropdownCategory = 'Noun';
  String dropdownAnswer = 'A';
  String question = 'What do you see in the picture?';
  late Question ques;
  String? newImagePath;
  TextEditingController questionController = TextEditingController();
  TextEditingController meaning = TextEditingController();
  TextEditingController optionA = TextEditingController();
  TextEditingController optionB = TextEditingController();
  TextEditingController optionC = TextEditingController();
  TextEditingController optionD = TextEditingController();

  List<File> files = [];
  late File audio;
  String path = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);

        //we need to return a future
        return Future.value(false);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(250, 40, 250, 20),
        color: Colors.white.withOpacity(0.80),
        child: Align(
          alignment: const Alignment(0, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(children: <Widget>[
                  const Text("Select Category",
                      style: TextStyle(color: Colors.blue, fontSize: 18)),
                  const SizedBox(width: 15),
                  DropdownButton(
                    hint: const Text("Select Category"),
                    //isExpanded: true,

                    items: ['Noun', 'Verb', 'Task Scheduling', 'Colour']
                        .map((option) {
                      return DropdownMenuItem(
                        child: Text(option),
                        value: option,
                      );
                    }).toList(),
                    value: dropdownCategory, //asign the selected value
                    onChanged: (String? value) {
                      setState(() {
                        dropdownCategory =
                            value!; //on selection, selectedDropDownValue i sUpdated
                      });
                    },
                  ),
                ]),
                const SizedBox(height: 10),
                OutlinedButton(
                    onPressed: () {
                      _openFileExplorer();
                    },
                    child: const Text(
                      'Select an Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                Text(_selectedFiles),
                const SizedBox(height: 10),
                TextFormField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    hintText: 'What do you see in the picture?',
                    labelText: 'Question',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontFamily: 'AvenirLight'),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: optionA,
                        decoration: const InputDecoration(
                          hintText: 'Option A',
                          labelText: 'Option A',
                          labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontFamily: 'AvenirLight'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0)),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 40), //SizedBox(height: 10),
                    Flexible(
                      child: TextFormField(
                        controller: optionB,
                        decoration: const InputDecoration(
                          hintText: 'Option B',
                          labelText: 'Option B',
                          labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontFamily: 'AvenirLight'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0)),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: optionC,
                        decoration: const InputDecoration(
                          hintText: 'Option C',
                          labelText: 'Option C',
                          labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontFamily: 'AvenirLight'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0)),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 40), //SizedBox(height: 10),
                    Flexible(
                      child: TextFormField(
                        controller: optionD,
                        decoration: const InputDecoration(
                          hintText: 'Option D',
                          labelText: 'Option D',
                          labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontFamily: 'AvenirLight'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0)),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(children: <Widget>[
                  const Text("Correct Answer ",
                      style: TextStyle(color: Colors.blue, fontSize: 18)),
                  const SizedBox(width: 10),
                  DropdownButton(
                    //hint: const Text("Select Category"),
                    //isExpanded: true,

                    items: ['A', 'B', 'C', 'D'].map((option) {
                      return DropdownMenuItem(
                        child: Text(option),
                        value: option,
                      );
                    }).toList(),
                    value: dropdownAnswer, //asign the selected value
                    onChanged: (String? value) {
                      setState(() {
                        dropdownAnswer =
                            value!; //on selection, selectedDropDownValue i sUpdated
                      });
                    },
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50), elevation: 3),
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          createQuestion();
                          Navigator.of(context).push(
                            // With MaterialPageRoute, you can pass data between pages,
                            // but if you have a more complex app, you will quickly get lost.
                            MaterialPageRoute(
                              builder: (context) => Preview(ques),
                            ),
                          );
                          setState(() {
                            //dropdownCategory = 'Noun';
                            _selectedFiles = '';
                            //questionController.clear();
                            // optionA.clear();
                            // optionB.clear();
                            // optionC.clear();
                            // optionD.clear();
                            // dropdownAnswer = 'A';
                          });
                        }
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50), elevation: 3),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String selectedfile = _selectedFiles;
                          selectDirectory(selectedfile);
                          await assignToStudent();
                          setState(() {
                            _selectedFiles = '';
                            //newImagePath = '';
                          });
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectDirectory(String selectedFile) async {
    String dirName = dropdownCategory + '-' + selectedFile.split('.').first;
    Directory('D:/Sadi/FlutterProjects/kids_learning_tool/assets/Matching/' +
            dirName)
        .create()
        .then((Directory directory) {
      File(directory.path + '/' + dirName + '.txt').createSync(recursive: true);
      _write(File(directory.path + '/' + dirName + '.txt'));
      //print(directory.path);
      copyImage(directory.path);
    });
  }

  Future _write(File file) async {
    // for (Name name in assignToStudent) {
    //print(name.text + ' ' + name.meaning);
    try {
      await file.writeAsString(
          dropdownCategory +
              '; ' +
              newImagePath! +
              '; ' +
              questionController.text +
              '; ' +
              optionA.text +
              '; ' +
              optionB.text +
              '; ' +
              optionC.text +
              '; ' +
              optionD.text +
              '; ' +
              dropdownAnswer +
              '\n',
          mode: FileMode.append);
    } catch (e) {
      //print(e);
      throw Exception(e);
    }
  }

  Future<void> copyImage(String destination) async {
    newImagePath = destination + '/' + files[0].path.split('\\').last;
    await files[0].copy(newImagePath!);
  }

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      //PlatformFile file = result.files.first;

      setState(() {
        for (File file in files) {
          //print(file.path.split('/').last);
          _selectedFiles += file.path.split('\\').last;
        }
      });
    } else {
      // User canceled the picker
    }
  }

  void createQuestion() {
    List<String> options = [
      optionA.text,
      optionB.text,
      optionC.text,
      optionD.text
    ];
    ques = Question(
        dropdownCategory, files[0].path, question, options, dropdownAnswer);
  }

  void popup(String title, String content) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          contentText: content,
          onPositiveClick: () {
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.rotate3D,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  Future assignToStudent() async {
    if (_selectedFiles == '') {
      //temporary if condition
      //alert popup
      //_showMaterialDialog();
    } else {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
      } else {
        selectedDirectory.replaceAll('\\', '/');
        //print('selected directory ' + selectedDirectory);
        File(selectedDirectory + '/Quiz/quiz.txt').createSync(recursive: true);
        await copyImage(selectedDirectory + '/Quiz');
        _write(File(selectedDirectory + '/Quiz/quiz.txt'));
      }
    }
  }
}
