
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/CardData.dart';
import '../../GameModel.dart';

class RetrivePageLayout extends StatefulWidget {

  int pos;

  RetrivePageLayout(this.pos);

  @override
  State<StatefulWidget> createState() => RetriveCardLayoutState();

}

class RetriveCardLayoutState extends State<RetrivePageLayout>{

  late bool ableToRetrive;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      String month = gameModel.gameLogic.months[widget.pos];
      Map<String, String> playedCards = gameModel.playedCardsPerTeam[gameModel.team]!;
      CardData? cardData = gameModel.gameLogic.findCard(playedCards[month] ?? "null");
      ableToRetrive = cardData!=null && gameModel.playerTimer!=null;

      return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DetailedCardLayout(cardData),
        SizedButton(screenWidth * 0.3, "Retrive card",ableToRetrive ? (){
          gameModel.retriveCardInPos(widget.pos);
          buttonCallback(gameModel);} : null)
      ],);
    });
  }

  void buttonCallback(GameModel gameModel){
    gameModel.stopPlayerTimer();
    gameModel.setTimeOutTrue();
  }


}