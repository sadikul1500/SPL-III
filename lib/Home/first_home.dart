import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Graph/log_file_selection.dart';
import 'package:kids_learning_tool/Home/home.dart';

class FirstHome extends StatefulWidget {
  @override
  State<FirstHome> createState() => _FirstHomeState();
}

class _FirstHomeState extends State<FirstHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'অটিস্টিক শিশুদের জন্য শিখন টুল'), //Learning Tool for Autistic Children
        backgroundColor: Colors.amberAccent[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300, minWidth: 400),
          child: Card(
            color: Colors.grey[500],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.book_rounded),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 60),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    label: const Text('পাঠদান', //Lesson
                        style: TextStyle(
                          fontSize: 24,
                        )),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.quiz_rounded),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 60), elevation: 3),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/quiz')
                          .then((value) => setState(() {}));
                    },
                    label: const Text(
                      'কুইজ পরীক্ষা ', //'Quiz',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.bar_chart_rounded),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 60), elevation: 3),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GraphHomePage()));
                    },
                    label: const Text(
                      'পারফর্ম্যান্স গ্রাফ', //'Performance Graph',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       minimumSize: const Size(300, 60), elevation: 3),
                  //   onPressed: () {
                  //     Navigator.of(context)
                  //         .pushNamed('/activity')
                  //         .then((value) => setState(() {}));
                  //   },
                  //   child: const Text(
                  //     'Activity',
                  //     style: TextStyle(
                  //       fontSize: 24,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:
          // Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // children: [
          //   const SizedBox(width: 25.0),
          //   FloatingActionButton.extended(
          //     heroTag: 'quiz',
          //     onPressed: () {
          //       Navigator.of(context)
          //           .pushNamed('/quiz')
          //           .then((value) => setState(() {}));
          //     },
          //     icon: const Icon(Icons.quiz),
          //     label: const Text('Quiz Test',
          //         style: TextStyle(
          //           fontSize: 18,
          //         )),
          //   ),
          //   // const SizedBox(
          //   //   height: 15,
          //   // ),
          //   const Spacer(),
          FloatingActionButton.extended(
        heroTag: 'exit',
        onPressed: () {
          exit(0);
        },

        label: const Text('প্রস্থান', //'Exit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.close),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // ],
      // ),
    );
  }
}
