
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
  late AnimationController fullBarController;
  late bool fullBar;
  Color barColorStart = Colors.white;
  Color barColorEnd = Colors.white;
  int playedCardsNum = 0;
  double endChartBarRatio = 0;
  double startChartBarRatio = 0;
  String? barTypology;
  Widget chartContent = const Spacer();
  int startBarValue = 0;


  void initState() {
    super.initState();
    indicatorController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    fullBarController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    fullBarController.addListener(() {
      setState(() {
      });
    });
    fullBar = false;
  }

  @override
  void dispose(){
    super.dispose();
    indicatorController.dispose();
    fullBarController.dispose();
  }

  Widget staticChartBar(){
    return CircularProgressIndicator(value: endChartBarRatio, color: Color.lerp(barColorStart, barColorEnd, endChartBarRatio),
        backgroundColor: barColorEnd.withOpacity(0.2),
        strokeWidth: widget.usableHeight * 0.075);
  }

  Widget fullChartBar() {
          var colorAnim = ColorTween(begin: barColorEnd, end: barColorEnd.withOpacity(0.5)).animate(fullBarController);
          return CircularProgressIndicator(value: 1, valueColor: colorAnim,
              strokeWidth: widget.usableHeight * 0.075 + (widget.usableHeight * 0.02 * fullBarController.value));
      }


  Widget dynamicChartBar(GameModel gameModel, Function animCallback) {
      if(startBarValue == 0){
        startBarValue = setStartBarValue(gameModel);
      }
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
                  backgroundColor: barColorEnd.withOpacity(0.2),
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
        if(endChartBarRatio==1){
          fullBar = true;
          fullBarController.repeat(reverse : true);
          setFullBarFalse();
        }
      });
    }
  }

  void fullBarCallback(){
    setState(() {
      setFullBarFalse();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {
      if(fullBar){
          chartContent = fullChartBar();
      }
      else{
          if(playedCardsNum != gameModel.playedCardsPerTeam[widget.team]?.length){
            chartContent = dynamicChartBar(gameModel, animCallback);
          }
          else{
            chartContent = staticChartBar();
          }
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
        //Context context = gameModel.gameLogic.contextList.where((element) => element.code==gameModel.masterContextCode).single;
        //int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initSmog;
        //int contextModInitStat = (baseInitStat * context.startStatsInfluence["A"]!).round();

        int  maxRange = (startBarValue! - target).abs();
        int actualRange = (teamInfo!.smog! - startBarValue!);

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
        //Context context = gameModel.gameLogic.contextList.where((element) => element.code==gameModel.masterContextCode).single;
        //int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initEnergy;
        //int contextModInitStat = (baseInitStat * context.startStatsInfluence["E"]!).round();

        int  maxRange = (startBarValue - target).abs();
        int actualRange = (teamInfo!.energy! - startBarValue);

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
        //Context context = gameModel.gameLogic.contextList.where((element) => element.code==gameModel.masterContextCode).single;
        //int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initComfort;
        //int contextModInitStat = (baseInitStat * context.startStatsInfluence["C"]!).round();

        int  maxRange = (startBarValue! - target).abs();
        int actualRange = (teamInfo!.comfort! - startBarValue!);

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

  setStartBarValue(GameModel gameModel){

    String objType = gameModel.objectivePerTeam[widget.team]!;
    int lv = gameModel.gameLogic.masterLevelCounter;
    Context context = gameModel.gameLogic.contextList.where((element) => element.code==gameModel.masterContextCode).single;

    int startValue = 0;

    switch(objType){
      case "smog" : {
        int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initSmog;
        startValue = (baseInitStat * context.startStatsInfluence["A"]!).round();

          gameModel.gameLogic.obtainPlayedCardsStatsMap({ for (var entry in gameModel.playedCardsPerTeam[widget.team]!.entries.where((element) => element.value.code!="no Card"))
          entry.key : gameModel.gameLogic.findCard(entry.value.code, context.code, lv)! })
            .forEach((key, value) {
              startValue += value.smog;
            });
      }
      break;
      case "comfort" : {
        int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initComfort;
        startValue = (baseInitStat * context.startStatsInfluence["C"]!).round();

        gameModel.gameLogic.obtainPlayedCardsStatsMap({ for (var entry in gameModel.playedCardsPerTeam[widget.team]!.entries.where((element) => element.value.code!="no Card"))
          entry.key : gameModel.gameLogic.findCard(entry.value.code, context.code, lv)! })
            .forEach((key, value) {
          startValue += value.comfort;
        });

      }
      break;
      case "energy" : {
        int baseInitStat = gameModel.gameLogic.zoneMap[gameModel.gameLogic.masterLevelCounter]!.initEnergy;
        startValue = (baseInitStat * context.startStatsInfluence["E"]!).round();

        gameModel.gameLogic.obtainPlayedCardsStatsMap({ for (var entry in gameModel.playedCardsPerTeam[widget.team]!.entries.where((element) => element.value.code!="no Card"))
          entry.key : gameModel.gameLogic.findCard(entry.value.code, context.code, lv)! })
            .forEach((key, value) {
          startValue += value.energy;
        });

      }
      break;
      default : {
        startValue = 0;
      }
    }

    return startValue;

  }


  Future<void> setFullBarFalse(){
    return Future.delayed(const Duration(seconds: 3), () {
      setState((){
        fullBarController.stop();
        fullBar = false;
      });
    });
  }


}