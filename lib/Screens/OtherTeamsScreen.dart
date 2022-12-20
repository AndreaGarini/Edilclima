
import 'package:edilclima_app/Components/OtherTeamsScreen/TeamCardLayout.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      return ListView(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(width: screenWidth, height: screenHeight * 0.1,
            child: const Center(child: Text("your team", style: TextStyle(color: Colors.black)))),
            Divider(color: Colors.black, indent: screenWidth * 0.2, endIndent: screenWidth * 0.2),
            SizedBox(width: screenWidth, height: screenHeight * 0.1),
            SizedBox(width: screenWidth, height: screenHeight * 0.4,
            child: Center(child:
            TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key==gameModel.team).single))),
            SizedBox(width: screenWidth, height: screenHeight * 0.1),
            Divider(color: Colors.black, indent: screenWidth * 0.2, endIndent: screenWidth * 0.2),
            SizedBox(width: screenWidth, height: screenHeight * 0.1,
            child: const Center(child: Text("Other teams"))),
            SizedBox(width: screenWidth, height: screenHeight * 0.1),
            SizedBox(width: screenWidth, height: screenHeight * 0.4,
            child: TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key!=gameModel.team).toList()[0])),
            SizedBox(width: screenWidth, height: screenHeight * 0.4,
            child: TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key!=gameModel.team).toList()[1])),
            SizedBox(width: screenWidth, height: screenHeight * 0.4,
            child: TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key!=gameModel.team).toList()[2]))
      ]);
          });
    }
  }