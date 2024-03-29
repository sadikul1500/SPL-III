//currently video player is not supported by windows -- 25 ramadan
//working now --
//for now work with absolute path / getApplicationDocumentsDirectory() and save videos here

import 'dart:io';
//import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';

class Activity extends StatefulWidget {
  @override
  ActivityState createState() => ActivityState();
}

class ActivityState extends State<Activity> {
  Player player = Player(
    id: 0,
    //videoDimensions: VideoDimensions(640, 360),
    registerTexture: false,
  );
  MediaType mediaType = MediaType.file;
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  VideoDimensions videoDimensions = const VideoDimensions(0, 0);
  List<Media> medias = <Media>[];
  List<Device> devices = <Device>[];
  TextEditingController controller = TextEditingController();
  TextEditingController metasController = TextEditingController();
  double bufferingProgress = 0.0;
  Media? metasMedia;
  List<File> files = [];
  String _selectedFiles = '';

  @override
  void initState() {
    super.initState();
    if (mounted) {
      player.currentStream.listen((current) {
        setState(() => this.current = current);
      });
      player.positionStream.listen((position) {
        setState(() => this.position = position);
      });
      player.playbackStream.listen((playback) {
        setState(() => this.playback = playback);
      });
      player.generalStream.listen((general) {
        setState(() => general = general);
      });
      player.videoDimensionsStream.listen((videoDimensions) {
        setState(() => videoDimensions = videoDimensions);
      });
      player.bufferingProgressStream.listen(
        (bufferingProgress) {
          setState(() => bufferingProgress = bufferingProgress);
        },
      );
      player.errorStream.listen((event) {
        print('libvlc error.');
      });
      devices = Devices.all;
      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      player.setEqualizer(equalizer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //stop();
        setState(() {});

        Navigator.pop(context);

        return Future.value(true);
      },
      child: //MaterialApp(
          //home:
          Scaffold(
        appBar: AppBar(
          title: const Text('Activity'),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(4.0),
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Platform.isWindows?
                NativeVideo(
                  player: player,
                  width: 640,
                  height: 360,
                  volumeThumbColor: Colors.blue,
                  volumeActiveColor: Colors.blue,
                  showControls: true, //!isPhone
                  //fit: BoxFit.contain,
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                  const Text('Add New Video'),
                                  const Divider(
                                    height: 8.0,
                                    color: Colors.transparent,
                                  ),
                                  Row(
                                    children: [
                                      OutlinedButton(
                                          onPressed: () {
                                            _openFileExplorer();
                                          },
                                          child: const Text(
                                            'Select Videos',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )),
                                      const SizedBox(width: 10),
                                      Text(_selectedFiles),
                                    ],
                                  ),
                                  const Divider(
                                    height: 12.0,
                                  ),
                                  const Divider(
                                    height: 8.0,
                                    color: Colors.transparent,
                                  ),
                                  const Text('Playlist'),
                                ] +
                                medias
                                    .map(
                                      (media) => ListTile(
                                        title: Text(
                                          media.resource.split("/").last,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                medias.remove(media);
                                              });
                                            }, //,
                                            icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red)),
                                        // subtitle: Text(
                                        //   media.mediaType.toString(),
                                        //   style: const TextStyle(
                                        //     fontSize: 14.0,
                                        //   ),
                                        // ),
                                      ),
                                    )
                                    .toList() +
                                <Widget>[
                                  const Divider(
                                    height: 8.0,
                                    color: Colors.transparent,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => setState(
                                          () {
                                            player.open(
                                              Playlist(
                                                medias: medias,
                                                playlistMode: PlaylistMode
                                                    .single, //single/repeat/loop
                                              ),
                                            );
                                          },
                                        ),
                                        child: const Text(
                                          'Open into Player',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() => medias.clear());
                                        },
                                        child: const Text(
                                          'Clear the list',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //if (isTablet)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _controls(context, false), //isPhone
                      _playlist(context),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      //,
    );
  }

  Widget _controls(BuildContext context, bool isPhone) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(4.0),
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Playback controls.'),
            const Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => player.play(),
                  child: const Text(
                    'play',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => player.pause(),
                  child: const Text(
                    'pause',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => player.playOrPause(),
                  child: const Text(
                    'playOrPause',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => player.stop(),
                  child: const Text(
                    'stop',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => player.next(),
                  child: const Text(
                    'next',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => player.previous(),
                  child: const Text(
                    'previous',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 12.0,
              color: Colors.transparent,
            ),
            const Divider(
              height: 12.0,
            ),
            const Text('Volume control.'),
            const Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Slider(
              min: 0.0,
              max: 1.0,
              value: player.general.volume,
              onChanged: (volume) {
                player.setVolume(volume);
                setState(() {});
              },
            ),
            const Text('Playback rate control.'),
            const Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Slider(
              min: 0.5,
              max: 1.5,
              value: player.general.rate,
              onChanged: (rate) {
                player.setRate(rate);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openFileExplorer() async {
    setState(() {
      _selectedFiles = '';
      files.clear();
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'wmv', 'avi', 'mkv'],
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();

      for (File file in files) {
        //_selectedFiles = (await getApplicationDocumentsDirectory()).path;
        setState(() {
          _selectedFiles += file.path.split('\\').last + ', ';
        });
        await saveVideo(file);

        //medias.add(Media.file(file));
      }
    } else {
      // User canceled the picker
    }
  }

  Future saveVideo(File file) async {
    const String path =
        'D:/Sadi/FlutterProjects/Flutter_Desktop_Application-main/assets/Videos';

    ///$fileName';

    //final newDir = await Directory(path).create(recursive: true);
    try {
      await file.copy('$path/${file.path.split('\\').last}');
    } catch (exception) {
      throw Exception();
    }
    setState(() {
      medias.add(Media.file(File('$path/${file.path.split('\\').last}')));
    });

    // for (File file in files) {
    //   await file.copy('${newDir.path}/${file.path.split('\\').last}');
    // }
    //await audio.copy('$audioPath/${audio.path.split('\\').last}');
    //audio = File(audioPath + '/' + audio.path.split('\\').last);

    //createNoun(imagePath);
  }

  Widget _playlist(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16.0, top: 16.0),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Playlist manipulation.'),
                Divider(
                  height: 12.0,
                  color: Colors.transparent,
                ),
                Divider(
                  height: 12.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 456.0,
            child: ReorderableListView(
              shrinkWrap: true,
              onReorder: (int initialIndex, int finalIndex) async {
                /// 🙏🙏🙏
                /// In the name of God,
                /// With all due respect,
                /// I ask all Flutter engineers to please fix this issue.
                /// Peace.
                /// 🙏🙏🙏
                ///
                /// Issue:
                /// https://github.com/flutter/flutter/issues/24786
                /// Prevention:
                /// https://stackoverflow.com/a/54164333/12825435
                ///
                if (finalIndex > current.medias.length) {
                  finalIndex = current.medias.length;
                }
                if (initialIndex < finalIndex) finalIndex--;

                player.move(initialIndex, finalIndex);
                setState(() {});
              },
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: List.generate(
                current.medias.length,
                (int index) => ListTile(
                  key: Key(index.toString()),
                  leading: Text(
                    index.toString(),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  title: Text(
                    current.medias[index].resource,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  subtitle: Text(
                    current.medias[index].mediaType.toString(),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
                growable: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
