
import 'package:edilclima_app/Components/OtherTeamsScreen/TeamCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/generalFeatures/ColorPalette.dart';
import '../Components/generalFeatures/GradientText.dart';
import '../GameModel.dart';

class OtherTeamsScreen extends StatefulWidget{


  @override
  State<OtherTeamsScreen> createState() => OtherTeamsScreenState();

}

class OtherTeamsScreenState extends State<OtherTeamsScreen> {

  //todo: qui se vuoi aggiungi il fab per andare alla classifica generale
  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      return
        Material(color: Colors.white,
        child:
        ListView(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(width: screenWidth, height: screenHeight * 0.1,
            child: Center(child: Text("Your team", style:
            TextStyle(color: darkBluePalette,
                fontSize: screenHeight * 0.05,
                fontWeight: FontWeight.bold)))),
            SizedBox(width: screenWidth, height: screenHeight * 0.4,
            child: TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key==gameModel.team).single)),
            SizedBox(width: screenWidth, height: screenHeight * 0.1,
            child: Center(child: Text("Other teams", style:
            TextStyle(color: darkBluePalette,
                fontSize: screenHeight * 0.05,
                fontWeight: FontWeight.bold)))),
            SizedBox(width: screenWidth, height: screenHeight * 0.4,
            child: TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key!=gameModel.team).toList()[0])),
            SizedBox(width: screenWidth, height: screenHeight * 0.05),
            SizedBox(width: screenWidth, height: screenHeight * 0.4,
            child: TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key!=gameModel.team).toList()[1])),
            SizedBox(width: screenWidth, height: screenHeight * 0.05),
            SizedBox(width: screenWidth, height: screenHeight * 0.4,
            child: TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key!=gameModel.team).toList()[2]))
      ]));
          });
    }
  }