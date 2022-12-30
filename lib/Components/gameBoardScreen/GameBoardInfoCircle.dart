
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';
import '../../Screens/WaitingScreen.dart';

class GameBoardInfoCircle extends StatefulWidget{

  double usableHeight;
  GameBoardInfoCircle(this.usableHeight);

  @override
  State<StatefulWidget> createState() => GameBoardInfoCircleState();

}

class GameBoardInfoCircleState extends State<GameBoardInfoCircle> {
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

      return Container(height: widget.usableHeight * 0.2, width: widget.usableHeight + 0.2,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
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
              strokeWidth: widget.usableHeight * 0.01,)),
          gameModel.ongoingLevel ? dynamicButton() : dynamicTimer(),
        ]));
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