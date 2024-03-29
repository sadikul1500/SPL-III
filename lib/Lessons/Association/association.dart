//https://pastebin.com/ZSgj4LU3
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  Player videoPlayer = Player(
    id: 91,
    registerTexture: false,
  );
  late int len;
  List<String> imageList = [];
  final Player _audioPlayer = Player(id: 19); //AudioPlayer();

  final CarouselController _controller = CarouselController();
  int activateIndex = 0;

  // bool _isPlaying = false;
  bool carouselAutoPlay = false;
  // bool _isPaused = true;
  MediaType mediaType = MediaType.file;
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();

  List<Media> medias = <Media>[];

  double bufferingProgress = 0.0;

  _AssociationState() {
    _index = 0;
    associations = associationList.getList();
    len = associations.length;
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
    // loadData(); //check if it is image and audio //.then((List<String> value) {    //   if (value.isNotEmpty)
    // if (associations[_index].audio != '') {
    //   loadAudio().then((value) {
    //     _associationCard();
    //   });
    // }
    if (associations[_index].audio != '') {
      listenStreams(_audioPlayer);
    } else {
      listenStreams(videoPlayer);
      checkVideo();
    }
  }

  void listenStreams(Player player) {
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
        setState(() => this.general = general);
      });

      player.bufferingProgressStream.listen(
        (bufferingProgress) {
          setState(() => this.bufferingProgress = bufferingProgress);
        },
      );
      player.errorStream.listen((event) {
        throw Error(); //'libvlc error.'
      });
      //devices = Devices.all;
      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      player.setEqualizer(equalizer);
      // _audioPlayer.open(Playlist(medias: medias), autoStart: false);
    }
  }

  checkVideo() {
    // print('came to check video function....');
    // print(associations[_index].video);
    // print("audio shoud be empty ${associations[_index].audio} ok");
    if (associations[_index].video != '') {
      // print('came to check video if condition....');
      medias = [
        Media.file(File(associations[_index].video))
      ]; //activities[index].video
      videoPlayer.open(
          Playlist(
            medias: medias,
          ),
          autoStart: false);
    }
  }

  Widget _associationCard() {
    if (associations.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: Text(
            'কোনো ডাটা পাওয়া যায়নি !!!', //No Data Found
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      );
    } // else {
    //   loadData();
    // }
    // else if (imageList.isEmpty) {
    //   return associationVideoWidgetCard();
    // } else {
    //   if (_audioPlayer.processingState != ProcessingState.ready) {
    //     loadAudio();

    //     return const CircularProgressIndicator();
    //   }

    //   return associationCardWidget();
    // }
    if (imageList.isEmpty) {
      loadData();
      loadAudio();
      return associationCardWidget();
      // loadData().then((data) {
      //   if (imageList.isEmpty) {
      //     loadData();
      //   } else {
      //     loadAudio();
      //     return associationCardWidget();
      //   }
      // });
      // return const CircularProgressIndicator();
    } else {
      return associationCardWidget(); //NounCard(names.elementAt(_index), _audioPlayer);
    }
  }

  @override
  void dispose() {
    videoPlayer.dispose();
    super.dispose();
  }

  List<String> loadData() {
    if (associations.isEmpty) {
      return []; //await loadData();
    }

    imageList = associations[_index].imgList;

    return imageList;
  }

  // Future loadAudio() async {
  //   await _audioPlayer.setAudioSource(
  //       AudioSource.uri(Uri.file(associations[_index].audio)),
  //       initialPosition: Duration.zero,
  //       preload: true);

  //   _audioPlayer.setLoopMode(LoopMode.one);
  //   _audioPlayer.playerStateStream.listen((state) {
  //     setState(() {});
  //   });
  //   return _audioPlayer;
  // }

  loadAudio() {
    _audioPlayer.setPlaylistMode(PlaylistMode.repeat);
    Media media = Media.file(File(associations[_index].audio));

    _audioPlayer.open(media, autoStart: false);

    // print('load audio association ${associations[_index].audio}');
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
            'সম্পর্ক শিখন', //'Association',
            //style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // _associationCard(),
            associations[_index].audio != ''
                ? _associationCard()
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
                                    width: 600,
                                    child: NativeVideo(
                                      player: videoPlayer,
                                      width: 600, //640,
                                      height: 420, //360,
                                      volumeThumbColor: Colors.blue,
                                      volumeActiveColor: Colors.blue,
                                      showControls: true, //!isPhone
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                              rightSidePanel(associations.elementAt(_index))
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
                      // _isPlaying = false;

                      try {
                        _index = (_index - 1) % len;
                      } catch (e) {
                        //print(e);
                      }
                    });
                  },
                  label: const Text(
                    'পূর্ববর্তী',
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
                    ? IconButton(
                        icon: (!_audioPlayer.playback.isPlaying)
                            ? const Icon(Icons.play_circle_outline)
                            : const Icon(Icons.pause_circle_filled),
                        iconSize: 40,
                        onPressed: () {
                          if (_audioPlayer.playback.isPlaying) {
                            //print('---------is playing true-------');
                            pause(); //stop()
                          } else {
                            //print('-------is playing false-------');
                            play();
                          }
                        })
                    : const SizedBox(width: 40), //Text('        '),
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
                      Text('পরবর্তী', //'Next',
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
              label:
                  const Text('শিক্ষার্থীকে এসাইন করুন', //'Assign to student',
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
                    .pushNamed('/associationForm')
                    .then((value) => setState(() {
                          proxyInitState();
                        }));
              },
              icon: const Icon(Icons.add),
              label: const Text('একটি সম্পর্ক যোগ করুন', //Add an association
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  stop() {
    if (imageList.isNotEmpty) {
      _audioPlayer.stop();
      carouselAutoPlay = false;
      // setState(() {
      //   _isPlaying = false;
      //   _isPaused = true;
      //   carouselAutoPlay = false;
      // });
    } else {
      videoPlayer.stop();
    }
  }

  pause() {
    _audioPlayer.pause();
    carouselAutoPlay = false;
    // setState(() {
    //   _isPaused = true;

    // });
  }

  play() {
    _audioPlayer.play();
    carouselAutoPlay = true;
    // setState(() {
    //   _isPlaying = true;
    //   _isPaused = false;

    // });
    //}
  }

  Widget associationVideoWidgetCard() {
    AssociationItem association = associations.elementAt(_index);
    associationVideoCard =
        AssociationVideoCard(associations[_index].video, videoPlayer);
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
                rightSidePanel(association)
              ])),
    ); //associationVideoCard.getAssociationVideoCard();
  }

  Widget associationCardWidget() {
    AssociationItem association = associations.elementAt(_index);
    // List<String> images = association.getImgList();

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
                    itemCount: imageList.length,
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
                      if (index >= imageList.length) {
                        index = 0;
                      }
                      final img = imageList.elementAt(index);
                      //images[index];

                      return buildImage(img);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                buildIndicator(imageList),
              ],
            ),
            rightSidePanel(association)
          ],
        ),
      ),
    );
  }

  Widget rightSidePanel(AssociationItem association) {
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
                  value: association.isSelected,
                  onChanged: (value) {
                    //setState(() {
                    association.isSelected = !association.isSelected;
                    if (association.isSelected) {
                      assignToStudent.add(associations[_index]);
                    } else {
                      assignToStudent.remove(associations[_index]);
                    }
                    //});
                  }),
              IconButton(
                  onPressed: () {
                    setState(() {
                      associationList.removeItem(association);
                      proxyInitState();
                    });
                  },
                  tooltip: 'আইটেমটি মুছে দিন',
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
                            'ইংরেজিতে : ', //'Title: ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'বাংলায় : ', //'Meaning:',
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
                            association.text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
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
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
          dialogTitle:
              'শিক্ষার্থীর ফোল্ডার নির্বাচন করুন'); // 'Choose student\'s folder'

      if (selectedDirectory == null) {
        // User canceled the picker
      } else {
        selectedDirectory.replaceAll('\\', '/');

        File(selectedDirectory + '/Lesson/Association/association.txt')
            .createSync(recursive: true);
        _write(File(selectedDirectory + '/Lesson/Association/association.txt'));
        copyImage(selectedDirectory + '/Lesson/Association');
        copyAudio(selectedDirectory + '/Lesson/Association');
        copyVideo(selectedDirectory + '/Lesson/Association');
      }
    }
  }

  Future<void> copyAudio(String destination) async {
    for (AssociationItem association in assignToStudent) {
      if (association.audio.isNotEmpty) {
        File file = File(association.audio);
        await file.copy(destination + '/${file.path.split('/').last}');
      }
    }
  }

  Future<void> copyVideo(String destination) async {
    for (AssociationItem association in assignToStudent) {
      if (association.video.isNotEmpty) {
        File file = File(association.video);
        await file.copy(destination + '/${file.path.split('/').last}');
      }
    }
  }

  Future<void> copyImage(String destination) async {
    for (AssociationItem association in assignToStudent) {
      if (association.dir.isNotEmpty) {
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
              '; ' +
              association.video +
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
            title: const Text(
                'কোনো আইটেম নির্বাচন করা হয়নি'), //'No item was selected'
            content: const Text(
                'কমপক্ষে একটি আইটেম নির্বাচন করুন'), //'Please select at least one item before assigning'
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
