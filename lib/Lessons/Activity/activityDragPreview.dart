import 'dart:io';

import 'package:flutter/material.dart';

class ItemModel {
  //same as Quiz/DragDrop/item_model.dart
  String value;
  bool accepting; //on will accept
  bool isSuccessful;
  ItemModel(this.value, {this.accepting = false, this.isSuccessful = false});
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
      items.add(ItemModel(widget.files[i].path + ' space ' + i.toString()));
    }
    //print(items[0].value);
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
            constraints: const BoxConstraints(minHeight: 400),
            padding: const EdgeInsets.all(5),
            //height: MediaQuery.of(context).size.height,
            width: 400,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: items.map((item) {
                return Draggable<ItemModel>(
                  data: item,
                  childWhenDragging: Container(
                      alignment: Alignment.center,
                      height: 145,
                      width: 145,
                      child: Image.file(
                        File(item.value.split(' space ').first),
                        fit: BoxFit.contain,
                        //filterQuality: FilterQuality.high,
                        colorBlendMode: BlendMode.darken,
                      )),
                  feedback: SizedBox(
                      //child that I drop....
                      height: 170,
                      width: 170,
                      child: Image.file(
                        File(item.value.split(' space ').first),
                        fit: BoxFit.contain,
                        //filterQuality: FilterQuality.high,
                      )),
                  child: Container(
                      height: 150,
                      width: 150,
                      alignment: Alignment.center,
                      child: Image.file(
                        File(item.value.split(' space ').first),
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      )),
                );
              }).toList(),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 400),
            padding: const EdgeInsets.all(5),
            //height: MediaQuery.of(context).size.height,
            width: 400,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: values.map((item) {
                return DragTarget<ItemModel>(
                  onAccept: (receivedItem) async {
                    if (item.value ==
                        receivedItem.value.split(' space ').last) {
                      setState(() {
                        // playConfetti = true;
                        // _smallConfettiController.play();
                        // _confettiRightController.play();
                        // _confettiLeftController.play();

                        items.remove(receivedItem);
                        // widget.items2.remove(item);
                        //dispose();
                        // score += 1;
                        //item = receivedItem;
                        item.accepting = false;
                        item.isSuccessful = true;
                        item.value = receivedItem.value;
                        print('....matched......'); //hot reload.....
                      });

                      //await audioPlay();
                    } else {
                      setState(() {
                        //score -= 1;
                        print('*' +
                            item.value +
                            '*aaa*' +
                            receivedItem.value.split(' space ').last +
                            "*");
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
                    child: item.isSuccessful
                        ? Image.file(
                            File(item.value.split(' space ').first),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          )
                        : Text((int.parse(item.value) + 1).toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0)),
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
