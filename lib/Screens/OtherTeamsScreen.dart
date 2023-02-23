
import 'package:edilclima_app/Components/OtherTeamsScreen/TeamCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/generalFeatures/ColorPalette.dart';
import '../Components/generalFeatures/GradientText.dart';
import '../DataClasses/TeamInfo.dart';
import '../GameModel.dart';

class OtherTeamsScreen extends StatefulWidget{


  @override
  State<OtherTeamsScreen> createState() => OtherTeamsScreenState();

}

class OtherTeamsScreenState extends State<OtherTeamsScreen> {


  List<Widget> otherTeamsContent = [];

  //todo: qui se vuoi aggiungi il fab per andare alla classifica generale
  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if(otherTeamsContent.isEmpty){
           List<MapEntry<String, TeamInfo?>> otherTeamsInfo = gameModel.teamStats.entries.where((element)
           => element.key!=gameModel.team).toList();

           List<Widget> content = [
             SizedBox(width: screenWidth, height: screenHeight * 0.1,
                 child: Center(child: Text("Il tuo team", style:
                 TextStyle(color: darkBluePalette,
                     fontSize: screenHeight * 0.05,
                     fontWeight: FontWeight.bold)))),
             SizedBox(width: screenWidth, height: screenHeight * 0.4,
                 child: TeamCardLayout(gameModel.teamStats.entries.where((element) => element.key==gameModel.team).single)),
             otherTeamsInfo.isNotEmpty ? SizedBox(width: screenWidth, height: screenHeight * 0.1,
                 child: Center(child: Text("Gli altri team", style:
                 TextStyle(color: darkBluePalette,
                     fontSize: screenHeight * 0.05,
                     fontWeight: FontWeight.bold)))) : SizedBox(width: screenWidth, height: screenHeight * 0.1),
            ];

           for (int i = 0; i < otherTeamsInfo.length; i++){
              content.add(SizedBox(width: screenWidth, height: screenHeight * 0.4,
                  child: TeamCardLayout(otherTeamsInfo[i])));
           }

           setOtherTeamsContent(content);
        }
      });


      return
        Material(color: Colors.white,
        child:
        ListView(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          children: otherTeamsContent));
          });
    }

      Future<void> setOtherTeamsContent(List<Widget> content) async {
      return Future.delayed(const Duration(milliseconds: 50), (){
        setState(() {
          otherTeamsContent = content;
        });
      });
      }
  }