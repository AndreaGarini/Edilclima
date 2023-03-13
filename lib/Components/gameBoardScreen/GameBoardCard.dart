
import 'package:collection/collection.dart';
import 'package:edilclima_app/Components/gameBoardScreen/CardCoreContent.dart';
import 'package:edilclima_app/DataClasses/LevelEndedStats.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'GameBoardDynamicPoints.dart';
import 'GameBoardPositionedPoints.dart';

class GameBoardCard extends StatefulWidget{

  String team;
  String chartType;
  double usableHeight;
  Function? startCrdCallback;
  Function? endCrdCallback;
  Function? medalCallback;
  GameBoardCard(this.team, this.chartType,  this.usableHeight);

  @override
  State<StatefulWidget> createState() => GameBoardCardState();

}

class GameBoardCardState extends State<GameBoardCard>{

  LevelEndedStats? endingStats;
  String? imgPath;
  int? rank;

  int animPhase = 0;
  List<String> phases = ["cards", "target", "moves"];
  Map<String, double> xPosPerPtsType = {
    "cards": screenWidth * 0.25,
    "target": screenWidth * 0.1,
    "moves": screenWidth * 0.25,
    "dynamic": screenWidth * 0.33};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      widget.startCrdCallback ??= levelEndedCardSequence;
      widget.endCrdCallback ??= killEndingSequence;
    });


    return  Card(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)),
        elevation: 10,
        child:
        Stack(alignment: Alignment.topLeft,
            children: [
              CardCoreContent(widget.team, widget.usableHeight, widget.chartType),
              endingStats!=null ?  GameBoardDynamicPoints(widget.team, widget.usableHeight, phases[animPhase],
                  endingStats!, xPosPerPtsType["dynamic"]!, rank!) : const SizedBox(),
              endingStats!=null ?  GameBoardPositinedPoints(widget.usableHeight, phases[animPhase],
                  endingStats!, xPosPerPtsType[phases[animPhase]]!, nextPhase) : const SizedBox(),
            ]));
  }

  void levelEndedCardSequence(Map<String, LevelEndedStats> map) {
    setState(() {
      if(endingStats == null){
      rank = map.entries.sortedBy<num>((entry) => entry.value.getTotalPoints()).reversed
          .map((entry) => entry.key).toList().indexOf(widget.team);
      endingStats = map[widget.team];
      }
    });
  }

  void killEndingSequence(){
      setState(() {
        endingStats = null;
      });
  }

  void nextPhase(){
    if(animPhase < 2){
      setState(() {
        animPhase++;
      });
    }
  }
}