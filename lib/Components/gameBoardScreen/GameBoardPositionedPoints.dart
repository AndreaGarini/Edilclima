
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/LevelEndedStats.dart';
import '../../GameModel.dart';

class GameBoardPositinedPoints extends StatefulWidget{

    double usableHeight;
    String ptsType;
    LevelEndedStats endingStats;
    double xPos;
    Function phaseCallback;
    GameBoardPositinedPoints(this.usableHeight, this.ptsType, this.endingStats, this.xPos, this.phaseCallback);

    @override
    State<StatefulWidget> createState() => GameBoardPositinedPointsState();

}

class GameBoardPositinedPointsState extends State<GameBoardPositinedPoints>
 with SingleTickerProviderStateMixin{

  String? text;
  Color? animColor;
  String? oldType;

  late AnimationController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if(oldType != widget.ptsType){
        oldType = widget.ptsType;
        setNewState();
      }
    });

      return  ctrl.status == AnimationStatus.forward ?
              Positioned(top: widget.usableHeight * 0.3 - (ctrl.value * widget.usableHeight * 0.15), left: widget.xPos,
              child: Center(child: Text(text!, style: TextStyle(color: animColor, fontWeight: FontWeight.normal,
              fontSize:widget.usableHeight * 0.1)))) : const SizedBox();
  }

  void setNewState(){
    switch(widget.ptsType){
      case "target": {
        setState((){
          text = "+ ${widget.endingStats.targetPoints} pts";
          animColor = Colors.green;
        });
        ctrl.forward(from: 0.0);
        Future.delayed(const Duration(milliseconds: 2000), () {
          widget.phaseCallback();
        });
      }
      break;
      case "cards": {
        setState((){
          text = "+ ${widget.endingStats.cardsPoints} pts";
          animColor = Colors.green;
        });
        ctrl.forward(from: 0.0);
        Future.delayed(const Duration(milliseconds: 2000), () {
          widget.phaseCallback();
        });
      }
      break;
      case "moves": {
        setState((){
          text = "- ${widget.endingStats.movesPoints} pts";
          animColor = Colors.red;
        });
        ctrl.forward(from: 0.0);
        Future.delayed(const Duration(milliseconds: 2000), () {
          widget.phaseCallback();
        });
      }
      break;
      default: {
        text = "";
        animColor = Colors.transparent;
      }
    }

  }
}