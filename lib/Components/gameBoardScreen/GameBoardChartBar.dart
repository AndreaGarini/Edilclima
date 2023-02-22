
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/Context.dart';
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
  String? barTypology;
  Widget chartContent = const Spacer();

  void initState() {
    super.initState();
    indicatorController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose(){
    super.dispose();
    indicatorController.dispose();
  }

  Widget staticChartBar(){
    return CircularProgressIndicator(value: endChartBarRatio, color: Color.lerp(barColorStart, barColorEnd, endChartBarRatio)
        ,strokeWidth: widget.usableHeight * 0.075);
  }


  Widget dynamicChartBar(GameModel gameModel, Function animCallback) {
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
                  strokeWidth: widget.usableHeight * 0.075);
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
      if(playedCardsNum != gameModel.playedCardsPerTeam[widget.team]?.length){
        chartContent = dynamicChartBar(gameModel, animCallback);
      }
      else{
        chartContent = staticChartBar();
      }

      return chartContent;
    });
  }

  void calculateNewBarRatio(GameModel gameModel){

          String objType = gameModel.objectivePerTeam[widget.team]!;

          switch (objType){
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
  }

  double generateTeamInfoMap(TeamInfo teamInfo, GameModel gameModel){

    double ratio;
    String objType = gameModel.objectivePerTeam[widget.team]!;

    switch(objType){
      case "smog" : {
        int target = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.TargetA;
        Context context = gameModel.gameLogic.contextList.where((element) => element.code==gameModel.masterContextCode).single;
        int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initSmog;
        int contextModInitStat = (baseInitStat * context.startStatsInfluence["A"]!).round();

        int  maxRange = (contextModInitStat - target).abs();
        int actualRange = (teamInfo!.smog! - contextModInitStat);

        if(actualRange < 0){
          ratio = (actualRange.abs() / maxRange).abs();
        }
        else{
          ratio = 0.03;
        }

      }
      break;
      case "energy" : {
        int target = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.TargetE;
        Context context = gameModel.gameLogic.contextList.where((element) => element.code==gameModel.masterContextCode).single;
        int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initEnergy;
        int contextModInitStat = (baseInitStat * context.startStatsInfluence["E"]!).round();

        int  maxRange = (contextModInitStat - target).abs();
        int actualRange = (teamInfo!.energy! - contextModInitStat);

        if(actualRange > 0){
          ratio = (actualRange.abs() / maxRange).abs();
        }
        else{
          ratio = 0.03;
        }
      }
      break;
      case "comfort" : {
        int target = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.TargetC;
        Context context = gameModel.gameLogic.contextList.where((element) => element.code==gameModel.masterContextCode).single;
        int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initComfort;
        int contextModInitStat = (baseInitStat * context.startStatsInfluence["C"]!).round();

        int  maxRange = (contextModInitStat - target).abs();
        int actualRange = (teamInfo!.comfort! - contextModInitStat);

        if(actualRange > 0){
          ratio = (actualRange.abs() / maxRange).abs();
        }
        else{
          ratio = 0.03;
        }

      }
      break;
      default : {
        ratio = 0;
      }
      break;

    }

    if(ratio > 1) return 1;
    else return ratio;
  }


}