//https://pastebin.com/ZSgj4LU3
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kids_learning_tool/Lessons/Association/association_list_box.dart';
import 'package:kids_learning_tool/Lessons/Association/association_search_bar.dart';
import 'package:kids_learning_tool/Lessons/Association/association_video.dart';
import 'package:kids_learning_tool/Model/association_list.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Association extends StatefulWidget {
  @override
  State<Association> createState() => _AssociationState();
}

class _AssociationState extends State<Association> {
  AssociationList associationList = AssociationList();
  late List<AssociationItem> associations;
  late AssociationVideoCard associationVideoCard;
  List<AssociationItem> assignToStudent = [];
  int _index = 0;
  late Player videoPlayer;
  late int len;
  List<String> imageList = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState? _state;
  final CarouselController _controller = CarouselController();
  int activateIndex = 0;

  bool _isPlaying = false;
  bool carouselAutoPlay = false;
  bool _isPaused = true;

  Widget _associationCard() {
    if (associations.isEmpty) {
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
      //loadAudio();
    }
    if (imageList.isEmpty) {
      //loadData();
      return associationVideoWidgetCard();
      //return const CircularProgressIndicator();
      // } else if (audio) { //_state?.processingState != ProcessingState.ready
      //   loadData();
      //   loadAudio();

      //   return const CircularProgressIndicator();
    } else {
      // });
      if (_state?.processingState != ProcessingState.ready) {
        print('audio state not ready');
        loadAudio();
        return const CircularProgressIndicator();
      }
      //loadData(); //load image

      return associationCardWidget(); //NounCard(associations.elementAt(_index), _audioPlayer);
    }
  }

  _AssociationState() {
    _index = 0;
    videoPlayer = Player(
      id: 0,
      //videoDimensions: VideoDimensions(640, 360),
      registerTexture: false,
    );
  }

  @override
  initState() {
    associations = associationList.getList();
    len = associations.length;
    loadData(); //check if it is image and audio //.then((List<String> value) {    //   if (value.isNotEmpty)
    if (imageList.isNotEmpty) {
      loadAudio().then((value) {
        _associationCard();
      });
      //print('then2');

      // });

      _audioPlayer.playerStateStream.listen((state) {
        setState(() {
          _state = state;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayer.dispose();
    super.dispose();
  }

  List<String> loadData() {
    if (associations.isEmpty) {
      //await Future.delayed(const Duration(milliseconds: 150));
      return []; //await loadData();
    }

    imageList = associations[_index].imgList;

    return imageList;
  }

  Future loadAudio() async {
    //print(associations[_index].audio);
    await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.file(associations[_index].audio)),
        initialPosition: Duration.zero,
        preload: true);

    _audioPlayer.setLoopMode(LoopMode.one);
    // _audioPlayer.playerStateStream.listen((state) {
    //   setState(() {
    //     _state = state;
    //   });
    // });
    return _audioPlayer;
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
            'Assoication',
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
                    delegate: AssociationSearch(associations),
                  );
                  setState(() {
                    _index = max(
                        0,
                        associations
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
              _associationCard(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      stop();

                      setState(() {
                        //loading();

                        _isPlaying = false;

                        try {
                          _index = (_index - 1) % len;
                        } catch (e) {
                          //print(e);
                        }
                        //print(_state?.processingState);
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
                  imageList.isNotEmpty
                      ? //_playerButton()
                      // StreamBuilder<PlayerState>(
                      //     stream: _audioPlayer.playerStateStream,
                      //     builder: (context, AsyncSnapshot snapshot) {
                      //       _state =
                      //           snapshot.hasData ? snapshot.data : null;
                      //       return _playerButton(_state);
                      //     },
                      //   )
                      IconButton(
                          icon: (_isPaused)
                              ? const Icon(Icons.play_circle_outline)
                              : const Icon(Icons.pause_circle_filled),
                          iconSize: 40,
                          onPressed: () {
                            if (!_isPaused) {
                              //print('---------is playing true-------');
                              pause(); //stop()
                            } else {
                              //print('-------is playing false-------');
                              play();
                            }
                          })
                      : const Text('        '),
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
              onPressed: () {
                stop();

                Navigator.of(context)
                    .pushNamed('/associationForm')
                    .then((value) => setState(() {}));
              },
              icon: const Icon(Icons.add),
              label: const Text('Add a Association',
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
    //future async
    if (imageList.isNotEmpty) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _isPaused = true;
        carouselAutoPlay = false;
      });
    } else {
      videoPlayer.stop();
    }
  }

  pause() {
    _audioPlayer.pause();
    setState(() {
      _isPaused = true;
      carouselAutoPlay = false;
    });
  }

  Future play() async {
    _audioPlayer.play();

    setState(() {
      _isPlaying = true;
      _isPaused = false;
      carouselAutoPlay = true;
    });
    //}
  }

  Widget associationVideoWidgetCard() {
    associationVideoCard =
        AssociationVideoCard(associations[_index].video, videoPlayer);
    return associationVideoCard.getAssociationVideoCard();
  }

  Widget associationCardWidget() {
    AssociationItem association = associations.elementAt(_index);
    List<String> images = association.getImgList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 420,
                  width: 600,
                  child: CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: images.length,
                    options: CarouselOptions(
                        height: 385.0,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        autoPlay: carouselAutoPlay,
                        //pageSnapping: false,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayInterval: const Duration(seconds: 2),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1400),
                        viewportFraction: 0.8,
                        pauseAutoPlayOnManualNavigate: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activateIndex = index;
                          });
                        }),
                    itemBuilder: (context, index, realIndex) {
                      if (index >= images.length) {
                        index = 0;
                      }
                      final img = images[index];

                      return buildImage(img, index);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                buildIndicator(images),
              ],
            ),
            SizedBox(
              width: 500,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                          value: association.isSelected,
                          onChanged: (value) {
                            setState(() {
                              association.isSelected = !association.isSelected;
                              if (association.isSelected) {
                                assignToStudent.add(associations[_index]);
                              } else {
                                assignToStudent.remove(associations[_index]);
                              }
                            });
                          }),

                      IconButton(
                          onPressed: () {
                            setState(() {
                              associationList.removeItem(association);
                            });
                          },
                          icon: const Icon(Icons.delete_forever_rounded)),
                      //const SizedBox(height: 20.0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const <Widget>[
                                  Text(
                                    'Noun: ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  //SizedBox(height: 10),
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
                      //const SizedBox(width: 20.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Card(
                            //margin: const EdgeInsets.all(122.0),
                            color: Colors.blue[400],
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    association.text,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  //const SizedBox(height: 10),
                                  Text(
                                    association.meaning,
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
                  // const Text('To be modified',
                  //     style:
                  //         TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String img, int index) {
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

  Widget buildIndicator(List<String> images) => AnimatedSmoothIndicator(
        activeIndex: activateIndex % images.length,
        count: images.length,
        effect: const JumpingDotEffect(
          //SwapEffect
          activeDotColor: Colors.blue,
          dotColor: Colors.black12,
          dotHeight: 10,
          dotWidth: 10,
        ),
        onDotClicked: animateToSlide,
      );

  void animateToSlide(int index) {
    // if (index > images.length) {
    //   index = 0;
    // }
    try {
      _controller.animateToPage(index);
    } catch (e) {
      //print(e);
      throw Exception(e);
    }
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
        //print('selected directory ' + selectedDirectory);
        File(selectedDirectory + '/noun.txt').createSync(recursive: true);
        _write(File(selectedDirectory + '/noun.txt'));
        copyImage(selectedDirectory);
        copyAudio(selectedDirectory);
      }
    }
  }

  Future<void> copyAudio(String destination) async {
    for (AssociationItem association in assignToStudent) {
      File file = File(association.audio);
      await file.copy(destination + '/${file.path.split('/').last}');
    }
  }

  Future<void> copyImage(String destination) async {
    for (AssociationItem association in assignToStudent) {
      String folder = association.dir.split('/').last;
      final newDir =
          await Directory(destination + '/$folder').create(recursive: true);
      final oldDir = Directory(association.dir);

      await for (var original in oldDir.list(recursive: false)) {
        if (original is File) {
          await original
              .copy('${newDir.path}/${original.path.split('\\').last}');
        }
      }
    }
  }

  Future _write(File file) async {
    for (AssociationItem association in assignToStudent) {
      await file.writeAsString(
          association.text +
              '; ' +
              association.meaning +
              '; ' +
              association.dir +
              '; ' +
              association.audio +
              '\n',
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

  Widget _playerButton() {
    // 1
    //PlayerState processingState = playerState.processingState;
    //debugPrint(String(_state?.processingState));
    if (_state?.processingState == ProcessingState.loading ||
        _state?.processingState == ProcessingState.buffering) {
      loadAudio();
      return const CircularProgressIndicator();
    } else if (_isPaused) {
      return IconButton(
        icon: const Icon(Icons.play_circle_fill_outlined),
        iconSize: 40.0,
        onPressed: () {
          play();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.pause_circle_filled_outlined),
        iconSize: 40.0,
        onPressed: () {
          pause();
        },
      );
    }
    // else if (_audioPlayer.playing != true) {
    //   // 3
    //   return IconButton(
    //     icon: const Icon(Icons.play_arrow),
    //     iconSize: 40.0,
    //     onPressed: _audioPlayer.play,
    //   );
    // } else if (_state?.processingState != ProcessingState.completed) {
    //   // 4
    //   return IconButton(
    //     icon: const Icon(Icons.pause),
    //     iconSize: 40.0,
    //     onPressed: _audioPlayer.pause,
    //   );
    // } else {
    //   // 5
    //   return IconButton(
    //     icon: const Icon(Icons.replay),
    //     iconSize: 40.0,
    //     onPressed: () => _audioPlayer.seek(
    //       Duration.zero,
    //     ),
    //   );
    // }
  }
}
