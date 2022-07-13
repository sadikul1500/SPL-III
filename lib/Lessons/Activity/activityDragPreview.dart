import 'package:flutter/material.dart';

class ItemModel {
  //same as Quiz/DragDrop/item_model.dart
  String value;
  bool accepting;
  ItemModel(this.value, {this.accepting = false});
}

class ActivityDrag extends StatefulWidget {
  final List<ItemModel> items;
  //final List<ItemModel> items2;
  final String question;
  const ActivityDrag(this.items, this.question); //this.items2,
  @override
  State<ActivityDrag> createState() => _ActivityDragState();
}

class _ActivityDragState extends State<ActivityDrag> {
  @override
  initState() {
    widget.items.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height,
          width: 400,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
          child: Wrap(),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height,
          width: 400,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
          child: Wrap(),
        )
      ],
    ));
  }
}
