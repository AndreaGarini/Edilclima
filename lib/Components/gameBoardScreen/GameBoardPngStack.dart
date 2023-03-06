
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/PngStackLogic.dart';
import '../../GameModel.dart';

class GameBoardPngStack extends StatefulWidget{

  double imageHeight;
  double imageWidth;
  String team;

   GameBoardPngStack(this.imageHeight, this.imageWidth, this.team);

  @override
  State<StatefulWidget> createState() => GameBoardPngStackState();
}

class GameBoardPngStackState extends State<GameBoardPngStack> {

  //todo: considera aggiungere animazioni di entrata
  late bool stackBuilded;
  late List<Widget> stackChildren;
  PngStackLogic pngLogic = PngStackLogic();

  @override
  void initState() {
    super.initState();
    stackBuilded = false;
    stackChildren = [];
  }

  gameBoardCallback(String cardCode, bool isPlayed, int level, String team){
    if(team == widget.team){
      int millisDelay = 0;
      for(List<String> pngStackPathList in pngLogic.getNewPngStack(cardCode, isPlayed, level)){
        List<Widget> pngStackList = pngStackPathList.map((e) => Image.asset(e, height: widget.imageHeight, width: widget.imageWidth)).toList();
        setPngList(millisDelay, pngStackList);
        millisDelay += 2000;
      }
    }
  }
  
  emptyPngStack(String team){
    if(team == widget.team){
      setPngStackEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {

    //todo: come fa il gameModel a sapere quale dei 4 gameBoard deve chiamare?

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {
        if(gameModel.gameBoardPngCallback[widget.team] == null){
          gameModel.gameBoardPngCallback[widget.team] = gameBoardCallback;
        }

        if(gameModel.gameBoardPngEmptyCallback[widget.team] == null){
          gameModel.gameBoardPngEmptyCallback[widget.team] = emptyPngStack;
        }

        WidgetsBinding.instance?.addPostFrameCallback((_){
          if(stackChildren.isEmpty){
            //inizializzo stack png in base al livello
            List<String> playedCardsCodes = gameModel.playedCardsPerTeam[widget.team]!.values.map((e) => e.code).toList();
            List<String> startingCards = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.startingList;
            if(startingCards.toSet().containsAll(playedCardsCodes.toSet()) && playedCardsCodes.length == startingCards.length){
              setPngList(50,  pngLogic.setPngStackFromLevel(gameModel.gameLogic.masterLevelCounter)
                  .map((e) => Image.asset(e, height: widget.imageHeight, width: widget.imageWidth)).toList());
            }
            else{
              //situazione in cui il master esce e rientra nel game board
              pngLogic.setPngStackFromLevel(gameModel.gameLogic.masterLevelCounter);
              List<String> zoneInitCards = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.startingList;
              List<String> newCardsPlayed = gameModel.playedCardsPerTeam[widget.team]!.values
                  .where((element) => !zoneInitCards.contains(element)).map((e) => e.code).toList();
              for (String playedCardCode in newCardsPlayed){
                pngLogic.getNewPngStack(playedCardCode, true, gameModel.gameLogic.masterLevelCounter);
              }
              setPngList(50, pngLogic.getCurrentPngStack().map((e) => Image.asset(e, height: widget.imageHeight, width: widget.imageWidth)).toList());
            }
          }
        });


      return Stack(
        alignment: Alignment.center,
        children: stackChildren,
      );
    });
  }

  void setPngList(int delay, List<Widget> newPngList) {
    Future.delayed(Duration(milliseconds: delay), () {
      setState(() {
        stackChildren = newPngList;
      });
    });
  }
  
  Future<void> setPngStackEmpty() async {
    return Future.delayed(const Duration(milliseconds: 50), (){
      setState(() {
        stackChildren = [];
      });
    });
  }
  

}
