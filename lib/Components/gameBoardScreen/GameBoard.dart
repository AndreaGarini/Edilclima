
import 'package:edilclima_app/Components/gameBoardScreen/GameBoardInfoCircle.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';
import 'GameBoardCard.dart';

class GameBoard extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => GameBoardState();

}

class GameBoardState extends State<GameBoard> {

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child)
    {
      double cardHeight = screenHeight / (gameModel.teamsNum / 2).toInt();
      List<Widget> columnContent = [];

      for(double i = 0; i < gameModel.teamsNum / 2; i++) {
        columnContent.add(Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: (gameModel.teamsNum % 2 == 0) ?

            [Expanded(child: GameBoardCard(gameModel.teamsNames[i.toInt() * 2],  cardHeight)),
              Expanded(child: GameBoardCard(gameModel.teamsNames[i.toInt() * 2 + 1],  cardHeight))] :

            [Expanded(child: GameBoardCard(gameModel.teamsNames[i.toInt() * 2],  cardHeight))]
        )));
      }


      return Stack(alignment: Alignment.center, children: [
          Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: columnContent,),
          GameBoardInfoCircle(screenHeight)
        ]);
    });
  }
}