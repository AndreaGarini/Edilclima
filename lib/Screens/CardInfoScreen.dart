
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
//import 'package:edilclima_app/Screens/NewCardSelectionScreen.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../DataClasses/CardData.dart';
import '../DataClasses/CardInfluence.dart';
import '../DataClasses/Context.dart';
import '../DataClasses/Pair.dart';
import '../GameModel.dart';

class CardInfoScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

      Map<String, CardData> playedCards = gameModel.playedCardsPerTeam[gameModel.team]!;
      CardData? cardData = onFocusCard;
      CardData? baseCardData = cardData!=null ? gameModel.gameLogic.CardsMap[cardData.code] : null;
      Map<String, Map<String, String>>? cardInfData = cardData!=null ? generateCardInfData(gameModel, baseCardData!) : null;

      return Stack(alignment: Alignment.topRight,
          children: [
            Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const Spacer(),
                        Expanded(flex: 8, child: DetailedCardLayout.fromHeight(onFocusCard, baseCardData, cardInfData, screenHeight * 0.7)),
                        const Spacer()
                      ])),
                ]),
            Padding(padding: EdgeInsets.only(
                top: screenWidth * 0.03,
                right: screenWidth * 0.03),
                child: InkWell(
                    onTap: (){
                      context.go("/cardSelectionScreen");
                    },
                    child:
                    Container(width: screenWidth * 0.18, height: screenWidth * 0.18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.2)),
                          color: darkBluePalette),
                      child: Icon(Icons.cancel_outlined, size: screenWidth * 0.15, color: Colors.white),
                    ))),
          ]);
    });
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
    String month = gameModel.playedCardsPerTeam[gameModel.team]!.entries.where(
            (element) => element.value.code == baseCardData.code).single.key;
    if(["ott", "nov", "dec", "gen", "feb", "mar"].contains(month) && baseCardData.code.contains("imp")){
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