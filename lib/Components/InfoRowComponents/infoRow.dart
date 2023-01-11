
import 'dart:async';

import 'package:edilclima_app/Components/InfoRowComponents/InfoRowDynamicContent.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Screens/CardSelectionScreen.dart';

enum InfoRowLayout{
  Base, Turn, Invalid, Budget, Research
}


class infoRow extends StatefulWidget{

  int animTime = 700;

  @override
  State<infoRow> createState() => infoRowState();

}

class infoRowState extends State<infoRow> with
    TickerProviderStateMixin{

  late AnimationController slideInControllerBase = AnimationController(
    duration: Duration(milliseconds: widget.animTime),
    vsync: this,
  )..forward(from: 0);

  late Animation<Offset> offsetAnimationIn = Tween<Offset>(
    begin: const Offset(-1.1, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: slideInControllerBase,
    curve: Curves.easeInQuad,
  ));

  late final AnimationController slideOutControllerBase = AnimationController(
    duration: Duration(milliseconds: widget.animTime),
    vsync: this,
  );

  late final Animation<Offset> offsetAnimationOut = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.1, 0.0),
  ).animate(CurvedAnimation(
    parent: slideOutControllerBase,
    curve: Curves.easeOutQuad,
  ));

  InfoRowLayout toShowLayout = InfoRowLayout.Base;
  bool animOut = false;
  bool infoRowDefaultLayout = true;
  bool readyToAnim = true;

  InfoRowLayout evaluateLayout(pushResult lastPush){
    if(infoRowDefaultLayout){
        switch(lastPush){
          case pushResult.InvalidCard: {
              return InfoRowLayout.Invalid;
          }
          case  pushResult.LowBudget: {
              return InfoRowLayout.Budget;
          }
          case  pushResult.ResearchNeeded: {
              return InfoRowLayout.Research;
          }
          default : {
              return InfoRowLayout.Base;
          }
        }
    }

    else{
        return InfoRowLayout.Turn;
    }
  }

  void endingLayoutChange (pushResult lastPush){
      InfoRowLayout newLayout = evaluateLayout(lastPush);

      if(toShowLayout!=newLayout && toShowLayout==InfoRowLayout.Base && readyToAnim){
        readyToAnim = false;
        baseLayoutOut(newLayout);
        animationEnded();
      }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {
      endingLayoutChange(gameModel.push.first() as pushResult);

        if (gameModel.playerTimer==null && gameModel.playerTimerCountdown!=null){
          infoRowDefaultLayout = false;
          int duration = 70;
          setPlayerTimer(duration, 1, gameModel);
          Future<void>.delayed(Duration(milliseconds: widget.animTime * 4), () {
            infoRowDefaultLayout = true;
          });
        }

      return
        Material(
            color: darkBluePalette,
            child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const Spacer(),
                        Expanded(flex: 12, child: SlideTransition(
                            position: animOut ? offsetAnimationOut : offsetAnimationIn,
                            child: InfoRowDynamicContent(toShowLayout))),
                        const Spacer()
                      ])),
                ]));
  });
  }

  //coroutines per animazioni

  Future<void> baseLayoutOut(InfoRowLayout newLayout) async{
    newLayoutIn(newLayout);
    return Future<void>.delayed(const Duration(milliseconds: 100), () {
      slideOutControllerBase.forward(from: 0);
      setState(() {
        animOut = true;
      });});
  }


  Future<void> newLayoutIn(InfoRowLayout newLayout) async{
    newLayoutOut();
    return Future<void>.delayed(Duration(milliseconds: widget.animTime + 100), () {
      slideInControllerBase.forward(from: 0);
      setState(() {
        animOut = false;
        toShowLayout = newLayout;
      });});
  }


  Future<void> newLayoutOut() async{
    returnToBaseLayout();
    return Future<void>.delayed(Duration(milliseconds: widget.animTime * 2 + 1000), () {
      slideOutControllerBase.forward(from: 0);
      setState(() {
        animOut = true;
      });
    });
  }

  Future<void> returnToBaseLayout() async{
    return Future<void>.delayed(Duration(milliseconds: widget.animTime * 3 + 1000), () {
      slideInControllerBase.forward(from: 0);
     setState(() {
       toShowLayout = InfoRowLayout.Base;
       animOut = false;
     });
    });
  }

  Future<void> animationEnded() async{
    return Future<void>.delayed(Duration(milliseconds: widget.animTime * 4 + 1000), () {
      readyToAnim = true;
    });
  }

  Future<void> setPlayerTimer(int timeToFinish, int TickInterval, GameModel gameModel) async{
    return Future<void>.delayed(const Duration(milliseconds: 50), () {
      var counter = timeToFinish;
      var playerTimer = Timer.periodic(Duration(seconds: TickInterval), (timer) {
        gameModel.playerTimerOnTick();
        counter--;
        if (counter == 0) {
          gameModel.playerTimerOnFinish();
          timer.cancel();
        }
      });
      gameModel.createPlayerTimer(playerTimer);
    });
  }
}