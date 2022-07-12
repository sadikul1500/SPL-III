import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ShowCapturedWidget extends StatefulWidget {
  final List<File> files;
  const ShowCapturedWidget({Key? key, required this.files}) : super(key: key);
  @override
  State<ShowCapturedWidget> createState() => _ShowCapturedWidgetState();
}

class _ShowCapturedWidgetState extends State<ShowCapturedWidget> {
  //List<File> files = [];
  late List<bool> selected;
  List<File> selectedItems = [];
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  final ScrollController _selectedScrollController =
      ScrollController(initialScrollOffset: 50.0);
  _ShowCapturedWidgetState() {
    // files = widget.files;
  }
  @override
  void initState() {
    selected = List.filled(widget.files.length, false, growable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Captured Widget'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              height: 330,
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
                    itemCount: widget.files.length,
                    //physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.down,
                        onDismissed: (_) async {
                          try {
                            if (await widget.files[index].exists()) {
                              await widget.files[index].delete();
                            }
                          } catch (e) {
                            // Error in getting access to the file.
                          }
                          setState(() {
                            //print(files.length);
                            widget.files.removeAt(index);
                            selected.removeAt(index);
                            //print('a file removed');
                            //print(files.length);

                            //len -= 1;
                          });
                        },
                        child: buildListItem(widget.files[index],
                            selected[index], index), //% files.length
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
                            return buildSelectedListItems(selectedItems[index]);
                          },
                          itemCount: selectedItems.length,
                          onReorder: (oldIndex, newIndex) => setState(() {
                                final index = newIndex > oldIndex
                                    ? newIndex - 1
                                    : newIndex;
                                final item = selectedItems.removeAt(oldIndex);
                                selectedItems.insert(index, item);
                              }))
                      // ListView.separated(
                      //   controller: _selectedScrollController,
                      //   itemCount: selectedItems.length,
                      //   itemBuilder: (_, index) {
                      //     return buildSelectedListItems(selectedItems[index]);
                      //   },
                      //   separatorBuilder: ((context, index) =>
                      //       const SizedBox(width: 10)),
                      //   scrollDirection: Axis.horizontal,
                      // )
                      )),
            )
          ],
        ));
  }

  Widget buildSelectedListItems(File imageFile) {
    return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        key: ValueKey(imageFile),
        title: SizedBox(
            height: 200, child: Image.file(imageFile, fit: BoxFit.contain)));
    // return SizedBox(
    //     height: 200, child: Image.file(imageFile, fit: BoxFit.contain));
  }

  Widget buildListItem(File imageFile, bool isSelected, int index) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 250,
          child: Image.file(
            imageFile,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      isSelected = !isSelected;
                      if (isSelected) {
                        selectedItems.add(
                            imageFile); //assignToStudent.add(activities[_index]);
                      } else {
                        selectedItems.remove(
                            imageFile); //assignToStudent.remove(activities[_index]);
                      }
                    });
                  }),
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.files.removeAt(index);
                      selected.removeAt(index);
                    });
                  },
                  tooltip: 'Remove this item',
                  icon: const Icon(Icons.delete_forever_rounded))
            ],
          ),
        )
      ],
    );

    //return const Text('');
  }
}
