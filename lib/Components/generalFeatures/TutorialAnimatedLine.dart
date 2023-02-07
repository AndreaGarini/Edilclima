
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ColorPalette.dart';

class TutorialAnimatedLine extends StatefulWidget{

  double width;
  TutorialAnimatedLine(this.width);

  Function lockController = (){};

  @override
  State<StatefulWidget> createState() => TutorialAnimatedLineState();

}

class TutorialAnimatedLineState extends State<TutorialAnimatedLine>
 with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation colorAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    controller.repeat(reverse: true);
    controller.addListener(() {
      setState(() {

      });
    });

    widget.lockController = (){
      controller.stop();
    };
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void controllerLock(){
    controller.stop();
  }

  @override
  Widget build(BuildContext context) {

    double borderWidth = (widget.width * 0.5 + (widget.width * 0.5) * controller.value);

    return Container(
        decoration: BoxDecoration(border: Border.all(
          color: lightBluePalette,
          width: borderWidth,
        ), color: Colors.transparent));
  }
}