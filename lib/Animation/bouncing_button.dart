//bounces on tap only
import 'package:flutter/material.dart';
import 'package:kids_learning_tool/Lessons/Maths/addition.dart';

class BouncingButton extends StatefulWidget {
  final String text;
  Addition addition_answer = Addition();
  BouncingButton(this.text);
  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: AnimatedButton(
          _controller, widget.text, widget.addition_answer), //, widget.ans
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
    //print(100);
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    //print(200);
  }
}

class AnimatedButton extends AnimatedWidget {
  final AnimationController _controller;
  final String text;
  Addition answer = Addition();
  // const AnimatedButton({
  //   required AnimationController controller,
  // })  : _controller = controller,
  //       super(listenable: controller);
  AnimatedButton(this._controller, this.text,this.answer)
      : super(listenable: _controller); //, this.ans

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - _controller.value,
      child: Container(
        height: 80,
        width: 200,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        child: Center(
          child: Text(text,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
