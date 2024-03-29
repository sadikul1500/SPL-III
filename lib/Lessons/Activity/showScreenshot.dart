import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Activity/activityDragPreview.dart';

class ShowCapturedWidget extends StatefulWidget {
  final List<File> files;
  final String topic;
  const ShowCapturedWidget({Key? key, required this.files, required this.topic})
      : super(key: key);
  @override
  State<ShowCapturedWidget> createState() => _ShowCapturedWidgetState();
}

class _ShowCapturedWidgetState extends State<ShowCapturedWidget> {
  //List<File> files = [];
  late List<bool> selected;
  String topic = '';
  List<File> selectedItems = [];
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  final ScrollController _selectedScrollController =
      ScrollController(initialScrollOffset: 50.0);
  _ShowCapturedWidgetState() {
    // files = widget.files;
  }
  int counter = 0;
  @override
  void initState() {
    selected = List.filled(widget.files.length, false, growable: true);
    topic = widget.topic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('স্ক্রিনশট'), //'Captured Widget'
      ),
      body: SingleChildScrollView(
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
                              child:
                                  buildSelectedListItems(selectedItems[index]),
                            );
                          },
                          itemCount: selectedItems.length,
                          onReorder: (oldIndex, newIndex) => setState(() {
                                final index = newIndex > oldIndex
                                    ? newIndex - 1
                                    : newIndex;
                                final item = selectedItems.removeAt(oldIndex);
                                selectedItems.insert(index, item);
                              })))),
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          const SizedBox(width: 25.0),
          FloatingActionButton.extended(
            heroTag: 'btn1',
            onPressed: () {
              if (selectedItems.isEmpty) {
                showAlertDialog('কোনো আইটেম নির্বাচন করা হয়নি',//'No item selected',
                    'কমপক্ষে একটি আইটেম নির্বাচন করুন');//'Please select at least one item to preview');
                //show alert box
              } else {
                Navigator.of(context).push(
                  // With MaterialPageRoute, you can pass data between pages,
                  // but if you have a more complex app, you will quickly get lost.
                  MaterialPageRoute(
                    builder: (context) => ActivityDrag(selectedItems),
                  ),
                );
              }
              //stop();
              //teachStudent();
            },
            //icon: const Icon(Icons.add),
            label: const Text('দেখুন',//'Preview',
                style: TextStyle(
                  fontSize: 18,
                )),
          ),
          const Spacer(),
          FloatingActionButton.extended(
            heroTag: 'btn2',
            onPressed: () {
              if (selectedItems.isEmpty) {
                showAlertDialog('কোনো আইটেম নির্বাচন করা হয়নি',//'No item selected',
                    'কমপক্ষে একটি আইটেম নির্বাচন করুন');
                //show alert box
              } else {
                teachStudent();
                // Navigator.of(context).push(
                //   // With MaterialPageRoute, you can pass data between pages,
                //   // but if you have a more complex app, you will quickly get lost.
                //   MaterialPageRoute(
                //     builder: (context) => ActivityDrag(selectedItems),
                //   ),
                // );
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('শিক্ষার্থীকে এসাইন করুন', //Assign to Student',
                style: TextStyle(
                  fontSize: 18,
                )),
          ),
        ],
      ),
    );
  }

  Widget buildSelectedListItems(File imageFile) {
    // return ListTile(
    //     contentPadding:
    //         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //     key: ValueKey(imageFile),
    //     title: SizedBox(
    //         height: 200, child: Image.file(imageFile, fit: BoxFit.contain)));
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
            widget.files[index],
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
                    setState(() {
                      selected[index] = !selected[index];
                      if (selected[index]) {
                        if (counter >= 4) {
                          showAlertDialog('সর্বোচ্চ সীমা ৪',//'Maximum 4 items',
                              'সর্বোচ্চ ৪টি  আইটেম নির্বাচন করা যাবে');//'You can not select more than 4 items');
                        } else {
                          selectedItems.add(widget.files[
                              index]); //assignToStudent.add(activities[_index]);
                          counter += 1;
                        }
                      } else {
                        selectedItems.remove(widget.files[
                            index]); //assignToStudent.remove(activities[_index]);
                        counter -= 1;
                      }
                    });
                  }),
              const SizedBox(width: 20),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (selectedItems.contains(widget.files[index])) {
                        selectedItems.remove(widget.files[index]);
                      }
                      widget.files.removeAt(index);
                      selected.removeAt(index);
                    });
                  },
                  tooltip: 'আইটেমটি মুছে দিন',//'Remove this item',
                  icon: const Icon(Icons.delete_forever_rounded))
            ],
          ),
        )
      ],
    );

    //return const Text('');
  }

  Future teachStudent() async {
    String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath(dialogTitle: 'শিক্ষার্থীর ফোল্ডার নির্বাচন করুন');//'Choose student\'s folder');

    if (selectedDirectory == null) {
      // User canceled the picker
    } else {
      selectedDirectory.replaceAll('\\', '/');

      File(selectedDirectory +
              '/Quiz/Activity_Scheduling/activity_scheduling.txt')
          .createSync(recursive: true);
      _write(File(selectedDirectory +
          '/Quiz/Activity_Scheduling/activity_scheduling.txt'));
      copyImage(selectedDirectory + '/Quiz/Activity_Scheduling');
      //copyAudio(selectedDirectory + '/Association');
      //copyVideo(selectedDirectory + '/Association');
    }
  }

  Future _write(File file) async {
    for (File imageFile in selectedItems) {
      await file.writeAsString(
          imageFile.path.split('\\').last + '; ' + topic + '\n',
          mode: FileMode.append);
    }
  }

  Future<void> copyImage(String destination) async {
    final newDir = Directory(destination);
    for (File file in selectedItems) {
      await file.copy('${newDir.path}/${file.path.split('\\').last}');
    }
  }

  void showAlertDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ঠিক আছে')),
            ],
          );
        });
  }
}
