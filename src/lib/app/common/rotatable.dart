import 'dart:math';

import 'package:flutter/cupertino.dart';

class Rotatable extends StatefulWidget {
  const Rotatable({required this.child, this.onRotated});

  final Widget child;
  final Function? onRotated;

  @override
  _RotatableState createState() => _RotatableState();
}

class _RotatableState extends State<Rotatable> with SingleTickerProviderStateMixin {
  late Animation<double> _rotation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    if (widget.onRotated != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
          widget.onRotated!();
        }
      });
    }
    _rotation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _rotation,
      builder: (context, child) => Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.00011)
            ..rotateX(_rotation.value),
          child: child),
      child: widget.child);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
