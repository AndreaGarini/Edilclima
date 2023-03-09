
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generalFeatures/ColorPalette.dart';

class GameBoardDynamicTitle extends StatefulWidget{

    String title;
    Function? reverseCallback;
    GameBoardDynamicTitle(this.title);

    @override
    State<StatefulWidget> createState() => GameBoardDynamicTitleState();

}

class GameBoardDynamicTitleState extends State<GameBoardDynamicTitle>
 with TickerProviderStateMixin{

  late AnimationController boxController;
  late AnimationController textController;

  @override
  void initState() {
    super.initState();
    boxController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..addListener(() {
      setState(() {});
    });
    textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..addListener(() {
      setState(() {});
    });

    boxController.forward();
    Future.delayed(const Duration(milliseconds: 1000), () {
      textController.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    boxController.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance?.addPostFrameCallback((_) {
       widget.reverseCallback ??= reverseSequence;
    });


    return SizedBox(width: screenWidth * 0.4, height: screenHeight * 0.2 * boxController.value,
        child:
        Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
            elevation: 10,
            child: Center(child:  ShaderMask(shaderCallback: (rect) {
          return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [textController.value - 0.9, textController.value, textController.value + 0.3],
              colors: [
                darkBluePalette.withOpacity((textController.value * 4).clamp(0.0, 1.0)),
                darkBluePalette.withOpacity(((textController.value - 0.4) * 3).clamp(0.0, 1.0)),
                darkOrangePalette.withOpacity(((textController.value - 0.6) * 3).clamp(0.0, 1.0))
              ]).createShader(rect);
        },
            child: Text(widget.title, style: TextStyle(
                fontFamily: 'Inspiration',
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold, color: Colors.white)))))
        );
  }

  Future<void> reverseSequence(){
    textController.reverse();
    return Future.delayed(const Duration(milliseconds: 1500), () {
      boxController.reverse();
    });
  }
}