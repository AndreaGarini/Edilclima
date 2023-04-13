
import 'dart:async';

import 'package:edilclima_app/Components/InfoRowComponents/InfoRowDynamicContent.dart';
import 'package:edilclima_app/Components/InfoRowComponents/InfoRowTimerIndicator.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  late AnimationController slideInControllerBase;
  late Animation<Offset> offsetAnimationIn;
  late AnimationController slideOutControllerBase;
  late Animation<Offset> offsetAnimationOut;
  InfoRowLayout toShowLayout = InfoRowLayout.Base;
  bool animOut = false;
  bool infoRowDefaultLayout = true;
  bool readyToAnim = true;
  InfoRowDynamicContent? infoRowDynamicContent;

  @override
  void initState() {
    super.initState();

    infoRowDynamicContent = InfoRowDynamicContent(toShowLayout);

    slideInControllerBase = AnimationController(
      duration: Duration(milliseconds: widget.animTime),
      vsync: this,
    )..forward(from: 0);

    offsetAnimationIn = Tween<Offset>(
      begin: const Offset(-1.1, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideInControllerBase,
      curve: Curves.easeInQuad,
    ));

    slideOutControllerBase = AnimationController(
      duration: Duration(milliseconds: widget.animTime),
      vsync: this,
    );

    offsetAnimationOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.1, 0.0),
    ).animate(CurvedAnimation(
      parent: slideOutControllerBase,
      curve: Curves.easeOutQuad,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    slideInControllerBase.dispose();
    slideOutControllerBase.dispose();
  }

  InfoRowLayout evaluateLayout(pushResult lastPush, bool infoRowLayout){
          if(infoRowLayout){
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

  void endingLayoutChange (pushResult lastPush, bool infoRowLayout){
      InfoRowLayout newLayout = evaluateLayout(lastPush, infoRowLayout);
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
      //todo: controlla che il low budget esca nella info row
      gameModel.infoRowCallback ??= (){
        endingLayoutChange(gameModel.push.first() as pushResult, infoRowDefaultLayout);
      };

      gameModel.createTimerCallback ??= (){
        infoRowDefaultLayout = false;
        endingLayoutChange(gameModel.push.first() as pushResult, infoRowDefaultLayout);
        int duration = 63;
        setPlayerTimer(duration, 1, gameModel);
        Future<void>.delayed(Duration(milliseconds: widget.animTime * 4), () {
          infoRowDynamicContent!.startTimer!();
          infoRowDefaultLayout = true;
        });
      };

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
                            child: infoRowDynamicContent)),
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
        infoRowDynamicContent = InfoRowDynamicContent(toShowLayout);
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
       infoRowDynamicContent = InfoRowDynamicContent(toShowLayout);
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

      gameModel.cancelTimerCallback = (){
        infoRowDynamicContent!.cancelTimer!();
        playerTimer.cancel();
      };
      gameModel.createPlayerTimer(playerTimer);
    });
  }
}