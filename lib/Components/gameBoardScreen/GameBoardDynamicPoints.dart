
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../DataClasses/LevelEndedStats.dart';

class GameBoardDynamicPoints extends StatefulWidget{

    String team;
    double usableHeight;
    LevelEndedStats endingStats;
    String phase;
    double xPos;
    int rank;
    GameBoardDynamicPoints(this.team, this.usableHeight, this.phase, this.endingStats, this.xPos, this.rank);

    @override
    State<StatefulWidget> createState() => GameBoardDynamicPointsState();
}

class GameBoardDynamicPointsState extends State<GameBoardDynamicPoints>
 with SingleTickerProviderStateMixin{

  late int initPoints;
  late int pointsDelta;
  late int totalPoints;
  String oldPhase = "cards";
  String? imgPath;
  int duration = 2000; //in milliseconds

  late AnimationController ptsController;

  @override
  void initState() {
    super.initState();
    ptsController = AnimationController(vsync: this, duration: Duration(milliseconds: duration))..addListener(() {
      setState(() {});
    });
    initPoints = widget.endingStats.oldPoints;
    pointsDelta = widget.endingStats.cardsPoints;
    totalPoints = widget.endingStats.oldPoints + widget.endingStats.targetPoints + widget.endingStats.cardsPoints - widget.endingStats.movesPoints;
    ptsController.forward(from: 0.0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if(widget.phase != oldPhase){
        oldPhase = widget.phase;
        setNewState();
      }
    });

    return imgPath != null ?
      Positioned(top: widget.usableHeight * 0.2, right: 0, child:
      SizedBox(width: screenWidth * 0.15, height: widget.usableHeight * 0.5, child:
      Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(child: Center(child:
              RichText(text: TextSpan(children:[
              TextSpan(
              text: "$totalPoints",
              style: TextStyle(color: darkBluePalette, fontSize: widget.usableHeight * 0.15, fontWeight: FontWeight.bold)),
              TextSpan(
              text: " pts",
              style: TextStyle(color: darkBluePalette, fontSize: widget.usableHeight * 0.05, fontWeight: FontWeight.normal)),
              ])))),
            Expanded(child: Center(child: Image.asset(imgPath!,
                width: (widget.usableHeight * 0.4- (widget.usableHeight * 0.1 * ptsController.value)),
                height: (widget.usableHeight * 0.4 - (widget.usableHeight * 0.1 * ptsController.value))))),
          ])))
      : Positioned(top: widget.usableHeight * 0.2, right : 0, child:
        SizedBox(width: screenWidth * 0.15, height: widget.usableHeight * 0.5, child:
        Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: Center(child:  RichText(text: TextSpan(children:[
                TextSpan(
                    text: "${initPoints + (ptsController.value * pointsDelta).round()}",
                    style: TextStyle(color: darkBluePalette, fontSize: widget.usableHeight * 0.15, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: " pts",
                    style: TextStyle(color: darkBluePalette, fontSize: widget.usableHeight * 0.05, fontWeight: FontWeight.normal)),
              ])))),
              const Spacer(),
            ])));
  }

  void setNewState(){
    switch(widget.phase){
      case "target": {
        setState((){
          initPoints += widget.endingStats.cardsPoints;
          pointsDelta = widget.endingStats.targetPoints;
        });
        ptsController.forward(from: 0.0);
      }
      break;
      case "moves": {
        setState((){
          initPoints += widget.endingStats.targetPoints;
          pointsDelta = -widget.endingStats.movesPoints;
        });
        ptsController.forward(from: 0.0);

        //todo: controlla che sia giusto
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            switch (widget.rank){
              case 0: {
                imgPath = "assets/images/medal.png";
              }
              break;
              case 1: {
                imgPath = "assets/images/medal-2.png";
              }
              break;
              case 2: {
                imgPath = "assets/images/medal-3.png";
              }
              break;
              default: {
                imgPath = null;
              }
            }
            duration = 1000;
          });
          ptsController.forward(from: 0.0);
        });
      }
      break;
    }
  }
}