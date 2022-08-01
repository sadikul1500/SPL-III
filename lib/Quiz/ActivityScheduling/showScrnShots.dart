import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Activity/activityDragPreview.dart';

class ShowActivityScreenShots extends StatefulWidget {
  @override
  State<ShowActivityScreenShots> createState() =>
      _ShowActivityScreenShotsState();
}

class _ShowActivityScreenShotsState extends State<ShowActivityScreenShots> {
  final Directory directory =
      Directory('D:/Sadi/spl3/assets/ActivitySnapShots');

  List<FileSystemEntity> _folders = [];
  int current_index = 0;

  List<FileSystemEntity> files = [];
  List<bool> selected = [];
  List<File> selectedItems = [];
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  final ScrollController _selectedScrollController =
      ScrollController(initialScrollOffset: 50.0);

  @override
  initState() {
    super.initState();
    listDirectories();
  }

  void listDirectories() async {
    _folders = directory.listSync(recursive: false, followLinks: false);
    print(_folders[current_index]);
    listFiles();
  }

  void listFiles() async {
    final dir = _folders[current_index].path;
    final directory = Directory(dir);
    files.clear();
    selected.clear();
    for (var file in directory.listSync(recursive: false, followLinks: false)) {
      if (file is File) {
        files.add(file);
      }
    }
    selected = List.filled(files.length, false, growable: true);
    for (var val in selected) {
      print(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    //listFiles();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity scheduling test'),
        centerTitle: true,
      ),
      body: _folders.isEmpty
          ? noDataFound('No Data Found')
          : files.isEmpty
              ? noDataFound('No screenshots found')
              : imagePreview(context),
      floatingActionButton: floatingActionBtn(context),
    );
  }

  Widget floatingActionBtn(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 25.0),
        FloatingActionButton.extended(
          heroTag: 'btn1',
          onPressed: () {
            if (selectedItems.isEmpty) {
              showAlertDialog('No item selected',
                  'Please select at least one item to preview');
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
          label: const Text('Preview',
              style: TextStyle(
                fontSize: 18,
              )),
        ),
        const Spacer(),
        FloatingActionButton.extended(
          heroTag: 'btn2',
          onPressed: () {
            if (selectedItems.isEmpty) {
              showAlertDialog('No item selected',
                  'Please select at least one item to assign');
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
          },
          icon: const Icon(Icons.add),
          label: const Text('Assign to Student',
              style: TextStyle(
                fontSize: 18,
              )),
        ),
      ],
    );
  }

  Widget noDataFound(String text) {
    return Center(child: Text(text));
  }

  Widget imagePreview(BuildContext context) {
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
                        setState(() {
                          //print(files.length);
                          files.removeAt(index);
                          selected.removeAt(index);
                          //print('called remove at index');
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
                            child: buildSelectedListItems(selectedItems[index]),
                          );
                        },
                        itemCount: selectedItems.length,
                        onReorder: (oldIndex, newIndex) => setState(() {
                              final index =
                                  newIndex > oldIndex ? newIndex - 1 : newIndex;
                              final item = selectedItems.removeAt(oldIndex);
                              selectedItems.insert(index, item);
                            })))),
          )
        ],
      ),
    );
  }

  Widget buildSelectedListItems(File imageFile) {
    return SizedBox(
        height: 200, child: Image.file(imageFile, fit: BoxFit.contain));
  }

  Widget buildListItem(int index) {
    //final image =
    return Column(
      children: <Widget>[
        SizedBox(
          height: 220,
          child: Image.file(
            File(files[index].path),
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
                      print("index of $index");
                      print(selected[index]);
                      if (selected[index]) {
                        selectedItems.add(File(files[index]
                            .path)); //assignToStudent.add(activities[_index]);
                      } else {
                        print('removed fom second container');
                        print(files[index].path);
                        print(selectedItems.length);
                        for (var val in selectedItems) {
                          print(val.path);
                        }
                        print(selectedItems[0]);
                        if (selectedItems.contains(File(files[index].path))) {
                          print('contains but won\'t get deleted');
                        } else {
                          print('not foud....');
                        }
                        if (selectedItems[0].path == files[index].path) {
                          print('trueeeeee');
                        }
                        selectedItems.remove(File(files[index].path));
                        print(selectedItems.length);
                        for (var val in selectedItems) {
                          print(val.path);
                        }
                      }
                    });
                  }),
              const SizedBox(width: 20),
              IconButton(
                  onPressed: () {
                    print('remove clicked');
                    setState(() {
                      if (selectedItems.contains(files[index])) {
                        selectedItems.remove(files[index]);
                      }
                      files.removeAt(index);
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

  Future teachStudent() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

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

  Future<void> copyImage(String destination) async {
    final newDir = Directory(destination);
    for (File file in selectedItems) {
      await file.copy('${newDir.path}/${file.path.split('\\').last}');
    }
  }

  Future _write(File file) async {
    for (File file in selectedItems) {
      await file.writeAsString(file.path.split('\\').last + '\n',
          mode: FileMode.append);
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
                  child: const Text('Close')),
            ],
          );
        });
  }
}







 //#directories[current_index].list().isEmpty
  // Widget noFileFound() {
  //   // listFiles().then((data) {
  //   //   if (files.isEmpty) {
  //   //     return const Center(child: Text('no Data Found'));
  //   //   } else {
  //   //     return const CircularProgressIndicator();
  //   //   }
  //   // });
  //   return const Text('hiii');
  //   // if(){
  //   //   return const Center(child: Text('no Data Found'));
  //   // }
  //   // return const Center(child: Text('no Data Found'));
  // } 