
import 'package:edilclima_app/Components/gameBoardScreen/GameBoardPngStack.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GameBoardChartBar.dart';

class GameBoardCard extends StatelessWidget{

  String team;
  double usableHeight;
  GameBoardCard(this.team, this.usableHeight);

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
                    Expanded(flex: 1, child: Center(child: Text(team, style:
                    TextStyle(color: darkBluePalette,
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold)))),
                    Expanded(flex: 4, child: GameBoardPngStack(usableHeight * 0.65, screenWidth * 0.4, team))]),
              Padding(padding: EdgeInsets.only(top: usableHeight * 0.15, left: usableHeight * 0.05),
                  child:
                  SizedBox(width: usableHeight * 0.45, height: usableHeight * 0.45,
                      child:
                      Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                          shadowColor: darkGreyPalette,
                          child: Stack(alignment: Alignment.center,
                              children: [
                                Container(color: Colors.transparent, height: usableHeight * 0.35, width: usableHeight * 0.35,
                                  child: GameBoardChartBar("smog", team, usableHeight),),
                                Container(color: Colors.transparent, height: usableHeight * 0.25, width: usableHeight * 0.25,
                                  child: GameBoardChartBar("energy", team, usableHeight),),
                                Container(color: Colors.transparent, height: usableHeight * 0.15, width: usableHeight * 0.15,
                                  child: GameBoardChartBar("comfort", team, usableHeight),)
                              ]))))
            ]));
  }
}