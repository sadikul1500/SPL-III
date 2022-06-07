//https://pastebin.com/ZSgj4LU3
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kids_learning_tool/Lessons/Color/addToDb.dart';
import 'package:kids_learning_tool/Model/color_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//import 'package:kplayer/kplayer.dart';

class BasicColor extends StatefulWidget {
  @override
  State<BasicColor> createState() => _BasicColorState();
}

class _BasicColorState extends State<BasicColor> {
  ColorList colorList = ColorList();
  late List<ColorItem> colors;
  List<ColorItem> assignToStudent = [];
  int _index = 0;
  late int len;
  List<String> imageList = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState? _state;
  final CarouselController _controller = CarouselController();
  int activateIndex = 0;
  List<File> files = [];
  var theme = {
    'Black': Colors.black38,
    'Blue': Colors.blue,
    'Brown': Colors.brown,
    'Green': Colors.green,
    'Orange': Colors.orange,
    'Pink': Colors.pink,
    'Purple': Colors.purple,
    'Red': const Color.fromARGB(255, 202, 29, 17),
    'White': Colors.grey,
    'Yellow': const Color.fromARGB(255, 234, 212, 19)
  };

  bool _isPlaying = false;
  bool carouselAutoPlay = false;
  bool _isPaused = true;

  Widget _colorCard() {
    if (imageList.isEmpty) {
      loadData();
      return const CircularProgressIndicator();
    } else if (_state?.processingState != ProcessingState.ready) {
      loadAudio();
      return const CircularProgressIndicator();
    } else {
      return colorCardWidget();
    }
  }

  _BasicColorState() {
    _index = 0;
  }

  @override
  initState() {
    loadData().then((List<String> value) {
      if (value.isNotEmpty) {
        loadAudio().then((value) {
          _colorCard();
        });
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _state = state;
      });
    });
    printDirectoryPath();
    super.initState();
  }

  printDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
  }

  Future<List<String>> loadData() async {
    colors = colorList.getList();
    if (colors.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 150));
      return await loadData();
    }
    len = colors.length;
    imageList = colors[_index].imgList;

    return imageList;
  }

  Future loadAudio() async {
    await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.file(colors[_index].audio)),
        initialPosition: Duration.zero,
        preload: true);

    _audioPlayer.setLoopMode(LoopMode.one);
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
          backgroundColor: theme[colors[_index].text],
          title: const Text(
            'Colour',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  stop();
                  setState(() {});
                  var result = await showSearch<String>(
                    context: context,
                    delegate: ColorSearch(colors),
                  );
                  setState(() {
                    _index = max(0,
                        colors.indexWhere((element) => element.text == result));
                  });
                },
                icon: const SafeArea(child: Icon(Icons.search_sharp)))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            //resizeTo
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _colorCard(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      stop();

                      setState(() {
                        _isPlaying = false;

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
                      primary: theme[colors[_index].text],
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                      icon: (_isPaused)
                          ? const Icon(Icons.play_circle_outline)
                          : const Icon(Icons.pause_circle_filled),
                      iconSize: 40,
                      onPressed: () {
                        if (!_isPaused) {
                          pause(); //stop()
                        } else {
                          play();
                        }
                      }),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      stop();
                      setState(() {
                        //loading();

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
                      primary: theme[colors[_index].text],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 25.0),
            FloatingActionButton.extended(
              backgroundColor: theme[colors[_index].text],
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
            // const SizedBox(
            //   height: 15,
            // ),
            const Spacer(),
            FloatingActionButton.extended(
              backgroundColor: theme[colors[_index].text],
              heroTag: 'btn2',
              onPressed: () {
                stop();

                Navigator.of(context)
                    .pushNamed('/nounForm')
                    .then((value) => setState(() {}));
              },
              icon: const Icon(Icons.add),
              label: const Text('Add a Color',
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
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _isPaused = true;
      carouselAutoPlay = false;
    });
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
  }

  Widget colorCardWidget() {
    ColorItem color = colors.elementAt(_index);
    List<String> images = color.getImgList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  width: 600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          tooltip: 'Add an image',
                          color: theme[colors[_index].text],
                          onPressed: () {
                            setState(() {
                              _openFileExplorer().then((data) {
                                if (data.isNotEmpty) {
                                  saveImage().then((value) {
                                    if (value == 1) {
                                      //color.updateImgList();
                                      //images.clear();
                                    }
                                  });
                                }
                              });
                              //images = color.getImgList();
                            });
                          },
                          icon: const Icon(Icons.add_a_photo)),
                      IconButton(
                          tooltip: 'Delete this image',
                          color: theme[colors[_index].text],
                          //hoverColor: Colors.red[200],
                          onPressed: () {
                            setState(() {
                              deleteImage(
                                  activateIndex); //primary testing done. passed
                            });
                          },
                          icon: const Icon(Icons.delete_outline)),
                    ],
                  ),
                ),
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
                        //print('called 22');
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
                      IconButton(
                          color: theme[colors[_index].text],
                          tooltip: color.isSelected
                              ? 'Cancel this selection'
                              : 'Select this colour',
                          onPressed: () {
                            setState(() {
                              color.isSelected = !color.isSelected;
                              if (color.isSelected) {
                                assignToStudent.add(colors[_index]);
                              } else {
                                assignToStudent.remove(colors[_index]);
                              }
                            });
                          },
                          icon: color.isSelected
                              ? const Icon(Icons.check_box_rounded)
                              : const Icon(Icons.check_box_outline_blank)),
                      // Checkbox(
                      //     value: color.isSelected,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         color.isSelected = !color.isSelected;
                      //         if (color.isSelected) {
                      //           assignToStudent.add(colors[_index]);
                      //         } else {
                      //           assignToStudent.remove(colors[_index]);
                      //         }
                      //       });
                      //     }),
                      IconButton(
                          color: theme[colors[_index].text],
                          tooltip: 'Remove this color',
                          onPressed: () {
                            setState(() {
                              colorList.removeItem(color);
                            });
                          },
                          icon: const Icon(Icons.delete_outline_outlined)),
                      // IconButton(
                      //     onPressed: () {},
                      //     icon: const Icon(Icons.file_copy_outlined)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: 222,
                            height: 150,
                            child: Card(
                              //margin: const EdgeInsets.all(122.0),
                              color: theme[colors[_index].text],
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      color.text,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    //const SizedBox(height: 10),
                                    Text(
                                      color.meaning,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
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

  Future<List<File>> _openFileExplorer() async {
    files.clear();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
    return files;
  }

  Future<int> saveImage() async {
    if (files.isEmpty) return 0;
    String path = colors[_index].dir;

    final newDir = await Directory(path).create(recursive: true);

    for (File file in files) {
      await file.copy('${newDir.path}/${file.path.split('\\').last}');
      colors[_index]
          .imgList
          .add('${newDir.path}/${file.path.split('\\').last}');
    }
    return 1;
  }

  Future<void> deleteImage(int ind) async {
    File file = File(colors[_index].imgList[ind]);
    try {
      if (await file.exists()) {
        await file.delete();
        colors[_index].imgList.removeAt(ind);
      }
    } catch (e) {
      //
    }
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
        effect: JumpingDotEffect(
          //SwapEffect
          activeDotColor: theme[colors[_index].text]!,
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
    for (ColorItem color in assignToStudent) {
      File file = File(color.audio);
      await file.copy(destination + '/${file.path.split('/').last}');
    }
  }

  Future<void> copyImage(String destination) async {
    for (ColorItem color in assignToStudent) {
      String folder = color.dir.split('/').last;
      final newDir =
          await Directory(destination + '/$folder').create(recursive: true);
      final oldDir = Directory(color.dir);

      await for (var original in oldDir.list(recursive: false)) {
        if (original is File) {
          await original
              .copy('${newDir.path}/${original.path.split('\\').last}');
        }
      }
    }
  }

  Future _write(File file) async {
    for (ColorItem color in assignToStudent) {
      await file.writeAsString(
          color.text +
              '; ' +
              color.meaning +
              '; ' +
              color.dir +
              '; ' +
              color.audio +
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
}

ColorSearch(List<ColorItem> colors) {}
