import 'dart:io';
//import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';

// class Activity extends StatefulWidget {
//   @override
//   ActivityState createState() => ActivityState();
// }

class AssociationVideoCard {
  //extends State<Activity>
  late Player player; //= Player(
  //   id: 0,
  //   //videoDimensions: VideoDimensions(640, 360),
  //   registerTexture: false,
  // );
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

  AssociationVideoCard(String videoFilePath, this.player) {
    player.currentStream.listen((current) {
      this.current = current;
    });
    player.positionStream.listen((position) {
      this.position = position;
    });
    player.playbackStream.listen((playback) {
      this.playback = playback;
    });
    player.generalStream.listen((general) {
      general = general;
    });
    player.videoDimensionsStream.listen((videoDimensions) {
      videoDimensions = videoDimensions;
    });
    player.bufferingProgressStream.listen(
      (bufferingProgress) {
        bufferingProgress = bufferingProgress;
      },
    );
    player.errorStream.listen((event) {
      throw Error(); //'libvlc error.'
    });
    devices = Devices.all;
    Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
    equalizer.setPreAmp(10.0);
    equalizer.setBandAmp(31.25, 10.0);
    player.setEqualizer(equalizer);
    player.open(Media.file(File(videoFilePath)), autoStart: false);
  }

  //@override
  Widget getAssociationVideoCard() {
    return SizedBox(
      height: 420,
      width: 600,
      child: NativeVideo(
        player: player,
        width: 600, //640,
        height: 420, //360,
        volumeThumbColor: Colors.blue,
        volumeActiveColor: Colors.blue,
        showControls: true, //!isPhone
        //fit: BoxFit.contain,
      ),
    );
  }

  // Widget _controls(BuildContext context, bool isPhone) {
  //   return Card(
  //     elevation: 2.0,
  //     margin: const EdgeInsets.all(4.0),
  //     child: Container(
  //       margin: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text('Playback controls.'),
  //           const Divider(
  //             height: 8.0,
  //             color: Colors.transparent,
  //           ),
  //           Row(
  //             children: [
  //               ElevatedButton(
  //                 onPressed: () => player.play(),
  //                 child: const Text(
  //                   'play',
  //                   style: TextStyle(
  //                     fontSize: 14.0,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 12.0),
  //               ElevatedButton(
  //                 onPressed: () => player.pause(),
  //                 child: const Text(
  //                   'pause',
  //                   style: TextStyle(
  //                     fontSize: 14.0,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 12.0),
  //               ElevatedButton(
  //                 onPressed: () => player.playOrPause(),
  //                 child: const Text(
  //                   'playOrPause',
  //                   style: TextStyle(
  //                     fontSize: 14.0,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 12.0),
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           Row(
  //             children: [
  //               ElevatedButton(
  //                 onPressed: () => player.stop(),
  //                 child: const Text(
  //                   'stop',
  //                   style: TextStyle(
  //                     fontSize: 14.0,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 12.0),
  //               ElevatedButton(
  //                 onPressed: () => player.next(),
  //                 child: const Text(
  //                   'next',
  //                   style: TextStyle(
  //                     fontSize: 14.0,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 12.0),
  //               ElevatedButton(
  //                 onPressed: () => player.previous(),
  //                 child: const Text(
  //                   'previous',
  //                   style: TextStyle(
  //                     fontSize: 14.0,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const Divider(
  //             height: 12.0,
  //             color: Colors.transparent,
  //           ),
  //           const Divider(
  //             height: 12.0,
  //           ),
  //           const Text('Volume control.'),
  //           const Divider(
  //             height: 8.0,
  //             color: Colors.transparent,
  //           ),
  //           Slider(
  //             min: 0.0,
  //             max: 1.0,
  //             value: player.general.volume,
  //             onChanged: (volume) {
  //               player.setVolume(volume);
  //               setState(() {});
  //             },
  //           ),
  //           const Text('Playback rate control.'),
  //           const Divider(
  //             height: 8.0,
  //             color: Colors.transparent,
  //           ),
  //           Slider(
  //             min: 0.5,
  //             max: 1.5,
  //             value: player.general.rate,
  //             onChanged: (rate) {
  //               player.setRate(rate);
  //               setState(() {});
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _openFileExplorer() async {
  //   setState(() {
  //     _selectedFiles = '';
  //     files.clear();
  //   });
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     type: FileType.custom,
  //     allowedExtensions: ['mp4', 'mov', 'wmv', 'avi', 'mkv'],
  //   );

  //   if (result != null) {
  //     files = result.paths.map((path) => File(path!)).toList();

  //     for (File file in files) {
  //       //_selectedFiles = (await getApplicationDocumentsDirectory()).path;
  //       setState(() {
  //         _selectedFiles += file.path.split('\\').last + ', ';
  //       });
  //       await saveVideo(file);

  //       //medias.add(Media.file(file));
  //     }
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // Future saveVideo(File file) async {
  //   const String path =
  //       'D:/Sadi/FlutterProjects/Flutter_Desktop_Application-main/assets/Videos';

  //   ///$fileName';

  //   //final newDir = await Directory(path).create(recursive: true);
  //   try {
  //     await file.copy('$path/${file.path.split('\\').last}');
  //   } catch (exception) {
  //     throw Exception();
  //   }
  //   setState(() {
  //     medias.add(Media.file(File('$path/${file.path.split('\\').last}')));
  //   });

  //   // for (File file in files) {
  //   //   await file.copy('${newDir.path}/${file.path.split('\\').last}');
  //   // }
  //   //await audio.copy('$audioPath/${audio.path.split('\\').last}');
  //   //audio = File(audioPath + '/' + audio.path.split('\\').last);

  //   //createNoun(imagePath);
  // }

  // Widget _playlist(BuildContext context) {
  //   return Card(
  //     elevation: 2.0,
  //     margin: const EdgeInsets.all(4.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           margin: const EdgeInsets.only(left: 16.0, top: 16.0),
  //           alignment: Alignment.topLeft,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: const [
  //               Text('Playlist manipulation.'),
  //               Divider(
  //                 height: 12.0,
  //                 color: Colors.transparent,
  //               ),
  //               Divider(
  //                 height: 12.0,
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: 456.0,
  //           child: ReorderableListView(
  //             shrinkWrap: true,
  //             onReorder: (int initialIndex, int finalIndex) async {
  //               /// 🙏🙏🙏
  //               /// In the name of God,
  //               /// With all due respect,
  //               /// I ask all Flutter engineers to please fix this issue.
  //               /// Peace.
  //               /// 🙏🙏🙏
  //               ///
  //               /// Issue:
  //               /// https://github.com/flutter/flutter/issues/24786
  //               /// Prevention:
  //               /// https://stackoverflow.com/a/54164333/12825435
  //               ///
  //               if (finalIndex > current.medias.length) {
  //                 finalIndex = current.medias.length;
  //               }
  //               if (initialIndex < finalIndex) finalIndex--;

  //               player.move(initialIndex, finalIndex);
  //               setState(() {});
  //             },
  //             scrollDirection: Axis.vertical,
  //             padding: const EdgeInsets.symmetric(vertical: 8.0),
  //             children: List.generate(
  //               current.medias.length,
  //               (int index) => ListTile(
  //                 key: Key(index.toString()),
  //                 leading: Text(
  //                   index.toString(),
  //                   style: const TextStyle(fontSize: 14.0),
  //                 ),
  //                 title: Text(
  //                   current.medias[index].resource,
  //                   style: const TextStyle(fontSize: 14.0),
  //                 ),
  //                 subtitle: Text(
  //                   current.medias[index].mediaType.toString(),
  //                   style: const TextStyle(fontSize: 14.0),
  //                 ),
  //               ),
  //               growable: true,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
