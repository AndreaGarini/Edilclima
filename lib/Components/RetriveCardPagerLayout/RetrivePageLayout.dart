
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
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
      Map<String, CardData> playedCards = gameModel.playedCardsPerTeam[gameModel.team]!;
      CardData? cardData = playedCards.keys.contains(month) ? playedCards[month] : null;
      ableToRetrive = cardData!=null && gameModel.playerTimer!=null;

      return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DetailedCardLayout(cardData),
        SizedBox(height: screenHeight * 0.01, width: screenWidth * 0.8),
        SizedBox(height: screenHeight * 0.07,
            width: screenWidth * 0.8,
            child: Center(child: SizedButton(screenWidth * 0.6, "Prendi carta", ableToRetrive ? (){
              gameModel.retriveCardInPos(widget.pos);
              buttonCallback(gameModel);} : null)))
      ]);
    });
  }

  void buttonCallback(GameModel gameModel){
    gameModel.stopPlayerTimer();
    gameModel.setTimeOutTrue();
  }


}