//input form
// ignore_for_file: use_function_type_syntax_for_parameters

import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'dart:ui';

//import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:kids_learning_tool/Quiz/DragDrop/drag.dart';
import 'package:kids_learning_tool/Quiz/DragDrop/item_model.dart';
import 'package:kids_learning_tool/Quiz/DragDrop/question.dart';

class DragForm extends StatelessWidget {
  static const String _title = 'Quiz: Drag & Drop';

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

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => DragFormState();
}

class DragFormState extends State<MyStatefulWidget> {
  List<String> friendsList = [];
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  late TextEditingController _questionController;
  late DragQuestion question;
  List<ItemModel> items1 = [];
  List<ItemModel> items2 = [];
  String ques =
      'Drag the object from left side and match them to the right side';

  String _selectedFile = '';
  List<File> files = [];
  List<String> values = [];
  List<String> valuesRight = [];
  bool showWidget = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _valueController = TextEditingController();
    _questionController = TextEditingController();
    _questionController.text =
        'Drag the object from left side and match them to the right side';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          //trigger leaving and use own data
          Navigator.pop(context);
          //we need to return a future
          return Future.value(false);
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Question:  ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18)),
                        SizedBox(
                          width: 500,
                          height: 25,
                          child: TextFormField(
                            controller: _questionController,
                            decoration: const InputDecoration(
                              hintText:
                                  'Drag the object from left side and match them to the right side',
                              //labelText: 'image',
                            ),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 30),
                  // name textfield
                  const Text(
                    'Add Draggable Objects',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                          const SizedBox(width: 5),
                          Text(
                              _selectedFile), //files.last.path.split('\\').last
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 200,
                            height: 25,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Enter value of the image',
                                //labelText: 'image',
                              ),
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return 'Please enter something';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          _addRemoveButton(true, 0),
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ..._getFriends(),
                  const SizedBox(
                    height: 20,
                  ),
                  //
                  //
                  //
                  //
                  //
                  //
                  // const Text(
                  //   'Add Drag Traget Objects',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w700,
                  //     fontSize: 20,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 32.0),
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         SizedBox(
                  //           width: 390,
                  //           height: 25,
                  //           child: TextFormField(
                  //             controller: _valueController,
                  //             decoration: const InputDecoration(
                  //                 hintText: 'Enter value to match'),
                  //             validator: (v) {
                  //               if (v!.trim().isEmpty) {
                  //                 return 'Please enter something';
                  //               }
                  //               return null;
                  //             },
                  //           ),
                  //         ),
                  //         const SizedBox(width: 20),
                  //         _addRemoveButtonAgain(true, 0),
                  //       ]),
                  // ),
                  // const SizedBox(height: 20),
                  // ..._getValuesRight(),
                  // const SizedBox(height: 20),
                  //
                  //
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          if (friendsList.isNotEmpty &&
                              values.isNotEmpty &&
                              valuesRight.isNotEmpty) {
                            createQuestion();
                            Navigator.of(context).push(
                              // With MaterialPageRoute, you can pass data between pages,
                              // but if you have a more complex app, you will quickly get lost.
                              MaterialPageRoute(
                                builder: (context) =>
                                    Drag(items1, items2, ques),
                              ),
                            );
                            setState(() {
                              _nameController.clear();
                              _valueController.clear();
                            });
                          }
                        },
                      ),
                      //const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50), elevation: 3),
                        onPressed: () async {
                          //if (_formKey.currentState!.validate()) {
                          await assignToStudent();
                          //}
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
        ));
  }
//
//
//

  Future _write(File file) async {
    List<String> filesStr = [];
    for (File file in files) {
      filesStr.add(file.path.split('\\').last);
    }
    question =
        DragQuestion(filesStr, values, valuesRight, _questionController.text);
    List<DragQuestion> questions = [question];

    try {
      questions //convert list data  to json
          .map(
            (question) => question.toJson(),
          )
          .toList();
      await file.writeAsString(json.encode(question), mode: FileMode.append);
    } catch (e) {
      //print(e);
      throw Exception(e);
    }
  }

  Future<void> copyImage(String destination) async {
    for (File file in files) {
      String newImagePath = destination + '/' + file.path.split('\\').last;
      await file.copy(newImagePath);
    }
  }

  Future assignToStudent() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
    } else {
      selectedDirectory.replaceAll('\\', '/');
      //print('selected directory ' + selectedDirectory);
      File(selectedDirectory + '/Drag/drag.json').createSync(recursive: true);

      await copyImage(selectedDirectory + '/Drag');
      await _write(File(selectedDirectory + '/Drag/drag.json'));
    }
  }

  void createQuestion() {
    //question = DragQuestion(files, values, valuesRight);
    for (int i = 0; i < values.length; i++) {
      ItemModel item = ItemModel(files[i].path + ' ' + values[i]);
      items1.add(item);
    }
    for (int i = 0; i < valuesRight.length; i++) {
      ItemModel item = ItemModel(valuesRight[i]);
      items2.add(item);
    }
    ques = _questionController.text;
  }
//
//
//

  Widget dragTarget() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        const Text('Called'),
        TextFormField(
          controller: _nameController,
          // onChanged: (v) => DragFormState.friendsList[widget.index] = v,
          decoration: const InputDecoration(
              hintText: 'Enter the exact value as the drag objects'),
          validator: (v) {
            if (v!.trim().isEmpty) return 'Please enter something';
            return null;
          },
        )
      ],
    );
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < friendsList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 360,
                child: Text(
                  friendsList[i],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                )), //FriendTextFields(i)
            const SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(false, i), //
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  List<Widget> _getValuesRight() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < valuesRight.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 360,
                child: Text(
                  valuesRight[i],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                )), //FriendTextFields(i)
            const SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButtonAgain(false, i), //
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          String value = _nameController.text.trim();
          values.add(value);
          valuesRight.add(value);
          friendsList.add(
              files.last.path.split('\\').last + ' ; ' + values.last); //0, ''

          // print(values.last);
          // print(friendsList.last);
          setState(() {
            _selectedFile = '';
            _nameController.clear();
          });
        } else {
          friendsList.removeAt(index);
          files.removeAt(index);
          values.removeAt(index);
          valuesRight.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _addRemoveButtonAgain(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          valuesRight.add(_valueController.text.trim());

          setState(() {
            _valueController.clear();
          });
        } else {
          valuesRight.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
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

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      files.add(File((result.files.single.path)!));
      setState(() {
        _selectedFile = files.last.path.split('\\').last;
      });
    } else {
      // User canceled the picker
    }
  }
}

// class FriendTextFields extends StatefulWidget {
//   final int index;
//   FriendTextFields(this.index);
//   @override
//   _FriendTextFieldsState createState() => _FriendTextFieldsState();
// }

// class _FriendTextFieldsState extends State<FriendTextFields> {
//   late TextEditingController _nameController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       _nameController.text = DragFormState.friendsList[widget.index] ?? '';
//     });

//     return TextFormField(
//       controller: _nameController,
//       onChanged: (v) => DragFormState.friendsList[widget.index] = v,
//       decoration: const InputDecoration(hintText: 'Enter your friend\'s name'),
//       validator: (v) {
//         if (v!.trim().isEmpty) return 'Please enter something';
//         return null;
//       },
//     );
//   }
// }

// FilePickerResult? result = await FilePicker.platform.pickFiles(
//   allowMultiple: false,
//   type: FileType.custom,
//   allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
// );

// if (result != null) {
//   files = result.paths.map((path) => File(path!)).toList();
//   //PlatformFile file = result.files.first;

//   setState(() {
//     for (File file in files) {
//       //print(file.path.split('/').last);
//       _selectedFiles += file.path.split('\\').last;
//     }
//   });
// } else {
//   // User canceled the picker
// }

// onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _formKey.currentState!.save();
//                         if(_selectedFile.isNotEmpty && _nameController.text.isNotEmpty){

//                         }
//                       }
//                     },
