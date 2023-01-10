
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/ShinyContent.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/DataClasses/kotlinWhen.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/CardData.dart';
import '../../DataClasses/Pair.dart';
import '../../Screens/WaitingScreen.dart';

class PageLayout extends StatefulWidget{

  CardData? crd;
  int index;
  PageLayout(this.crd, this.index);

  @override
  State<StatefulWidget> createState() => PageLayoutState();

}

class PageLayoutState extends State<PageLayout>{

  Pair resNeededCheck(GameModel gameModel){
    bool resNeeded = gameModel.gameLogic.findCard(playableCard)?.research == researchSet.Needed;

    String res = "";

    gameModel.gameLogic.findCard(playableCard)?.resCard?.forEach((element) { res = res + element;});
    bool allResPlayed = res=="" ? true : false;

    return Pair(!((resNeeded && allResPlayed) || !resNeeded), res);
  }

  void onTap(GameModel gameModel){
    var resPair = resNeededCheck(gameModel);

    def() {
      var budget = gameModel.getBudgetSnapshot(
          gameModel.playedCardsPerTeam[gameModel.team]!.values.toList());
      if (gameModel.gameLogic.findCard(playableCard)!.money < budget) {
        gameModel.playCardInPos(widget.index, playableCard);
        gameModel.changePushValue(Pair(pushResult.CardDown, null));
        gameModel.stopPlayerTimer();
        gameModel.setTimeOutTrue();
      }
      else {
        gameModel.changePushValue(Pair(pushResult.LowBudget, null));
      }
    }

    KotlinWhen(
        [KotlinPair(playableCard=="null", (){gameModel.changePushValue(Pair(pushResult.CardDown, null));}),
          KotlinPair(playableCard=="void", (){gameModel.changePushValue(Pair(pushResult.InvalidCard, null));}),
          KotlinPair(resPair.first() as bool, (){gameModel.changePushValue(Pair(pushResult.ResearchNeeded, resPair.second()));})],
        def).whenExeute();
  }

  Widget clickableCard (GameModel gameModel){

    late Widget lottieWidget;

    if(widget.crd?.type != null){
      switch (widget.crd!.type){
        case cardType.Energy: {
          lottieWidget = Lottie.asset('assets/animations/solarpanel.json', animate: false);
        }
        break;
        case cardType.Pollution: {
          lottieWidget = Lottie.asset('assets/animations/55131-grow-your-forest.json', animate: false);
        }
        break;
        case cardType.Research: {
          lottieWidget = Lottie.asset('assets/animations/100337-research-lottie-animation.json', animate: false);
        }
        break;
      }
    }

    return GestureDetector(
        onTap: gameModel.playerTimer!=null ? () {onTap(gameModel);} : (){},
        child:  Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
        boxShadow: [ BoxShadow(
        color: darkGreyPalette.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 6,
        offset: const Offset(0, 0), // changes position of shadow
        )],
        gradient:  LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          lightOrangePalette,
          darkOrangePalette,
          backgroundGreen,
          backgroundGreen,
          darkBluePalette,
          lightBluePalette,
        ],
        stops: const [0,0.1,0.2,0.8,0.9, 1]
        )),
        child:
        Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
            color: backgroundGreen,
            shadowColor: darkGreyPalette,
            elevation: 10,
            child: Center(child: widget.crd?.code!=null ?
             lottieWidget :
            ShinyContent(Text("Click to play card",
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.white)),
                darkBluePalette)))
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(flex: 1, child:
          Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: Center(child: StylizedText(darkBluePalette, widget.crd?.code ?? "no card", null, FontWeight.bold))),
              Expanded(flex: 4, child: SizedBox(width: screenWidth * 0.45 * 1.3, child: clickableCard(gameModel))),
              const Spacer(flex: 2)
            ],)),

        ],);
    });
  }




}