/// Flutter code sample for Form

// This example shows a [Form] with one [TextFormField] to enter an email
// address and an [ElevatedButton] to submit the form. A [GlobalKey] is used here
// to identify the [Form] and validate input.
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/widgets/form.png)

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Verb/verb_list_db.dart';

class VerbForm extends StatelessWidget {
  static const String _title = 'ক্রিয়া যোগ করন'; //'Add a Verb';

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
  String audioPath = 'D:/Sadi/spl3/assets/Audios';
  //'D:/Sadi/FlutterProjects/kids_learning_tool_v2/assets/Audios';
  TextEditingController verb = TextEditingController();
  TextEditingController meaning = TextEditingController();

  List<File> files = [];
  late File audio;
  String path = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/verb');

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
              children: <Widget>[
                TextFormField(
                  controller: verb,
                  decoration: const InputDecoration(
                    hintText: 'Enter a Verb',
                    labelText: 'ইংরেজিতে',
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
                      return 'কিছু টেক্সট লিখুন';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: meaning,
                  decoration: const InputDecoration(
                    hintText:
                        'বাংলায় ক্রিয়া লিখুন যেমন : বই পড়া', //'Enter Meaning of the verb',
                    labelText: 'বাংলায়',
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
                      return 'কিছু টেক্সট লিখুন';
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
                      'ছবি নির্বাচন করুন',
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
                      'অডিও নির্বাচন করুন',
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
                        if (_formKey.currentState!.validate()) {
                          // Process data.
                          saveImage();

                          createVerb(
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
                        }
                      },
                      child: const Text(
                        'সেভ করুন', //Save
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

      setState(() {
        for (File file in files) {
          _selectedFiles += file.path.split('\\').last + ', ';
        }
      });
    } else {
      // User canceled the picker
    }
  }

  Future saveImage() async {
    path = 'D:/Sadi/spl3/assets/verb/${verb.text}';

    final newDir = await Directory(path).create(recursive: true);

    for (File file in files) {
      await file.copy('${newDir.path}/${file.path.split('\\').last}');
    }
    await audio.copy('$audioPath/${audio.path.split('\\').last}');
  }

  void createVerb(String dir, String audio) {
    VerbList verbList = VerbList();
    verbList.addVerb(verb.text, meaning.text, dir, audio);
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('তথ্য'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("সফলভাবে সেভ হয়েছে"), //Saved Successfully
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              verb.clear();
              meaning.clear();
              _selectedFiles = '';
              _audioFile = '';
            });
            Navigator.of(context).pop();
          },
          //color: Theme.of(context).primaryColor,
          child: const Text('ঠিক আছে'),
        ),
      ],
    );
  }
}
