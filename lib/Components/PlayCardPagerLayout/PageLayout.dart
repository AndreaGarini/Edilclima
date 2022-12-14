
import 'package:edilclima_app/DataClasses/kotlinWhen.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        gameModel.playerTimerCountdown = null;
        gameModel.playerTimer!.cancel();
        gameModel.playerTimer = null;
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
    return GestureDetector(
        onTap: gameModel.playerTimer!=null ? () {onTap(gameModel);} : (){},
        child:  Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
            elevation: 10,
            child: Center(child: widget.crd?.code!=null ?
            const Icon(Icons.access_alarm) : const Text("click to play card")))
    );
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
              Expanded(flex: 1, child: Center(child: Text(widget.crd?.code ?? "no card", style: const TextStyle(color: Colors.black)))),
              Expanded(flex: 4, child: SizedBox(width: screenWidth * 0.45 * 1.3, child: clickableCard(gameModel))),
              const Spacer(flex: 2)
            ],)),

        ],);
    });
  }




}