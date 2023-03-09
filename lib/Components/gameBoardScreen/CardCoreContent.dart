
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import 'GameBoardChartBar.dart';
import 'GameBoardPngStack.dart';

class CardCoreContent extends StatelessWidget{

  String team;
  double usableHeight;
  String chartType;
  CardCoreContent(this.team, this.usableHeight, this.chartType);

  @override
  Widget build(BuildContext context) {

       return  Stack(alignment: Alignment.topLeft,
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
        Container(color: Colors.transparent, height: usableHeight * 0.3, width: usableHeight * 0.3,
        child: GameBoardChartBar(chartType, team, usableHeight)),
        ]))))]);
  }

}