
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';
import '../../Screens/WaitingScreen.dart';

class GameBoardInfoCircle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => GameBoardInfoCircleState();

}

class GameBoardInfoCircleState extends State<GameBoardInfoCircle> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child)
    {

      dynamicTimer() {
        if(gameModel.levelTimerCountdown!=null){
          String text = timeFormatMinSec(gameModel.levelTimerCountdown);
          return Text(text,
                  style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.3 * 0.1));

        }
        else{
          return const Expanded(flex: 1, child: Text(""));
        }
      }
      dynamicButton(){
        if(gameModel.masterLevelStatus=="preparing"){
          String text = "prepare level ${gameModel.gameLogic.masterLevelCounter}";
          return SizedButton(
              screenWidth * 0.3,
              text,
                  () {gameModel.prepareLevel(gameModel.gameLogic.masterLevelCounter);});
        }
        else{
          String text = "start level ${gameModel.gameLogic.masterLevelCounter}";
          return SizedButton(
              screenWidth * 0.3,
              text,
                  () {gameModel.startLevel();});
        }
      }

      return  Expanded(
        flex: 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(),
            Expanded(flex: 2,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  dynamicButton(),
                  const Spacer()
                ],),),
            Expanded(flex: 2,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  dynamicTimer(),
                  const Spacer()
                ],),),
            const Spacer()
          ]
      ),);
    });
  }

  String timeFormatMinSec(int? levelTimer){
    if(levelTimer!=null){
      var minutes = (levelTimer/60).truncate();
      var seconds = (levelTimer%60).toInt();

      if(seconds <10) {
        return "${minutes}: 0${seconds}";
      } else {
        return "${minutes}: ${seconds}";
      }
    }
    else {
      return "null";
    }
  }
}