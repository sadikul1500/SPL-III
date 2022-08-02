import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Activity/activity_new.dart';
import 'package:kids_learning_tool/Quiz/ActivityScheduling/showScrnShots.dart';

class ActivityOptions extends StatefulWidget {
  @override
  State<ActivityOptions> createState() => _ActivityOptionsState();
}

class _ActivityOptionsState extends State<ActivityOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Activity scheduling test'),
          centerTitle: true,
        ),
        body: Center(
            child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(320, 55)),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(20))),
                  onPressed: () {
                    Navigator.of(context).push(
                      // With MaterialPageRoute, you can pass data between pages,
                      // but if you have a more complex app, you will quickly get lost.
                      MaterialPageRoute(
                        builder: (context) => ShowActivityScreenShots(),
                      ),
                    );
                  },
                  child: const Text(
                    'Choose from saved items',
                    style: TextStyle(fontSize: 24),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(320, 55)),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(20))),
                  onPressed: () {
                    Navigator.of(context).push(
                      // With MaterialPageRoute, you can pass data between pages,
                      // but if you have a more complex app, you will quickly get lost.
                      MaterialPageRoute(
                        builder: (context) => Activity(),
                      ),
                    );
                  },
                  child: const Text('Create a new question',
                      style: TextStyle(fontSize: 24)))
            ],
          ),
        )));
  }
}
