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
  Player videoPlayer = Player(
    id: 107,
    //videoDimensions: VideoDimensions(640, 360),
    registerTexture: false,
  );
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

  _ActivityState() {
    _index = 0;
    activities = activityList.getList();
    len = activities.length;
    // print(activities);
    // videoPlayer = Player(
    //   id: 0,
    //   //videoDimensions: VideoDimensions(640, 360),
    //   registerTexture: false,
    // );
  }

  @override
  initState() {
    super.initState();
    proxyInitState();
  }

  proxyInitState() {
    listenStreams();
    createPlaylist();
    //_activityCard();
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
    }
  }

  @override
  void dispose() {
    videoPlayer.dispose();
    super.dispose();
  }

  void createPlaylist() {
    // for (ActivityItem activity in activities) {
    //   medias.add(Media.file(File(activity.video)));
    // }
    // print('$_index ${activities[_index].video}');
    medias = [Media.file(File(activities[_index].video))];

    videoPlayer.open(Playlist(medias: medias), autoStart: false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // onWillPop: () {
      //   stop();
      //   setState(() {});

      //   Navigator.pop(context);

      //   return Future.value(true);
      // },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'কর্মধারা শিখন', //'Activity',
            // style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  videoPlayer.stop();
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            activities.isEmpty
                ? const SizedBox(
                    height: 400,
                    child: Center(
                      child: Text(
                        'কোনো ডাটা পাওয়া যায়নি !!!', //'No Data Found!!!',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  )
                : Card(
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
                              SizedBox(
                                width: 500,
                                height: 250,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Checkbox(
                                            value: activities
                                                .elementAt(_index)
                                                .isSelected,
                                            onChanged: (value) {
                                              activities
                                                      .elementAt(_index)
                                                      .isSelected =
                                                  !activities
                                                      .elementAt(_index)
                                                      .isSelected;
                                              if (activities
                                                  .elementAt(_index)
                                                  .isSelected) {
                                                assignToStudent
                                                    .add(activities[_index]);
                                              } else {
                                                assignToStudent
                                                    .remove(activities[_index]);
                                              }
                                              setState(() {
                                                //videoPlayer.playOrPause();
                                              });
                                            }),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                activityList.removeItem(
                                                    activities
                                                        .elementAt(_index));
                                              });
                                            },
                                            tooltip:
                                                'আইটেমটি মুছে দিন', //'Remove this item',
                                            icon: const Icon(
                                                Icons.delete_forever_rounded)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Card(
                                              color: Colors.white70,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: const <Widget>[
                                                    Text(
                                                      'ইংরেজিতে : ', //'Title: ',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      'বাংলায় : ', //'Meaning:',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Card(
                                              //margin: const EdgeInsets.all(122.0),
                                              color: Colors.blue[400],
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Text(
                                                      activities
                                                          .elementAt(_index)
                                                          .text,
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      activities
                                                          .elementAt(_index)
                                                          .meaning,
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.quiz_rounded),
                                          style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                      const Size(200, 40)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 10))),
                                          onPressed: () {
                                            makeAquiz(); //show captured widget
                                          },
                                          label: const Text(
                                            'কুইজ তৈরী করুন', //'Make a quiz',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          // style: ElevatedButton.styleFrom(
                                          //   alignment: Alignment.center,
                                          //   minimumSize: const Size(100, 42),
                                          // ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                              //rightSidePanel(activities.elementAt(_index))
                            ])),
                  ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    videoPlayer.stop();

                    setState(() {
                      // videoPlayer.previous();
                      try {
                        _index = (_index - 1) % len;
                        proxyInitState();
                        //files.clear();
                      } catch (e) {
                        //print(e);
                      }
                    });
                  },
                  label: const Text(
                    'পূর্ববর্তী', //'Prev',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
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
                    'স্ক্রিনশট নিন', //'Take a screenshot',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
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
                    videoPlayer.stop();
                    setState(() {
                      // videoPlayer.next();
                      try {
                        _index = (_index + 1) % len;
                        proxyInitState();
                        //files.clear();
                      } catch (e) {
                        //print(e);
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      Text('পরবর্তী', //'Next',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
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
        floatingActionButton: Row(
          children: [
            const SizedBox(width: 25.0),
            FloatingActionButton.extended(
              heroTag: 'btn1',
              onPressed: () {
                videoPlayer.stop();
                teachStudent();
              },
              icon: const Icon(Icons.add),
              label:
                  const Text('শিক্ষার্থীকে এসাইন করুন', //'Assign to student',
                      style: TextStyle(
                        fontSize: 18,
                      )),
            ),
            const Spacer(),
            FloatingActionButton.extended(
              heroTag: 'btn2',
              onPressed: () {
                videoPlayer.stop();

                Navigator.of(context)
                    .pushNamed('/activityForm')
                    .then((value) => setState(() {
                          proxyInitState();
                        }));
              },
              icon: const Icon(Icons.add),
              label: const Text('একটি কর্মধারা যোগ করুন', //'Add an Activity',
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
      _showMaterialDialog(
          'কোনো স্ক্রিনশট পাওয়া যায় নি', //'No screenshot found',
          'আগে স্ক্রিনশট নিন'); //'Take screenshots before making questions'); //show a pop up box....//await dir.create(recursive: true);
    } else {
      await listFiles(dir).then((_) {
        //print(files);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowCapturedWidget(
                    files: files, topic: activities[_index].text)));
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

  // Widget buildListItem(File imageFile) {
  //   return SizedBox(
  //       height: 250,
  //       child: Image.file(
  //         imageFile,
  //         fit: BoxFit.contain,
  //       ));

  //   //return const Text('');
  // }

  // Future stop() async {
  //   videoPlayer.stop();
  // }

  // Widget activityVideoWidgetCard() {
  //   ActivityItem activity = activities.elementAt(_index);

  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       side: const BorderSide(color: Colors.white70, width: .1),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: <Widget>[
  //                   const SizedBox(height: 15),
  //                   getVideoCard(),
  //                   const SizedBox(height: 15),
  //                 ],
  //               ),
  //               rightSidePanel(activity)
  //             ])),
  //   );
  // }

  // Widget getVideoCard() {
  //   return SizedBox(
  //     height: 420,
  //     width: 620,
  //     child: NativeVideo(
  //       player: videoPlayer,
  //       width: 620, //640,
  //       height: 420, //360,
  //       volumeThumbColor: Colors.blue,
  //       volumeActiveColor: Colors.blue,
  //       showControls: true, //!isPhone
  //       //fit: BoxFit.contain,
  //     ),
  //   );
  // }

  // Widget rightSidePanel(ActivityItem activity) {
  //   return SizedBox(
  //     width: 500,
  //     height: 250,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: <Widget>[
  //             Checkbox(
  //                 value: activity.isSelected,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     videoPlayer.playOrPause();
  //                     activity.isSelected = !activity.isSelected;
  //                     if (activity.isSelected) {
  //                       assignToStudent.add(activities[_index]);
  //                     } else {
  //                       assignToStudent.remove(activities[_index]);
  //                     }
  //                   });
  //                 }),
  //             IconButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     activityList.removeItem(activity);
  //                   });
  //                 },
  //                 tooltip: 'আইটেমটি মুছে দিন', //'Remove this item',
  //                 icon: const Icon(Icons.delete_forever_rounded)),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: <Widget>[
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: <Widget>[
  //                 Card(
  //                   color: Colors.white70,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: const <Widget>[
  //                         Text(
  //                           'ইংরেজিতে : ', //'Title: ',
  //                           style: TextStyle(
  //                             fontSize: 24,
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                         Text(
  //                           'বাংলা: ', //'Meaning:',
  //                           style: TextStyle(
  //                             fontSize: 24,
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: <Widget>[
  //                 Card(
  //                   //margin: const EdgeInsets.all(122.0),
  //                   color: Colors.blue[400],
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(18.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: <Widget>[
  //                         Text(
  //                           activity.text,
  //                           style: const TextStyle(
  //                             fontSize: 24,
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 5),
  //                         Text(
  //                           activity.meaning,
  //                           style: const TextStyle(
  //                             fontSize: 24,
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             ElevatedButton(
  //               style: ButtonStyle(
  //                   fixedSize: MaterialStateProperty.all(const Size(200, 40)),
  //                   padding: MaterialStateProperty.all(
  //                       const EdgeInsets.fromLTRB(0, 10, 0, 10))),
  //               onPressed: () {
  //                 makeAquiz(); //show captured widget
  //               },
  //               child: const Text(
  //                 'কুইজ তৈরী করুন', //'Make a quiz',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
  //               ),
  //               // style: ElevatedButton.styleFrom(
  //               //   alignment: Alignment.center,
  //               //   minimumSize: const Size(100, 42),
  //               // ),
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Future teachStudent() async {
    if (assignToStudent.isEmpty) {
      //alert popup
      _showMaterialDialog(
          'কোনো আইটেম নির্বাচন করা হয়নি ', //'No item was selected',
          'কমপক্ষে একটি আইটেম নির্বাচন করুন'); //'Please select at least one item before assigning');
    } else {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
          dialogTitle:
              'শিক্ষার্থীর ফোল্ডার নির্বাচন করুন'); //'Choose student\'s folder');

      if (selectedDirectory == null) {
        // User canceled the picker
      } else {
        selectedDirectory.replaceAll('\\', '/');

        File(selectedDirectory + '/Lesson/Activity/activity.txt')
            .createSync(recursive: true);
        _write(File(selectedDirectory + '/Lesson/Activity/activity.txt'));

        copyVideo(selectedDirectory + '/Lesson/Activity');
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
                  child: const Text('ঠিক আছে')),
            ],
          );
        });
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