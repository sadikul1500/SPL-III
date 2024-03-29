/// Flutter code sample for Form

// This example shows a [Form] with one [TextFormField] to enter an email
// address and an [ElevatedButton] to submit the form. A [GlobalKey] is used here
// to identify the [Form] and validate input.
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/widgets/form.png)

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Reward/reward_list_box.dart';

//void main() => runApp(const MyApp());

/// This is the main application widget.
class RewardForm extends StatelessWidget {
  //const NounForm({Key? key}) : super(key: key);

  static const String _title = 'পুরস্কার যোগ করন'; //'Add a Reward';

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

  String path = 'D:/Sadi/spl3/assets/Rewards';
  TextEditingController title = TextEditingController();

  late File file;
  String imagePath = '';
  String dropdownValue = 'Video';
  var items = ['Video', 'Image'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/reward');

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
                  controller: title,
                  decoration: const InputDecoration(
                    hintText: 'Enter a Title',
                    labelText: 'টাইটেল',
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
                      //'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // TextFormField(
                //   controller: meaning,
                //   decoration: const InputDecoration(
                //     hintText: 'Enter Meaning of the title',
                //     labelText: 'Meaning',
                //     labelStyle: TextStyle(
                //         color: Colors.black87,
                //         fontSize: 17,
                //         fontFamily: 'AvenirLight'),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Colors.blueAccent),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                //   ),
                //   validator: (String? value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter some text';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    DropdownButton(
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    dropdownValue == 'Image'
                        ? OutlinedButton(
                            onPressed: () {
                              _openFileExplorer();
                            },
                            child: const Text(
                              'ছবি নির্বাচন করুন', //'Select Image',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ))
                        : OutlinedButton(
                            onPressed: () {
                              _selectVideo(); //need to modify that
                            },
                            child: const Text(
                              'ভিডিও নির্বাচন করুন', //'Select Video',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ))
                  ],
                ),
                Text(_selectedFiles),
                const SizedBox(height: 10),

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
                          saveFile();
                          dropdownValue == 'Image'
                              ? createReward(
                                  path + '/' + file.path.split('\\').last, '')
                              : createReward(
                                  '',
                                  path + '/' + file.path.split('\\').last,
                                );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context),
                          );
                        }
                      },
                      child: const Text(
                        'সেভ করুন', //'Save',
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

  void _selectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'wmv', 'avi', 'mkv'],
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        _selectedFiles = file.path.split('\\').last;
      });
    } else {
      //user canceled it
    }
  }

  void _openFileExplorer() async {
    // images
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);

        _selectedFiles = file.path.split('\\').last;
        // }
      });
    } else {
      // User canceled the picker
    }
  }

  Future saveFile() async {
    await file.copy('$path/${file.path.split('\\').last}');
  }

  void createReward(String imagePath, String videoPath) {
    RewardList rewardList = RewardList();
    rewardList.addReward(title.text, imagePath, videoPath);
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('তথ্য'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text('সফলভাবে সেভ হয়েছে'),
          // "Saved Successfully"), //not checked whether really checked successfully or not
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              title.clear();
              // meaning.clear();
              _selectedFiles = '';
              // _audioFile = '';
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
