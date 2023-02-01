
import 'package:edilclima_app/Components/gameBoardScreen/GameBoardPngStack.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GameBoardChartBar.dart';

class GameBoardCard extends StatefulWidget{

  String team;
  double usableHeight;
  GameBoardCard(this.team, this.usableHeight);

  @override
  State<StatefulWidget> createState() => GameBoardCardState();
}

class GameBoardCardState extends State<GameBoardCard> {

  @override
  Widget build(BuildContext context) {
    return  Card(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)),
        elevation: 10,
        child:
        Stack(alignment: Alignment.topLeft,
          children: [
            Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: Center(child: Text(widget.team, style:
                  TextStyle(color: darkBluePalette,
                      fontSize: screenHeight * 0.04,
                      fontWeight: FontWeight.bold)))),
                  Expanded(flex: 4, child: GameBoardPngStack(widget.usableHeight * 0.65, screenWidth * 0.4))]),
            Padding(padding: EdgeInsets.only(top: widget.usableHeight * 0.15, left: widget.usableHeight * 0.05),
              child:
            SizedBox(width: widget.usableHeight * 0.45, height: widget.usableHeight * 0.45,
            child:
            Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                shadowColor: darkGreyPalette,
                child: Stack(alignment: Alignment.center,
                children: [
                  Container(color: Colors.transparent, height: widget.usableHeight * 0.35, width: widget.usableHeight * 0.35,
                    child: GameBoardChartBar("smog", widget.team, widget.usableHeight),),
                  Container(color: Colors.transparent, height: widget.usableHeight * 0.25, width: widget.usableHeight * 0.25,
                    child: GameBoardChartBar("energy", widget.team, widget.usableHeight),),
                  Container(color: Colors.transparent, height: widget.usableHeight * 0.15, width: widget.usableHeight * 0.15,
                    child: GameBoardChartBar("comfort", widget.team, widget.usableHeight),)
                ]))))
        ]));
  }

}