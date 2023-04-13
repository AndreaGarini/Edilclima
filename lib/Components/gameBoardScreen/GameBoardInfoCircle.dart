
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';
import '../../Screens/WaitingScreen.dart';

class GameBoardInfoCircle extends StatefulWidget{

  double usableHeight;
  Function killDynamicPoints;
  GameBoardInfoCircle(this.usableHeight, this.killDynamicPoints);

  @override
  State<StatefulWidget> createState() => GameBoardInfoCircleState();

}

class GameBoardInfoCircleState extends State<GameBoardInfoCircle> {

  late final  GlobalKey<TooltipState> tooltipkey;
  @override
  void initState() {
    super.initState();
    tooltipkey = GlobalKey<TooltipState>();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {

      //todo: controlla che i metodi lato game model fungano ed anche il timer centrale

      dynamicTimer() {
        if(gameModel.levelTimerCountdown!=null){
          String text = timeFormatMinSec(gameModel.levelTimerCountdown);
          return Text(text,
                  style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.3 * 0.1));
        }
        else{
          return const Text("");
        }
      }
      dynamicButton(){
        switch(gameModel.masterLevelStatus){
          case "preparing":
                {
                  String text ="Prepara livello ${gameModel.gameLogic.masterLevelCounter}";
                  return SizedButton(
                      screenHeight * 0.2, text,
                       () {
                        if(gameModel.gameLogic.masterLevelCounter!= 1){
                          widget.killDynamicPoints();
                        }
                        gameModel.prepareLevel(gameModel.gameLogic.masterLevelCounter);
                      });
                }
          case "play":
             {
               String text = "inizia livello ${gameModel.gameLogic.masterLevelCounter}";
               return Tooltip(
                   message: "Tutti i giocatori devono finire il tutorial",
                   textStyle: TextStyle(color: darkBluePalette, fontSize: screenWidth * 0.03, fontWeight: FontWeight.normal),
                   margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),
                       boxShadow: [BoxShadow(
                         color: lightBluePalette,
                         spreadRadius: 2,
                         blurRadius: 2,
                         offset: const Offset(0, 0), // changes position of shadow
                       )]),
                   showDuration: const Duration(seconds: 2),
                   triggerMode: TooltipTriggerMode.manual,
                   key: tooltipkey,
                   child: SizedButton(
                       screenHeight * 0.2,
                       text,
                           () {
                         gameModel.checkPlayerTutorialFinished().then((value) {
                           if(value){
                             gameModel.startLevel();
                           }
                           else{
                             tooltipkey.currentState?.ensureTooltipVisible();
                             Future.delayed(const Duration(seconds: 2), (){
                               tooltipkey.currentState?.deactivate();
                             });
                           }
                         });
                       })
               );
             }
          case "ended":
             {
               String text = "Fine partita";
               return SizedButton(
                   screenHeight * 0.2, text,
                   (){context.go("/initialScreen");});
             }
        }

      }

      return Container(height: widget.usableHeight * 0.2, width: widget.usableHeight + 0.2,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ]),
        child: Stack(alignment: Alignment.center,
        children: [
          Container(height: widget.usableHeight * 0.18, width: widget.usableHeight * 0.18,
              color: Colors.transparent,
              child:
              CircularProgressIndicator(value: gameModel.levelTimerCountdown==null ? 0.0 : (gameModel.levelTimerCountdown!/420),
                color: gameModel.levelTimerCountdown==null ? Colors.white :
                Color.lerp(Colors.teal, Colors.tealAccent, (gameModel.levelTimerCountdown!/420)),
              strokeWidth: widget.usableHeight * 0.015,)),
          Container(height: widget.usableHeight * 0.18, width: widget.usableHeight * 0.18,
              color: Colors.transparent,
              child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Spacer(),
                  Expanded(flex: 1, child: Center(child: gameModel.ongoingLevel ? dynamicTimer() : dynamicButton())),
                  const Spacer()
                ],))
        ]));
    });
  }

  String timeFormatMinSec(int? levelTimer){
    if(levelTimer!=null){
      var minutes = (levelTimer/60).truncate();
      var seconds = (levelTimer%60).toInt();

      if(seconds <10) {
        return "${minutes} : 0${seconds}";
      } else {
        return "${minutes} : ${seconds}";
      }
    }
    else {
      return "null";
    }
  }
}