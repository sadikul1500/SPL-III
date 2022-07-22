//https://www.youtube.com/watch?v=pwkDaGbYuu8&ab_channel=TechiePraveen
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:kids_learning_tool/Quiz/DragDrop/item_model.dart';

class Drag extends StatefulWidget {
  final List<ItemModel> items1;
  final List<ItemModel> items2;
  final String question;
  const Drag(this.items1, this.items2, this.question);
  @override
  State<Drag> createState() => _DragState();
}

class _DragState extends State<Drag> {
  int score = 0;

  bool gameOver = false;
  AudioPlayer audioPlayer = AudioPlayer();
  late ConfettiController _confettiController,
      _smallConfettiController,
      _confettiRightController,
      _confettiLeftController;

  bool playConfetti = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    initDrag();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _confettiController.dispose();
    _smallConfettiController.dispose();
    super.dispose();
  }

  initDrag() {
    score = 0;
    gameOver = false;
    loadAudio();

    _confettiController = ConfettiController();
    _smallConfettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _confettiRightController =
        ConfettiController(duration: const Duration(seconds: 1));
    _confettiLeftController =
        ConfettiController(duration: const Duration(seconds: 1));

    widget.items1.shuffle();
    widget.items2.shuffle();
  }

  Future loadAudio() async {
    await audioPlayer.setAudioSource(
        AudioSource.uri(Uri.file('D:/Sadi/spl3/assets/Audios/win.wav')),
        initialPosition: Duration.zero,
        preload: true);

    audioPlayer
        .setLoopMode(LoopMode.off); //off- play once... on- continues playing..
    audioPlayer.playerStateStream.listen((state) {
      setState(() {});
    });
    audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration!;
      });
    });
    audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    return audioPlayer;
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  stopPlayingAudio() async {
    audioPlayer.playerStateStream.listen((state) {
      setState(() {});
    });
    if (audioPlayer.processingState == ProcessingState.completed) {
      await audioPlayer.stop();
    }
  }

  Future<void> audioPlay() async {
    audioPlayer.play();

    Future.delayed(duration, () => audioPlayer.pause()); //
  }

  @override
  Widget build(BuildContext context) {
    if (score == widget.items1.length + score) {
      gameOver = true;
      _confettiController.play();
    }
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text.rich(TextSpan(children: [
            const TextSpan(
                text: 'Score: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            TextSpan(
                text: '$score / ${widget.items1.length + score}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
          ]))),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                'Q. ' + widget.question,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              gameOver == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //CENTER LEFT -- Emit right
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ConfettiWidget(
                            confettiController: _confettiLeftController,
                            blastDirection: 0, // radial value - RIGHT
                            emissionFrequency: 0.09,
                            minimumSize: const Size(8,
                                8), // set the minimum potential size for the confetti (width, height)
                            maximumSize: const Size(18,
                                18), // set the maximum potential size for the confetti (width, height)
                            numberOfParticles: 7,
                            gravity: 0.1,
                          ),
                        ),
                        Column(
                          children: widget.items1.map((item) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(
                                  100.0, 10.0, 25.0, 8.0),
                              child: Draggable<ItemModel>(
                                data: item,
                                childWhenDragging: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Image.file(
                                      File(item.value.split(' space ').first),
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                      //colorBlendMode: BlendMode.darken,
                                    )),
                                feedback: SizedBox(
                                    height: 100,
                                    width: 150,
                                    child: Image.file(
                                      File(item.value.split(' space ').first),
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                    )),
                                child: SizedBox(
                                    height: 150,
                                    width: 200,
                                    child: Image.file(
                                      File(item.value.split(' space ').first),
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                    )),
                              ),
                            );
                          }).toList(),
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: ConfettiWidget(
                            confettiController: _smallConfettiController,
                            blastDirectionality: BlastDirectionality.explosive,
                            // don't specify a direction, blast randomly
                            shouldLoop:
                                false, // start again as soon as the animation is finished
                            colors: const [
                              Colors.green,
                              Colors.blue,
                              Colors.pink,
                              Colors.orange,
                              Colors.purple
                            ], // manually specify the colors to be used
                            createParticlePath:
                                drawStar, // define a custom shape/path.
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: widget.items2.map((item) {
                            return Container(
                              margin:
                                  const EdgeInsets.fromLTRB(25, 10, 100, 8.0),
                              child: DragTarget<ItemModel>(
                                onAccept: (receivedItem) async {
                                  if (item.value ==
                                      receivedItem.value.split(' ').last) {
                                    setState(() {
                                      playConfetti = true;
                                      _smallConfettiController.play();
                                      _confettiRightController.play();
                                      _confettiLeftController.play();

                                      widget.items1.remove(receivedItem);
                                      widget.items2.remove(item);
                                      //dispose();
                                      score += 1;
                                      item.accepting = false;
                                    });

                                    await audioPlay();
                                  } else {
                                    setState(() {
                                      //score -= 1;
                                      item.accepting = false;
                                      playConfetti = false;
                                    });
                                  }
                                },
                                onLeave: (receivedItem) {
                                  setState(() {
                                    item.accepting = false;
                                    playConfetti = false;
                                    //audioPlayer.stop();
                                  });
                                },
                                onWillAccept: (receivedItem) {
                                  setState(() {
                                    item.accepting = true;
                                    playConfetti = false;
                                  });
                                  return true;
                                },
                                builder:
                                    (context, acceptedItem, rejectedItem) =>
                                        Container(
                                  color:
                                      item.accepting ? Colors.red : Colors.blue,
                                  height: 70,
                                  width: 150,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Text(item.value,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        //CENTER RIGHT -- Emit left
                        Align(
                          alignment: Alignment.centerRight,
                          child: ConfettiWidget(
                            confettiController: _confettiRightController,
                            blastDirection: pi, // radial value - LEFT
                            particleDrag: 0.05, // apply drag to the confetti
                            emissionFrequency: 0.09, // how often it should emit
                            numberOfParticles: 7, // number of particles to emit
                            gravity: 0.1, // gravity - or fall speed
                            shouldLoop: false,
                            colors: const [
                              Colors.green,
                              Colors.blue,
                              Colors.pink
                            ], // manually specify the colors to be used
                            // strokeWidth: 1,
                            // strokeColor: Colors.white,
                          ),
                        ),
                      ],
                    ) //,
                  : _showReward()
            ],
          ),
        ),
      ),
    );
  }

  Widget _showReward() {
    return Column(
      children: <Widget>[
        const Text('Quiz Complete !!!',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        const SizedBox(height: 30),
        //_confetti(_confettiController, true),
        const SizedBox(height: 30),
        Center(
          child: SizedBox(
              height: 250,
              width: 300,
              child: Image.file(
                File(
                    'D:/Sadi/FlutterProjects/Flutter_Desktop_Application-main/assets/Rewards/congrats2.gif'),
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              )),
        ),
      ],
    );
  }
}










// Widget _confetti(ConfettiController confettiController, bool loop) {
//     return SafeArea(
//         child: Stack(
//       children: <Widget>[
//         Align(
//           alignment: Alignment.center,
//           child: ConfettiWidget(
//             confettiController: confettiController,
//             blastDirectionality: BlastDirectionality.explosive,
//             // don't specify a direction, blast randomly
//             shouldLoop:
//                 loop, // start again as soon as the animation is finished
//             colors: const [
//               Colors.green,
//               Colors.blue,
//               Colors.pink,
//               Colors.orange,
//               Colors.purple
//             ], // manually specify the colors to be used
//             createParticlePath: drawStar, // define a custom shape/path.
//           ),
//         ),
//         //CENTER RIGHT -- Emit left
//         Align(
//           alignment: Alignment.centerRight,
//           child: ConfettiWidget(
//             confettiController: _confettiRightController,
//             blastDirection: pi, // radial value - LEFT
//             particleDrag: 0.05, // apply drag to the confetti
//             emissionFrequency: 0.05, // how often it should emit
//             numberOfParticles: 20, // number of particles to emit
//             gravity: 0.05, // gravity - or fall speed
//             shouldLoop: false,
//             colors: const [
//               Colors.green,
//               Colors.blue,
//               Colors.pink
//             ], // manually specify the colors to be used
//           ),
//         ),
//       ],
//     ));
//   }
