/// Flutter code sample for Form

// This example shows a [Form] with one [TextFormField] to enter an email
// address and an [ElevatedButton] to submit the form. A [GlobalKey] is used here
// to identify the [Form] and validate input.
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/widgets/form.png)

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Nouns/name_list.dart';

//void main() => runApp(const MyApp());

/// This is the main application widget.
class NounForm extends StatelessWidget {
  //const NounForm({Key? key}) : super(key: key);

  static const String _title = 'Add a Noun ';

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
  String _audioFile = '';
  String audioPath =
      'D:/Sadi/FlutterProjects/kids_learning_tool_v2/assets/Audios';
  TextEditingController noun = TextEditingController();
  TextEditingController meaning = TextEditingController();

  List<File> files = [];
  late File audio;
  String path = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // print(
        //     'Backbutton pressed (device or appbar button), do whatever you want.');

        //trigger leaving and use own data
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/noun');

        //we need to return a future
        return Future.value(false);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(250, 150, 250, 0),
        color: Colors.white.withOpacity(0.80),
        child: Align(
          alignment: const Alignment(0, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: noun,
                  decoration: const InputDecoration(
                    hintText: 'Enter a Noun',
                    labelText: 'Noun',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'AvenirLight'),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: meaning,
                  decoration: const InputDecoration(
                    hintText: 'Enter Meaning of the noun',
                    labelText: 'Meaning',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'AvenirLight'),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                    onPressed: () {
                      _openFileExplorer();
                    },
                    child: const Text(
                      'Select Images',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                Text(_selectedFiles),
                const SizedBox(height: 10),
                OutlinedButton(
                    onPressed: () {
                      _selectAudio();
                    },
                    child: const Text(
                      'Select Audio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                Text(_audioFile),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50), elevation: 3),
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          // Process data.
                          saveImage();
                          //saveAudio();
                          createNoun(
                              path,
                              audioPath +
                                  '/' +
                                  audio.path
                                      .split('\\')
                                      .last); //'$path/${audio.path.split('\\').last}'
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context),
                          );
                          //Navigator.pushNamed(context, '/home');
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null) {
      //File file = File(result.files.single.path);
      setState(() {
        audio = File(result.files.single.path!);
        _audioFile = result.files.single.path!.split('\\').last;
      });
    } else {
      //user canceled it
    }
  }

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      //PlatformFile file = result.files.first;

      setState(() {
        for (File file in files) {
          //print(file.path.split('/').last);
          _selectedFiles += file.path.split('\\').last + ', ';
          // print(file.bytes);
          // print(file.size);
          // print(file.extension);
          // print(file.path);
        }
      });
    } else {
      // User canceled the picker
    }
  }

  Future saveImage() async {
    path =
        'D:/Sadi/FlutterProjects/kids_learning_tool_v2/assets/nouns/${noun.text}';

    final newDir = await Directory(path).create(recursive: true);

    for (File file in files) {
      await file.copy('${newDir.path}/${file.path.split('\\').last}');
    }
    await audio.copy('$audioPath/${audio.path.split('\\').last}');
    //audio = File(audioPath + '/' + audio.path.split('\\').last);

    //createNoun(imagePath);
  }

  void createNoun(String dir, String audio) {
    NameList nameList = NameList();
    nameList.addNoun(noun.text, meaning.text, dir, audio);
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Info'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Saved Successfully"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              noun.clear();
              meaning.clear();
              _selectedFiles = '';
              _audioFile = '';
            });
            Navigator.of(context).pop();
          },
          //color: Theme.of(context).primaryColor,
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
