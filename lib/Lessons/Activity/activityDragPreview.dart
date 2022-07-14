import 'dart:io';

import 'package:flutter/material.dart';

class ItemModel {
  //same as Quiz/DragDrop/item_model.dart
  String value;
  bool accepting;
  ItemModel(this.value, {this.accepting = false});
}

class ActivityDrag extends StatefulWidget {
  final List<File> files;
  //List<ItemModel> values = [];
  //final List<ItemModel> items2;
  //final String question;
  const ActivityDrag(this.files); //this.items2, this.question
  @override
  State<ActivityDrag> createState() => _ActivityDragState();
}

class _ActivityDragState extends State<ActivityDrag> {
  List<ItemModel> values = []; //drag target
  List<ItemModel> items = []; //draggable
  @override
  initState() {
    final len = widget.files.length;
    //widget.items.shuffle();
    //var values = List<int>.generate(widget.items.length, (i) => i);
    for (int i = 0; i < len; i++) {
      values.add(ItemModel(i.toString()));
      items.add(ItemModel(widget.files[i].path + ' ' + i.toString()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Quiz'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height,
            width: 350,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: items.map((item) {
                return Draggable<ItemModel>(
                  data: item,
                  childWhenDragging: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.file(
                        File(item.value.split(' ').first),
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        //colorBlendMode: BlendMode.darken,
                      )),
                  feedback: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.file(
                        File(item.value.split(' ').first),
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      )),
                  child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.file(
                        File(item.value.split(' ').first),
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      )),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height,
            width: 350,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            child: Wrap(
              children: values.map((item) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(25, 10, 100, 8.0),
                  child: DragTarget<ItemModel>(
                    onAccept: (receivedItem) async {
                      if (item.value == receivedItem.value.split(' ').last) {
                        setState(() {
                          // playConfetti = true;
                          // _smallConfettiController.play();
                          // _confettiRightController.play();
                          // _confettiLeftController.play();

                          items.remove(receivedItem);
                          // widget.items2.remove(item);
                          //dispose();
                          // score += 1;
                          item = receivedItem;
                          item.accepting = false;
                        });

                        //await audioPlay();
                      } else {
                        setState(() {
                          //score -= 1;
                          item.accepting = false;
                          //playConfetti = false;
                        });
                      }
                    },
                    onLeave: (receivedItem) {
                      setState(() {
                        item.accepting = false;
                        //playConfetti = false;
                        //audioPlayer.stop();
                      });
                    },
                    onWillAccept: (receivedItem) {
                      setState(() {
                        item.accepting = true;
                        //playConfetti = false;
                      });
                      return true;
                    },
                    builder: (context, acceptedItem, rejectedItem) => Container(
                      color: item.accepting ? Colors.red : Colors.blue,
                      height: 150,
                      width: 150,
                      alignment: Alignment.center,
                      //margin: const EdgeInsets.all(8.0),
                      child: item.value.length > 4
                          ? Image.file(
                              File(item.value.split(' ').first),
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            )
                          : Text(item.value,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0)),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      )),
    );
  }
}
