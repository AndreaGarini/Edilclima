
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';

class DrawCardFab extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DrawCardFabState();

}

class DrawCardFabState extends State<DrawCardFab> {

  void onTap(GameModel gameModel){

    if(gameModel.drawableCards.isEmpty){
      //gameModel.changePushValue(pushResult.NoDraw);
    }
    else{
      gameModel.drawCard();
      gameModel.stopPlayerTimer();
      gameModel.setTimeOutTrue();
    }
  }

  Widget clickableFab (GameModel gameModel){

    bool ableToDraw = gameModel.playerTimer!=null;

    return InkWell(
        onTap: ableToDraw ? (){onTap(gameModel);} : (){},
        child: SizedBox(
          height: screenWidth * 0.2,
          width: screenWidth * 0.2,
          child: Center(child: Icon(Icons.add_circle_outline,
              color: darkBluePalette,
              size: screenWidth * 0.2)),
        ));
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {
          return clickableFab(gameModel);
    });
  }

}