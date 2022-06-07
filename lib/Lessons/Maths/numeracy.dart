import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Number extends StatefulWidget {
  @override
  _NumberState createState() => _NumberState();
}

class _NumberState extends State<Number> {
  int number = 1;
  int temp = 0;
  int maxi = 10;
  int mini = 1;
  List<String> numbers = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.amber[300],
      appBar: AppBar(
          centerTitle: true,
          title: const Text.rich(TextSpan(children: [
            TextSpan(
                text: 'Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ]))),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
          Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              for (int i = 0; i < (number / 3).ceil(); i++)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [..._getIcons()]),
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '$number',
                          style: TextStyle(
                            fontSize: 200,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue[700],
                          ))
                    ]),
                  ),
                ),
                Card(
                  //margin: const EdgeInsets.all(122.0),
                  color: Colors.blue[700],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: numbers[number - 1],
                            style: const TextStyle(
                              fontSize: 50,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ))
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                temp = 0;
                setState(() {
                  temp = 0;
                  if (number > mini) {
                    number -= 1;
                  }
                });
              },
              child: const Icon(
                Icons.navigate_before,
                size: 40,
              ),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                minimumSize: const Size(100, 42),
                primary: number == mini ? Colors.blue[100] : Colors.blue[600],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  temp = 0;
                  if (number < maxi) {
                    number += 1;
                  }
                });
              },
              child: const Icon(
                Icons.navigate_next,
                size: 40,
              ),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                minimumSize: const Size(100, 42),
                primary: number == maxi ? Colors.blue[100] : Colors.blue[600],
              ),
            ),
          ],
        )
      ]),
    );
  }

  List<Widget> _getIcons() {
    List<Widget> friendsTextFields = [];
    int x = 0;
    if (temp + 3 <= number) {
      x = 3;
      temp += 3;
      //print(temp);
    } else {
      x = number - temp;
      temp += x;
      //print(temp);
    }
    for (int i = 0; i < x; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Icon(
              number % 2 == 0
                  ? FontAwesomeIcons.seedling
                  : FontAwesomeIcons.solidLemon,
              color: Colors.green,
              size: 50,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }
}
