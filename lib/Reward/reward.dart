//https://pastebin.com/ZSgj4LU3
import 'dart:io';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:kids_learning_tool/Lessons/Association/association_video.dart';
import 'package:kids_learning_tool/Model/reward_list.dart';
import 'package:kids_learning_tool/Reward/reward_list_box.dart';
import 'package:kids_learning_tool/Reward/reward_search_bar.dart';

class Reward extends StatefulWidget {
  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  RewardList rewardList = RewardList();
  late List<RewardItem> rewards;
  late AssociationVideoCard associationVideoCard;
  List<RewardItem> assignToStudent = [];
  int _index = 0;
  late Player videoPlayer;
  late int len;
  String imagePath = '';

  Widget _rewardCard() {
    if (rewards.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: Text(
            'No Data Found!!!',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      );
    } else {
      loadData();
    }
    if (imagePath.isEmpty) {
      return rewardVideoWidgetCard();
    } else {
      // if (_audioPlayer.processingState != ProcessingState.ready) {
      //   loadAudio();

      //   return const CircularProgressIndicator();
      // }

      return rewardCardWidget();
    }
  }

  _RewardState() {
    _index = 0;
    videoPlayer = Player(
      id: 0,
      //videoDimensions: VideoDimensions(640, 360),
      registerTexture: false,
    );
  }

  @override
  initState() {
    super.initState();
    proxyInitState();
  }

  proxyInitState() {
    rewards = rewardList.getList();
    len = rewards.length;
    loadData(); //check if it is image and audio //.then((List<String> value) {    //   if (value.isNotEmpty)
    if (imagePath.isNotEmpty) {
      // loadAudio().then((value) {
      _rewardCard();
      // });
    }
  }

  @override
  void dispose() {
    videoPlayer.dispose();
    super.dispose();
  }

  String loadData() {
    if (rewards.isEmpty) {
      return ''; //await loadData();
    }

    imagePath = rewards[_index].image;

    return imagePath;
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
            'Reward',
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
                    delegate: RewardSearch(rewards),
                  );
                  setState(() {
                    _index = max(
                        0,
                        rewards
                            .indexWhere((element) => element.title == result));
                  });
                },
                icon: const SafeArea(child: Icon(Icons.search_sharp)))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _rewardCard(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      stop();

                      setState(() {
                        //_isPlaying = false;

                        try {
                          _index = (_index - 1) % len;
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
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      stop();
                      setState(() {
                        try {
                          _index = (_index + 1) % len;
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
              onPressed: () async {
                stop();

                await Navigator.of(context)
                    .pushNamed('/rewardForm')
                    .then((value) => setState(() {
                          proxyInitState();
                        }));
              },
              icon: const Icon(Icons.add),
              label: const Text('Add a Reward',
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future stop() async {
    if (imagePath.isNotEmpty) {
      videoPlayer.stop();
    }
  }

  Widget rewardVideoWidgetCard() {
    RewardItem reward = rewards.elementAt(_index);
    associationVideoCard =
        AssociationVideoCard(rewards[_index].video, videoPlayer);
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
                    associationVideoCard.getAssociationVideoCard(),
                    const SizedBox(height: 15),
                  ],
                ),
                rightSidePanel(reward)
              ])),
    );
  }

  Widget rewardCardWidget() {
    RewardItem reward = rewards.elementAt(_index);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                    height: 420, width: 600, child: buildImage(reward.image)),
                const SizedBox(height: 10),
              ],
            ),
            rightSidePanel(reward)
          ],
        ),
      ),
    );
  }

  Widget rightSidePanel(RewardItem reward) {
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
                  value: reward.isSelected,
                  onChanged: (value) {
                    setState(() {
                      reward.isSelected = !reward.isSelected;
                      if (reward.isSelected) {
                        assignToStudent.add(rewards[_index]);
                      } else {
                        assignToStudent.remove(rewards[_index]);
                      }
                    });
                  }),
              IconButton(
                  onPressed: () {
                    setState(() {
                      rewardList.removeItem(reward);
                      proxyInitState();
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
                    color: Colors.blue[400],
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            reward.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImage(String img) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey,
      child: Image.file(
        File(img),
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  Future teachStudent() async {
    if (assignToStudent.isEmpty) {
      //alert popup
      _showMaterialDialog();
    } else {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
      } else {
        selectedDirectory.replaceAll('\\', '/');

        File(selectedDirectory + '/Reward/reward.txt')
            .createSync(recursive: true);
        _write(File(selectedDirectory + '/Reward/reward.txt'));

        copyFile(selectedDirectory + '/Reward');
      }
    }
  }

  Future<void> copyFile(String destination) async {
    for (RewardItem reward in assignToStudent) {
      File file;
      if (reward.video.isNotEmpty) {
        file = File(reward.video);
      } else {
        file = File(reward.image);
      }
      await file.copy(destination + '/${file.path.split('/').last}');
    }
  }

  Future _write(File file) async {
    for (RewardItem reward in assignToStudent) {
      await file.writeAsString(
          reward.title + '; ' + reward.image + '; ' + reward.video + '\n',
          mode: FileMode.append);
    }
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No item was selected'),
            content:
                const Text('Please select at least one item before assigning'),
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
