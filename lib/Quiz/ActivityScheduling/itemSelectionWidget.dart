import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Snapshot extends StatelessWidget {
  Function() bikolpoSetState;

  late List<bool> selected;
  List<File> selectedItems = [];
  List<File> files = [];
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  final ScrollController _selectedScrollController =
      ScrollController(initialScrollOffset: 50.0);

  Snapshot(this.files, {required this.bikolpoSetState}) {
    selected = List.filled(files.length, false, growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12.0),
            alignment: Alignment.center,
            height: 300,
            //width: double.infinity,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                //thickness: ,
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: files.length,
                  //physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.down,
                      onDismissed: (_) async {
                        try {
                          if (await files[index].exists()) {
                            await files[index].delete();
                          }
                        } catch (e) {
                          // Error in getting access to the file.
                        }
                        bikolpoSetState();
                        files.removeAt(index);
                        selected.removeAt(index);
                        //setState(() {
                        //print(files.length);

                        //print('a file removed');
                        //print(files.length);

                        //len -= 1;
                        //});
                      },
                      child:
                          buildListItem(//widget.files[index],selected[index],
                              index), //% files.length
                      background: Container(
                        color: Colors.red[300],
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Icon(Icons.delete,
                            color: Colors.black87, size: 48),
                      ),
                    );
                  },
                  separatorBuilder: ((context, index) =>
                      const SizedBox(width: 10)),

                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            alignment: Alignment.center,
            height: 200,
            child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: Scrollbar(
                    controller: _selectedScrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    interactive: true,
                    child: ReorderableListView.builder(
                        //key: ValueKey(DateTime.now()),
                        scrollController: _selectedScrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return Padding(
                            key: ValueKey(selectedItems[index]),
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: buildSelectedListItems(selectedItems[index]),
                          );
                        },
                        itemCount: selectedItems.length,
                        onReorder: (oldIndex, newIndex) {
                          final index =
                              newIndex > oldIndex ? newIndex - 1 : newIndex;
                          final item = selectedItems.removeAt(oldIndex);
                          selectedItems.insert(index, item);
                          bikolpoSetState();
                        }))),
          )
        ],
      ),
    );
  }

  Widget buildSelectedListItems(File imageFile) {
    return SizedBox(
        //key: ValueKey(imageFile),
        height: 200,
        child: Image.file(imageFile, fit: BoxFit.contain));
  }

  Widget buildListItem(int index) {
    //final image =
    return Column(
      children: <Widget>[
        SizedBox(
          height: 220,
          child: Image.file(
            files[index],
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          //width:,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Checkbox(
                  value: selected[index],
                  onChanged: (value) {
                    selected[index] = !selected[index];
                    if (selected[index]) {
                      selectedItems.add(files[
                          index]); //assignToStudent.add(activities[_index]);
                    } else {
                      selectedItems.remove(files[
                          index]); //assignToStudent.remove(activities[_index]);
                    }
                    bikolpoSetState();
                  }),
              const SizedBox(width: 20),
              IconButton(
                  onPressed: () {
                    if (selectedItems.contains(files[index])) {
                      selectedItems.remove(files[index]);
                    }
                    files.removeAt(index);
                    selected.removeAt(index);
                  },
                  tooltip: 'আইটেমটি মুছে দিন ',//'Remove this item',
                  icon: const Icon(Icons.delete_forever_rounded))
            ],
          ),
        )
      ],
    );

    //return const Text('');
  }
}
