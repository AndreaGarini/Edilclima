
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedGradient extends StatefulWidget{

  String text;
  double fontSize;
  int millis;
  String? fontFamily;
  bool repeat;

  AnimatedGradient(this.text, this.fontSize, this.millis, this.fontFamily, this.repeat);

  @override
  State<StatefulWidget> createState() => AnimatedGradientState();

}

class AnimatedGradientState extends State<AnimatedGradient>
    with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation curve;
  late Animation anim;

  @override
  initState(){
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.millis));
    curve = CurvedAnimation(parent: controller, curve: Curves.easeInCubic);
    anim = Tween(begin: 0.0, end: 1.0).animate(controller)..addListener(() {
      setState(() {

      });
    });
    if(widget.repeat){
      controller.repeat(reverse: true);
    }
    else{
      controller.forward();
    }
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
         stops: [controller.value - 0.9, controller.value, controller.value + 0.3],
         colors: [
           darkBluePalette.withOpacity((controller.value * 4).clamp(0.0, 1.0)),
           lightBluePalette.withOpacity(((controller.value - 0.4) * 3).clamp(0.0, 1.0)),
           lightOrangePalette.withOpacity(((controller.value - 0.6) * 3).clamp(0.0, 1.0))
         ]).createShader(rect);
   },
   child: Text(widget.text, style: TextStyle(
       fontFamily: widget.fontFamily,
       fontSize: widget.fontSize,
       fontWeight: FontWeight.bold, color: Colors.white),),);
  }
}