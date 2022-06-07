import 'dart:io';
//import 'package:flutter_audio_desktop/flutter_audio_desktop.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:just_audio_libwinmedia/just_audio_libwinmedia.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Nouns/name_list.dart';
//import 'package:kids_learning_tool/Lessons/Nouns/names.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kids_learning_tool/Model/noun_list.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NounCard extends StatefulWidget {
  //final Name name;
  final NounItem name;
  //final int ind;
  final AudioPlayer audioPlayer;
  const NounCard(this.name, this.audioPlayer);

  @override
  State<NounCard> createState() => _NounCardState();
}

class _NounCardState extends State<NounCard> {
  AudioPlayer audioPlayer = AudioPlayer(); // = widget.audioPlayer;
  NameList nameList = NameList();
  int index = 0;
  int activateIndex = 0;
  late List<String> images;
  PlayerState? _state;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    //activateIndex = widget.ind;
    // print('hehehehehehe');
    // print(activateIndex);
    audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _state = state;
      });
      // print(100);
      // print(_state?.processingState);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    images = widget.name.getImgList();
    audioPlayer = widget.audioPlayer;
    //playAudioFile();

    return SizedBox(
      height: 1500,
      child: Card(
        borderOnForeground: false,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: <Widget>[
              Text(
                'Noun: ${widget.name.text}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Meaning: ${widget.name.meaning}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 20,
                child: Row(
                  children: <Widget>[
                    // ignore: prefer_const_constructors
                    // Checkbox(value: value, onChanged: onChanged),
                    IconButton(
                        onPressed: () {
                          nameList.removeItem(widget.name);
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ),
              SizedBox(
                //height: 100,
                //width: 600,
                child: CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: images.length,
                  options: CarouselOptions(
                      height: 385.0,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      autoPlay: true,
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
                          //images = widget.name.getImgList();
                          activateIndex = index;
                        });
                      }),
                  itemBuilder: (context, index, realIndex) {
                    final img = images[index];

                    return buildImage(img, index);
                  },
                ),
              ),
              const SizedBox(height: 10),
              buildIndicator(),
            ],
          ),
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

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activateIndex,
        count: images.length,
        effect: const SwapEffect(
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
    }
  }

  void playAudioFile() {
    //_audioPlayer.setUrl(url);
    // _audioPlayer.setFilePath('C:/Users/Admin/Downloads/text.wav',
    //     preload: false);
    //print('called');
    audioPlayer.play();
  }

  void removeItem(int index) {}
}

// @override
// void didChangeDependencies() {
//   print('kaj korsi ryan mama');
//   activateIndex = widget.ind;
//   //images = widget.name.getImgList();
//   print('activate index dekho...');
//   print(activateIndex);
//   // TODO: implement didChangeDependencies
//   super.didChangeDependencies();
// }

//   void playAudioFile() {
//     // Load audio file.
//     // audioPlayer
//     //     .load(AudioSource(file: File('C:/Users/Admin/Downloads/test.wav')));
//     var audioPlayer = AudioPlayer(id: 0)
//       ..stream.listen(
//         (Audio audio) {
//           // Listen to playback events.
//         },
//       );
//     audioPlayer.load(
//       AudioSource.fromFile(
//         File('C:/Users/Admin/Downloads/test.wav'),
//       ),
//     );

// // Start playing loaded audio file.
//     audioPlayer.play();

// // Get audio duration.
//     //print('Duration Of Track: ${audioPlayer.getDuration()}');

// // Change playback volume.
//     audioPlayer.setVolume(0.8);
//     print('Changed volume to 80%.');
//   }
