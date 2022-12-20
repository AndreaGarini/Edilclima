
import 'dart:async';

import 'package:edilclima_app/DataClasses/Zone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/TeamInfo.dart';
import '../../GameModel.dart';
import '../../Screens/WaitingScreen.dart';

class GameBoardChartBar extends StatefulWidget{

  String barType;
  String team;
  double usableHeight;
  GameBoardChartBar(this.team, this.barType, this.usableHeight);

  @override
  State<StatefulWidget> createState() => GameBoardChartBarState();

}


class GameBoardChartBarState extends State<GameBoardChartBar> {

  double endChartBarRatio = 0;
  double startChartBarRatio = 0;

  Color barColor = Colors.white;

  bool buildEnded = false;
  int playedCardsNum = 0;


  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {

      //todo: finita l'animazione si azzera il value, se giochi una carta non cambia il valore del container,
      //potresti usare la transform sul container anzichè l'animated builder
      dynamicChartBar(){
        print("build ended: ${buildEnded}");
        print("second condition : ${playedCardsNum != gameModel.playedCardsPerTeam[widget.team]?.length}");
        if (buildEnded && playedCardsNum != gameModel.playedCardsPerTeam[widget.team]?.length){
          print("updata data called");
          print("playedCardsNum : ${playedCardsNum}");
          print("played card in gm . ${gameModel.playedCardsPerTeam[widget.team]?.length}");
          calculateNewBarRatio(gameModel);
          return TweenAnimationBuilder<double>(duration: const Duration(seconds: 20),
              curve: Curves.easeInOut,
              tween: Tween<double>(
                  begin: startChartBarRatio,
                  end: endChartBarRatio
              ),
              onEnd: () {
            startChartBarRatio = endChartBarRatio;
            setState(() {
              playedCardsNum = gameModel.playedCardsPerTeam[widget.team]!.length;
            });
            },
              builder: (context, value, _) {
                return Container(height: value * widget.usableHeight,
                    decoration: BoxDecoration(color: barColor, borderRadius: const BorderRadius.all(Radius.circular(20))));
              });
        }
        else {
          return Container(height: 0);
        }
      }

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        notifyBuildEnded(gameModel);
      });

      //todo: trasforma il colore delle barre in un gradiente progressivo in base al value
      return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Spacer(),
          Expanded(flex: 2, child: Column(mainAxisSize: MainAxisSize.max,  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    dynamicChartBar()
                                    ])),
          const Spacer()
        ]);
    });
  }

  void calculateNewBarRatio(GameModel gameModel){
          switch (widget.barType){
            case "smog": {
              barColor = Colors.red;
              if(gameModel.teamStats[widget.team]?.smog == null){
                  endChartBarRatio = 0;
              }
              else{
                  endChartBarRatio = generateTeamInfoMap(gameModel.teamStats[widget.team]!, gameModel);
              }
            }
            break;
            case "energy": {
              barColor = Colors.blue;
              if(gameModel.teamStats[widget.team]?.energy == null){
                  endChartBarRatio = 0;
              }
              else{
                  endChartBarRatio = generateTeamInfoMap(gameModel.teamStats[widget.team]!, gameModel);
              }
            }
            break;
            case "comfort": {
              barColor = Colors.green;
              if(gameModel.teamStats[widget.team]?.comfort == null){
                  endChartBarRatio = 0;
              }
              else{
                  endChartBarRatio = widget.usableHeight * generateTeamInfoMap(gameModel.teamStats[widget.team]!, gameModel);
              }
            }
            break;
            default: {
              barColor = Colors.black;
                endChartBarRatio = 0;
            }
            break;
          }
  }

  Future<void> notifyBuildEnded(GameModel gameModel) async{
    return Future<void>.delayed(const Duration(milliseconds: 100), () {setState(() {
      buildEnded = true;
    });});
  }

  double generateTeamInfoMap(TeamInfo teamInfo, GameModel gameModel){

    double ratio;
    switch(widget.barType){
      case "smog" : {
        ratio = ((teamInfo!.smog! - gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initSmog).abs() /
            (gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initSmog -
            gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.TargetA)).abs();
      }
      break;
      case "energy" : {
        ratio = ((teamInfo!.energy! - gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initEnergy).abs() /
            (gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initEnergy -
            gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.TargetE)).abs();
      }
      break;
      case "comfort" : {
        ratio = ((teamInfo!.comfort! - gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initComfort).abs() /
            (gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initComfort -
            gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.TargetC)).abs();
      }
      break;
      default : {
        ratio = 0;
      }
      break;

    }
    return ratio;
  }


}