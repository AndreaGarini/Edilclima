
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/TeamInfo.dart';
import '../../GameModel.dart';

class GameBoardChartBar extends StatefulWidget{

  String barType;
  String team;
  double usableHeight;

  GameBoardChartBar(this.barType, this.team, this.usableHeight);

  @override
  State<StatefulWidget> createState() => GameBoardChartBarState();

}

class GameBoardChartBarState extends State<GameBoardChartBar>
with TickerProviderStateMixin{

  late AnimationController indicatorController;
  Color barColorStart = Colors.white;
  Color barColorEnd = Colors.white;
  int playedCardsNum = 0;
  double endChartBarRatio = 0;
  double startChartBarRatio = 0;

  void initState() {
    super.initState();
    indicatorController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose(){
    super.dispose();
    indicatorController.dispose();
  }

  staticChartBar(){
    return CircularProgressIndicator(value: endChartBarRatio, color: Color.lerp(barColorStart, barColorEnd, endChartBarRatio)
        ,strokeWidth: widget.usableHeight * 0.05);
  }


  dynamicChartBar(GameModel gameModel, Function animCallback) {
      calculateNewBarRatio(gameModel);

      if(endChartBarRatio!=startChartBarRatio){
        return TweenAnimationBuilder<double>(duration: const Duration(seconds: 3),
            curve: Curves.easeInOut,
            tween: Tween<double>(
                begin: startChartBarRatio,
                end: endChartBarRatio
            ),
            onEnd: () {animCallback(gameModel);},
            builder: (context, value, _) {
              var colorAnim = ColorTween(begin: barColorStart, end: barColorEnd).animate(indicatorController);
              indicatorController.value = value;
              return CircularProgressIndicator(value: value, valueColor: colorAnim,
                strokeWidth: widget.usableHeight * 0.05,);
            });
      }
      else{
        return staticChartBar();
      }
  }

  void animCallback(GameModel gameModel){
    if(startChartBarRatio != endChartBarRatio){
      setState(() {
        startChartBarRatio = endChartBarRatio;
        playedCardsNum = gameModel.playedCardsPerTeam[widget.team]!.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {
      //todo: dai alle barre del grafico dei colori che facciano capire cosa sono (stessi colori dei valori delle carte)

      return (playedCardsNum != gameModel.playedCardsPerTeam[widget.team]?.length) ?
             dynamicChartBar(gameModel, animCallback) : staticChartBar();
    });
  }

  void calculateNewBarRatio(GameModel gameModel){
          switch (widget.barType){
            case "smog": {
              barColorStart = lightOrangePalette.withAlpha(200);
              barColorEnd = lightOrangePalette;
              if(gameModel.teamStats[widget.team]?.smog == null){
                  endChartBarRatio = 0;
              }
              else{
                  endChartBarRatio = generateTeamInfoMap(gameModel.teamStats[widget.team]!, gameModel);
              }
            }
            break;
            case "energy": {
              barColorStart = darkBluePalette.withAlpha(200);
              barColorEnd = darkBluePalette;
              if(gameModel.teamStats[widget.team]?.energy == null){
                  endChartBarRatio = 0;
              }
              else{
                  endChartBarRatio = generateTeamInfoMap(gameModel.teamStats[widget.team]!, gameModel);
              }
            }
            break;
            case "comfort": {
              barColorStart = lightBluePalette.withAlpha(200);
              barColorEnd = lightBluePalette;
              if(gameModel.teamStats[widget.team]?.comfort == null){
                  endChartBarRatio = 0;
              }
              else{
                  endChartBarRatio = generateTeamInfoMap(gameModel.teamStats[widget.team]!, gameModel);
              }
            }
            break;
            default: {
              barColorEnd = Colors.black;
              barColorStart = Colors.black;
                endChartBarRatio = 0;
            }
            break;
          }

          print("calculate new bar ratio value: ${endChartBarRatio}");
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

    if(ratio > 1) return 1;
    else if(ratio <= 0) return 0.02;
    else return ratio;
  }


}