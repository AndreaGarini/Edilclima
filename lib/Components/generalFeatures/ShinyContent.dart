
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShinyContent extends StatefulWidget{

  Widget content;
  Color baseColor;
  bool repeat;
  ShinyContent(this.content, this.baseColor, this.repeat);

  @override
  State<StatefulWidget> createState() => ShinyTextState();

}

class ShinyTextState extends State<ShinyContent>
    with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation curve;
  late Animation anim;

  @override
  initState(){
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    curve = CurvedAnimation(parent: controller, curve: Curves.easeInCubic);
    anim = Tween(begin: 0.0, end: 1.0).animate(controller)..addListener(() {
      setState(() {

      });
    });
    widget.repeat ? controller.repeat(min: 0.0, max: 1.0, reverse: true) : controller.forward(from: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(shaderCallback: (rect) {
      return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [controller.value - 0.1, controller.value, controller.value + 0.1],
          colors: [
            widget.baseColor,
            widget.baseColor.withOpacity(controller.value),
            widget.baseColor
          ]).createShader(rect);
    },
      child: widget.content);
  }
  }