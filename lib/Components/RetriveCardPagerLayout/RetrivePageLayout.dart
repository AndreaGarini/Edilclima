
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/DataClasses/Context.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/CardData.dart';
import '../../DataClasses/CardInfluence.dart';
import '../../DataClasses/Pair.dart';
import '../../GameModel.dart';

class RetrivePageLayout extends StatefulWidget {

  int pos;

  RetrivePageLayout(this.pos);

  @override
  State<StatefulWidget> createState() => RetriveCardLayoutState();

}

class RetriveCardLayoutState extends State<RetrivePageLayout>{

  late bool ableToRetrive;
  late Map<String, Map<String, String>>? cardInfData;
  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      String month = gameModel.gameLogic.months[widget.pos];
      Map<String, CardData> playedCards = gameModel.playedCardsPerTeam[gameModel.team]!;
      CardData? cardData = playedCards.keys.contains(month) ? playedCards[month] : null;
      CardData? baseCardData = cardData!=null ? gameModel.gameLogic.CardsMap[cardData!.code] : null;
      ableToRetrive = cardData!=null && gameModel.playerTimer!=null;
      cardInfData = cardData!=null ? generateCardInfData(gameModel, baseCardData!) : null;

      if(cardData?.code == "inv01"){
        print("card data in retrive page layout: ${cardData!.energy}");
        print("card base data in retrive page layout: ${baseCardData!.energy}");
      }

      return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DetailedCardLayout(cardData, baseCardData, cardInfData),
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

  Map<String, Map<String, String>> generateCardInfData(GameModel gameModel, CardData baseCardData){

    Map<String, Map<String, String>> avatarMap = {"Up" : {}, "Nerf" : {}};
    
    //Context Inf 
    Context ctx = gameModel.gameLogic.contextList.where((element) => element.code==gameModel.playerContextCode).single; 
    if(ctx.nerfList!=null && ctx.nerfList!.contains(baseCardData.code)){
      avatarMap["Nerf"]!.putIfAbsent("Ctx", () => ctx.code);
    }
    if(ctx.PUList!=null && ctx.PUList!.contains(baseCardData.code)){
      avatarMap["Up"]!.putIfAbsent("Ctx", () => ctx.code);
    }

    //MulFac
      String zoneString = "";
      switch(gameModel.playerLevelCounter){
        case 1: {
          zoneString = "Casa";
        }
        break;
        case 2: {
          zoneString = "Appartamento";
        }
        break;
        case 3:{
          zoneString = "Condominio";
        }
      }
      avatarMap["Nerf"]!.putIfAbsent("Zone", () => zoneString);

    //Winter effect
    if(["ott", "nov", "dec", "gen", "feb", "mar"].contains(gameModel.gameLogic.months[widget.pos]) && baseCardData.code.contains("imp")){
      avatarMap["Nerf"]!.putIfAbsent("Win", () => "");
    }

    //Other cards effect
    List<String> playedCardsCodes = gameModel.playedCardsPerTeam[gameModel.team]!.values.map((e) => e.code).toList();
      for(Pair pair in baseCardData.inf){
        if(pair.first()!=influence.None){
          CardInfluence infData = pair.second() as CardInfluence;

          if(infData.multiInfluence){
            int playedCardsWithRequirements = playedCardsCodes.where((element) =>
                element.contains(infData.resNeeded)).length;
            if(playedCardsWithRequirements >= infData.multiObjThreshold!){
              avatarMap["Up"]!.putIfAbsent("Card", () => "");
            }
          }
          else{
            if(playedCardsCodes.contains(infData.resNeeded)){
              avatarMap["Up"]!.putIfAbsent("Card", () => "");
            }
          }
        }
      }

    return avatarMap;
  }


}