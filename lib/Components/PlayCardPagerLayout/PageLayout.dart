
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/ShinyContent.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/DataClasses/kotlinWhen.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
//import 'package:edilclima_app/Screens/NewCardSelectionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/CardData.dart';
import '../../DataClasses/Pair.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/LottieContent.dart';

class PageLayout extends StatefulWidget{

  //todo: sistemare gli import per il giusto card selection screen
  CardData? crd;
  int index;
  Function playedCardCallback;
  PageLayout(this.crd, this.index, this.playedCardCallback);

  @override
  State<StatefulWidget> createState() => PageLayoutState();

}

class PageLayoutState extends State<PageLayout> with SingleTickerProviderStateMixin{

  late bool wrongClick;

  @override
  void initState() {
    super.initState();
    wrongClick = false;
  }

  /*Pair resNeededCheck(GameModel gameModel){
    bool resNeeded = gameModel.gameLogic.findCard(playableCard, gameModel.playerContextCode)?.research == researchSet.Needed;

    String res = "";

    //così prendo tutte le ricerch necessarie ma non ci stanno nella info row
    //gameModel.gameLogic.findCard(playableCard)?.resCard?.forEach((element) { res = res + element;});

    //così prendo solo la prima
    res = res + (gameModel.gameLogic.findCard(playableCard, gameModel.playerContextCode)?.resCard?.first ?? "");
    bool allResPlayed = res == "" ? true : false;
    return Pair(!((resNeeded && allResPlayed) || !resNeeded), res);
  }*/

  void onTap(GameModel gameModel){
    String month = gameModel.gameLogic.months[widget.index];
    var posOccupied = gameModel.playedCardsPerTeam[gameModel.team]!.keys.contains(month);

    if(!posOccupied){
      if(gameModel.playerTimer!=null){
        //var resPair = resNeededCheck(gameModel);

        def() {
          var budget = gameModel.getBudgetSnapshot(
              gameModel.playedCardsPerTeam[gameModel.team]!.values
              .map((e) => e.code).toList());

          if (playableCard!="null" &&
          gameModel.gameLogic.findCard(playableCard, gameModel.playerContextCode!, gameModel.playerLevelCounter)!.money.abs() <= budget) {
            if(gameModel.playCardInPosCheck(widget.index, playableCard)){
              gameModel.changePushValue(Pair(pushResult.CardDown, null));
              gameModel.stopPlayerTimer();
              gameModel.playCardInPos(widget.index, playableCard)
                  .then((value) => discardMechCallback(gameModel));
              gameModel.setTimeOutTrue();
              widget.playedCardCallback(playableCard, month);
            }

          }
          else {
            gameModel.changePushValue(Pair(pushResult.LowBudget, null));
          }
        }

        KotlinWhen(
            [KotlinPair(playableCard=="null", (){gameModel.changePushValue(Pair(pushResult.CardDown, null));}),
              KotlinPair(playableCard=="void", (){gameModel.changePushValue(Pair(pushResult.InvalidCard, null));}),
              /*KotlinPair(resPair.first() as bool, (){gameModel.changePushValue(Pair(pushResult.ResearchNeeded, resPair.second()));})*/],
            def).whenExeute();
      }
      else{
        setWrongClickFalse();
        setState((){
          wrongClick = true;
        });
      }
    }

    else {
      onFocusCard = gameModel.playedCardsPerTeam[gameModel.team]![month]!;
      context.push("/cardSelectionScreen/cardInfoScreen");
    }
  }

  Widget clickableCard (GameModel gameModel){

    late Widget lottieWidget;

    if(widget.crd?.type != null){
      switch (widget.crd!.type){
        case cardType.Build: {
          lottieWidget = LottieContent('assets/animations/Muri.json', true);
        }
        break;
        case cardType.Gear: {
          lottieWidget = LottieContent('assets/animations/Impianto.json', true);
        }
        break;
        case cardType.Lights: {
          lottieWidget = LottieContent('assets/animations/Luci.json', true);
        }
        break;
        case cardType.Window: {
          lottieWidget = LottieContent('assets/animations/Finestra.json', true);
        }
        break;
        case cardType.Panels: {
          lottieWidget = LottieContent('assets/animations/Pannelli.json', true);
        }
        break;
      }
    }

    return GestureDetector(
        onTap: (){onTap(gameModel);},
        child:  Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
        color: Colors.white,
        boxShadow: [ BoxShadow(
        color: lightBluePalette.withOpacity(0.4),
        spreadRadius: 1,
        blurRadius: 1,
        offset: const Offset(0, 0), // changes position of shadow
        )]),
        child:
        Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
            color: backgroundGreen,
            shadowColor: lightBluePalette,
            elevation: 1,
            child: Center(child: widget.crd?.code!=null ?
             lottieWidget :
            ShinyContent(
                Text( wrongClick ? "Attendi il tuo turno" : "Clicca per giocare la carta",
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, color: Colors.white)),
                darkBluePalette, false)))
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {
        return
          Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, /*widget.crd?.code ?? "no card"*/
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Expanded(flex: 1, child: Center(child:  Text(widget.crd?.title ?? "nessuna carta", style: TextStyle(color: darkBluePalette,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',),
                  textAlign: TextAlign.justify))),
              Expanded(flex: 4, child: SizedBox(width: screenWidth * 0.45 * 1.3, child: clickableCard(gameModel))),
              const Spacer(flex: 2)
            ],);
    });
  }

  Future<void> setWrongClickFalse(){
    return Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        wrongClick = false;
      });
    });
  }



}