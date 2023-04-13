
import 'dart:async';

import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoRowTimerIndicator extends StatefulWidget{

  bool timerBegin;
  InfoRowTimerIndicator(this.timerBegin);

  @override
  State<StatefulWidget> createState() => InfoRowTimerIndicatorState();
}

class InfoRowTimerIndicatorState extends State<InfoRowTimerIndicator>
  with SingleTickerProviderStateMixin{

  //todo: tempo troppo lungo per aggiornare il db quando il timer finisce
  late AnimationController indicatorController;
  late double timerBegin;
  late int timerDuration;
  int timerValue = 60;
  Color? colorValue;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();
    setInfoRowTimer();
    timerBegin = 1;
    indicatorController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.1),
      end: const Offset(0.0, 1.1),
    ).animate(indicatorController);
  }

  @override
  void dispose(){
    super.dispose();
    indicatorController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if(widget.timerBegin){

      WidgetsBinding.instance?.addPostFrameCallback((_){
        indicatorController.forward(from: 0.0);
        Color.lerp(Colors.green, Colors.redAccent, timerValue / 60);
      });

      return SlideTransition(
          position: offsetAnimation,
          child: timerValue <= 59 ? StylizedText(colorValue!, "$timerValue", null, FontWeight.bold)
                                  : const SizedBox());
    }
    else{
      return const SizedBox();
    }
  }

  Future<void> setInfoRowTimer() async{
    return Future<void>.delayed(const Duration(milliseconds: 1), () {
      var counter = 60;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        counter--;
        setState((){
          if(counter <= 59){
            timerValue = counter;
            colorValue = Color.lerp(Colors.redAccent, Colors.green, timerValue / 60);
          }
        });
        if (counter == 0) {
          timer.cancel();
        }
      });
    });
  }

}