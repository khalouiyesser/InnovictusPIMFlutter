import 'package:flutter/material.dart';
import 'dart:math';

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
  });

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

 // Inside FlipCard
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: _flipCard,
    child: AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value;
        final isFrontVisible = angle < pi / 2;

        return SizedBox(
          height: 300, // Fixed height for the card
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: Stack(
              children: [
                // **Front Card (Visible when flipping forward)**
                Visibility(
                  visible: isFrontVisible,
                  child: widget.front,
                ),
                
                // **Back Card (Visible when flipped, but text remains readable)**
                Visibility(
                  visible: !isFrontVisible,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: widget.back,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}}