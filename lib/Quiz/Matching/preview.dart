import 'dart:async';
import 'dart:io';
//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:kids_learning_tool/Quiz/Matching/question.dart';

class Preview extends StatefulWidget {
  final Question question;
  const Preview(this.question);

  @override
  State<Preview> createState() => PreviewState();
}

class PreviewState extends State<Preview> {
  @override
  Widget build(BuildContext context) {
    // Here you direct access using widget
    //return Text(widget.question);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Test: Matching'),
        centerTitle: true,
      ),
      body: MyStatefulWidget(widget.question),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  //const MyStatefulWidget({Key? key}) : super(key: key);
  final Question question;
  const MyStatefulWidget(this.question);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late Timer _timer;
  int _start = 0;
  List<bool> hasPressed = [false, false, false, false];
  //bool hasPressedB, hasPressedC, hasPressedD = false, false, false, false;
  List<bool> isCorrect = [false, false, false, false];
  bool hasAnswered = false;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
    });
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
      child: Container(
        padding: const EdgeInsets.fromLTRB(120, 30, 120, 0),
        color: Colors.white.withOpacity(0.80),
        child: Align(
            alignment: const Alignment(0, 0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _start = 0;
                    startTimer();
                  },
                  child: Text(
                    '$_start',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24)),
                ),
                // Container(
                //   decoration: const BoxDecoration(
                //       color: Colors.blueAccent, shape: BoxShape.circle),
                //   child: Text('$_start'),
                // ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    SizedBox(
                        height: 300,
                        width: 400,
                        child: Image.file(
                          File(widget.question.imagePath),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        )),
                    const SizedBox(width: 100),
                    Column(children: <Widget>[
                      Text('Q. ' + widget.question.ques,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () {
                                _timer.cancel();
                                if (!hasAnswered) {
                                  hasPressed[0] = true;
                                  hasAnswered = true;

                                  if (widget.question.correctAnswer == 'A') {
                                    setState(() {
                                      isCorrect[0] = true;
                                      popup('Congratulations',
                                          'Wooha!!!! You have given correct answer');
                                    });
                                  } else {
                                    popup('Wrong answer',
                                        'You have selected the wrong option');
                                    int index = widget.question.correctAnswer
                                            .codeUnits[0] -
                                        'A'.codeUnits[0];
                                    setState(() {
                                      isCorrect[index] = true;
                                      hasPressed[index] = true;
                                    });
                                  }
                                }
                              },
                              child: Text('A. ' + widget.question.options[0],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                  primary: hasPressed[0]
                                      ? (isCorrect[0]
                                          ? Colors.green[700]
                                          : Colors.red[700])
                                      : Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                            ),
                          ),
                          const SizedBox(width: 100),
                          SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () {
                                _timer.cancel();
                                if (!hasAnswered) {
                                  hasPressed[1] = true;
                                  hasAnswered = true;
                                  if (widget.question.correctAnswer == 'B') {
                                    setState(() {
                                      isCorrect[1] = true;
                                      popup('Congratulations',
                                          'Wooha!!!! You have given correct answer');
                                    });
                                  } else {
                                    popup('Wrong answer',
                                        'You have selected the wrong option');
                                    int index = widget.question.correctAnswer
                                            .codeUnits[0] -
                                        'A'.codeUnits[0];
                                    setState(() {
                                      isCorrect[index] = true;
                                      hasPressed[index] = true;
                                    });
                                  }
                                }
                              },
                              child: Text('B. ' + widget.question.options[1],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                  primary: hasPressed[1]
                                      ? (isCorrect[1]
                                          ? Colors.green[700]
                                          : Colors.red[700])
                                      : Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () {
                                _timer.cancel();
                                if (!hasAnswered) {
                                  hasPressed[2] = true;
                                  hasAnswered = true;
                                  if (widget.question.correctAnswer == 'C') {
                                    setState(() {
                                      isCorrect[2] = true;
                                      popup('Congratulations',
                                          'Wooha!!!! You have given correct answer');
                                    });
                                  } else {
                                    popup('Wrong answer',
                                        'You have selected the wrong option');
                                    int index = widget.question.correctAnswer
                                            .codeUnits[0] -
                                        'A'.codeUnits[0];
                                    setState(() {
                                      isCorrect[index] = true;
                                      hasPressed[index] = true;
                                    });
                                  }
                                }
                              },
                              child: Text('C. ' + widget.question.options[2],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                  primary: hasPressed[2]
                                      ? (isCorrect[2]
                                          ? Colors.green[700]
                                          : Colors.red[700])
                                      : Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                            ),
                          ),
                          const SizedBox(width: 100),
                          SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () {
                                _timer.cancel();
                                if (!hasAnswered) {
                                  hasPressed[3] = true;
                                  hasAnswered = true;
                                  if (widget.question.correctAnswer == 'D') {
                                    setState(() {
                                      isCorrect[3] = true;
                                      popup('Congratulations',
                                          'Wooha!!!! You have given correct answer');
                                    });
                                  } else {
                                    popup('Wrong answer',
                                        'You have selected the wrong option');
                                    int index = widget.question.correctAnswer
                                            .codeUnits[0] -
                                        'A'.codeUnits[0];
                                    setState(() {
                                      //isCorrect[3] = false;
                                      isCorrect[index] = true;
                                      hasPressed[index] = true;
                                    });
                                  }
                                }
                              },
                              child: Text('D. ' + widget.question.options[3],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                  primary: hasPressed[3]
                                      ? (isCorrect[3]
                                          ? Colors.green[700]
                                          : Colors.red[700])
                                      : Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
                //Text(widget.question.correctAnswer),
              ],
            )),
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
}

// import 'package:flutter/material.dart';
// import 'dart:async';

// void main(){
//   runApp(MaterialApp(home:Noun()));
// }

// class Noun extends StatefulWidget {
//   @override
//   State<Noun> createState() => _NounState();
// }

// class _NounState extends State<Noun> {

// late Timer _timer;
// int _start = 0;

// void startTimer() {

//   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

//         setState(() {
//           _start++;
//         });

//     });

// }

//   Widget build(BuildContext context) {
//    //startTimer();
//   return  Scaffold(
//     //startTimer(),
//     appBar: AppBar(title: const Text("Timer test")),
//     body: Column(
//       children: <Widget>[
//         ElevatedButton(
//           onPressed: () {
//             startTimer();
//           },
//           child: const Text("start"),
//         ),
//         Text("$_start"),
//         ElevatedButton(
//           onPressed: () {

//               _timer.cancel();

//           },
//           child: const Text("stop"),
//         ),
//       ],
//     ),
//   );
// }

// }
