//https://pastebin.com/ZSgj4LU3
//working version.... edit here....
//screenshot package didn't work....
//trying with RenderRepaintBoundary... it shws wrong... couldn't even write and run code....
//snapShot...............
//list items in a LIST.........
//import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Activity/activity_list_box.dart';
import 'package:kids_learning_tool/Lessons/Activity/activity_search_bar.dart';
import 'package:kids_learning_tool/Lessons/Activity/showScreenshot.dart';
import 'package:kids_learning_tool/Model/activity_list.dart';
//import 'package:screenshot/screenshot.dart';

class Activity extends StatefulWidget {
  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  ActivityList activityList = ActivityList();
  late List<ActivityItem> activities;
  List<ActivityItem> assignToStudent = [];
  int _index = 0;
  late Player videoPlayer;
  late int len;

  int activateIndex = 0;

  List<Media> medias = <Media>[];
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  VideoDimensions videoDimensions = const VideoDimensions(0, 0);
  List<File> files = []; // screenshot files.......

  final snapShotDirectory = 'D:/Sadi/spl3/assets/ActivitySnapShots/';

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);

  _ActivityState() {
    _index = 0;

    videoPlayer = Player(
      id: 0,
      //videoDimensions: VideoDimensions(640, 360),
      registerTexture: false,
    );
  }

  @override
  initState() {
    activities = activityList.getList();
    len = activities.length;
    createPlaylist();
    //_activityCard();

    super.initState();

    listenStreams();
  }

  void listenStreams() {
    if (mounted) {
      videoPlayer.currentStream.listen((current) {
        this.current = current;
      });
      videoPlayer.positionStream.listen((position) {
        this.position = position;
      });
      videoPlayer.playbackStream.listen((playback) {
        this.playback = playback;
      });
      videoPlayer.generalStream.listen((general) {
        general = general;
      });
      videoPlayer.videoDimensionsStream.listen((videoDimensions) {
        videoDimensions = videoDimensions;
      });
      videoPlayer.bufferingProgressStream.listen(
        (bufferingProgress) {
          bufferingProgress = bufferingProgress;
        },
      );
      videoPlayer.errorStream.listen((event) {
        throw Error(); //'libvlc error.'
      });
      //devices = Devices.all;
      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      videoPlayer.setEqualizer(equalizer);
      videoPlayer.open(Playlist(medias: medias), autoStart: false);
    }
  }

  @override
  void dispose() {
    videoPlayer.dispose();
    super.dispose();
  }

  void createPlaylist() {
    for (ActivityItem activity in activities) {
      medias.add(Media.file(File(activity.video)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        stop();
        setState(() {});

        Navigator.pop(context);

        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Activity',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  stop();
                  setState(() {});
                  var result = await showSearch<String>(
                    context: context,
                    delegate: ActivitySearch(activities),
                  );
                  setState(() {
                    _index = max(
                        0,
                        activities
                            .indexWhere((element) => element.text == result));
                  });
                },
                icon: const SafeArea(child: Icon(Icons.search_sharp)))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              activities.isEmpty
                  ? const SizedBox(
                      height: 400,
                      child: Center(
                        child: Text(
                          'No Data Found!!!',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                        side:
                            const BorderSide(color: Colors.white70, width: .1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      height: 420,
                                      width: 620,
                                      child: NativeVideo(
                                        player: videoPlayer,
                                        width: 620, //640,
                                        height: 420, //360,
                                        volumeThumbColor: Colors.blue,
                                        volumeActiveColor: Colors.blue,
                                        showControls: true, //!isPhone
                                        //fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                                rightSidePanel(activities.elementAt(_index))
                              ])),
                    ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      stop();

                      setState(() {
                        try {
                          _index = (_index - 1) % len;
                          //files.clear();
                        } catch (e) {
                          //print(e);
                        }
                      });
                    },
                    label: const Text(
                      'Prev',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    icon: const Icon(
                      Icons.navigate_before,
                    ),
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      minimumSize: const Size(100, 42),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.screenshot_monitor),
                    label: const Text(
                      'Take a screenshot',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () async {
                      if (playback.isPlaying) {
                        videoPlayer.pause();
                      }
                      await takeScreenShot(); //just take a screenshot
                      // .then((_) {
                      //   //print(files);
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               ShowCapturedWidget(files: files)));
                      // });
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      minimumSize: const Size(100, 42),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      stop();
                      setState(() {
                        try {
                          _index = (_index + 1) % len;
                          //files.clear();
                        } catch (e) {
                          //print(e);
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const <Widget>[
                        Text('Next',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.navigate_next_rounded),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      minimumSize: const Size(100, 42),
                    ),
                  ),
                ],
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
                stop();
                teachStudent();
              },
              icon: const Icon(Icons.add),
              label: const Text('Assign to student',
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
            const Spacer(),
            FloatingActionButton.extended(
              heroTag: 'btn2',
              onPressed: () {
                stop();

                Navigator.of(context)
                    .pushNamed('/activityForm')
                    .then((value) => setState(() {}));
              },
              icon: const Icon(Icons.add),
              label: const Text('Add an Activity',
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  takeScreenShot() async {
    Directory dir =
        Directory(snapShotDirectory + '/' + activities[_index].text);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final now = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$now.png';
    videoPlayer.takeSnapshot(File(dir.path + '/$name'), 600, 400);

    //await listFiles(dir);
  }

  makeAquiz() async {
    Directory dir =
        Directory(snapShotDirectory + '/' + activities[_index].text);
    if (!await dir.exists()) {
      _showMaterialDialog('No screenshot found',
          'Take screenshots before making questions'); //show a pop up box....//await dir.create(recursive: true);
    } else {
      await listFiles(dir).then((_) {
        //print(files);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowCapturedWidget(files: files)));
      });
    }
  }

  Future<void> listFiles(Directory dir) async {
    //var dir = Directory('tmp');
    files.clear();
    //print('called files clear');
    try {
      var dirList = dir.list();
      await for (final FileSystemEntity f in dirList) {
        if (f is File) {
          files.add(f); //print('Found file ${f.path}');
        } //else if (f is Directory) {
        //print('Found dir ${f.path}');
        //}
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  // showCapturedWidget() {
  //   //BuildContext context
  //   //var len = files.length;
  //   return showDialog(
  //     useSafeArea: true,
  //     context: context,
  //     builder: (context) => Scaffold(
  //       appBar: AppBar(
  //         title: const Text("Captured snapshots"),
  //       ),
  //       body: Container(
  //         padding: const EdgeInsets.all(12.0),
  //         alignment: Alignment.center,
  //         height: 250,
  //         //width: double.infinity,
  //         child: ScrollConfiguration(
  //           behavior: ScrollConfiguration.of(context).copyWith(
  //             dragDevices: {
  //               PointerDeviceKind.touch,
  //               PointerDeviceKind.mouse,
  //             },
  //           ),
  //           child: Scrollbar(
  //             controller: _scrollController,
  //             thumbVisibility: true,
  //             trackVisibility: true,
  //             interactive: true,
  //             //thickness: ,
  //             child: ListView.separated(
  //               controller: _scrollController,
  //               itemCount: files.length,
  //               //physics: const AlwaysScrollableScrollPhysics(),
  //               itemBuilder: (BuildContext context, index) {
  //                 return Dismissible(
  //                   key: UniqueKey(),
  //                   direction: DismissDirection.down,
  //                   onDismissed: (_) async {
  //                     try {
  //                       if (await files[index].exists()) {
  //                         await files[index].delete();
  //                       }
  //                     } catch (e) {
  //                       // Error in getting access to the file.
  //                     }
  //                     setState(() {
  //                       //print(files.length);
  //                       files.removeAt(index);
  //                       //print('a file removed');
  //                       //print(files.length);

  //                       //len -= 1;
  //                     });
  //                   },
  //                   child: buildListItem(files[index]), //% files.length
  //                   background: Container(
  //                     color: Colors.red[300],
  //                     alignment: Alignment.center,
  //                     margin: const EdgeInsets.symmetric(horizontal: 15),
  //                     child: const Icon(Icons.delete,
  //                         color: Colors.black87, size: 48),
  //                   ),
  //                 );
  //               },
  //               separatorBuilder: ((context, index) =>
  //                   const SizedBox(width: 10)),

  //               scrollDirection: Axis.horizontal,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildListItem(File imageFile) {
    return SizedBox(
        height: 250,
        child: Image.file(
          imageFile,
          fit: BoxFit.contain,
        ));

    //return const Text('');
  }

  Future stop() async {
    videoPlayer.stop();
  }

  Widget activityVideoWidgetCard() {
    ActivityItem activity = activities.elementAt(_index);

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: .1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const SizedBox(height: 15),
                    getVideoCard(),
                    const SizedBox(height: 15),
                  ],
                ),
                rightSidePanel(activity)
              ])),
    );
  }

  Widget getVideoCard() {
    return SizedBox(
      height: 420,
      width: 620,
      child: NativeVideo(
        player: videoPlayer,
        width: 620, //640,
        height: 420, //360,
        volumeThumbColor: Colors.blue,
        volumeActiveColor: Colors.blue,
        showControls: true, //!isPhone
        //fit: BoxFit.contain,
      ),
    );
  }

  Widget rightSidePanel(ActivityItem activity) {
    return SizedBox(
      width: 500,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Checkbox(
                  value: activity.isSelected,
                  onChanged: (value) {
                    setState(() {
                      activity.isSelected = !activity.isSelected;
                      if (activity.isSelected) {
                        assignToStudent.add(activities[_index]);
                      } else {
                        assignToStudent.remove(activities[_index]);
                      }
                    });
                  }),
              IconButton(
                  onPressed: () {
                    setState(() {
                      activityList.removeItem(activity);
                    });
                  },
                  tooltip: 'Remove this item',
                  icon: const Icon(Icons.delete_forever_rounded)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Card(
                    color: Colors.white70,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const <Widget>[
                          Text(
                            'Title: ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Meaning:',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Card(
                    //margin: const EdgeInsets.all(122.0),
                    color: Colors.blue[400],
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            activity.text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            activity.meaning,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    makeAquiz(); //show captured widget
                  },
                  child: const Text('Make a quiz'))
            ],
          )
        ],
      ),
    );
  }

  Future teachStudent() async {
    if (assignToStudent.isEmpty) {
      //alert popup
      _showMaterialDialog('No item was selected',
          'Please select at least one item before assigning');
    } else {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
      } else {
        selectedDirectory.replaceAll('\\', '/');

        File(selectedDirectory + '/Activity/activity.txt')
            .createSync(recursive: true);
        _write(File(selectedDirectory + '/Activity/activity.txt'));

        copyVideo(selectedDirectory + '/Activity');
      }
    }
  }

  Future<void> copyVideo(String destination) async {
    for (ActivityItem activity in assignToStudent) {
      if (activity.video.isNotEmpty) {
        File file = File(activity.video);
        await file.copy(destination + '/${file.path.split('/').last}');
      }
    }
  }

  Future _write(File file) async {
    for (ActivityItem activity in assignToStudent) {
      await file.writeAsString(
          activity.text +
              '; ' +
              activity.meaning +
              '; ' +
              activity.video +
              '\n',
          mode: FileMode.append);
    }
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  void _showMaterialDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: const Text('Close')),
            ],
          );
        });
  }
}
