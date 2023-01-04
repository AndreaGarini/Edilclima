
import 'dart:async';

import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:provider/provider.dart';

import '../Screens/CardSelectionScreen.dart';
import '../Screens/WaitingScreen.dart';

bool infoRowDefaultLayout = true;

class infoRow extends StatefulWidget{

  @override
  State<infoRow> createState() => infoRowState();

}

class infoRowState extends State<infoRow> with
    TickerProviderStateMixin{

  late AnimationController indicatorController;

  @override
  void initState() {
    super.initState();
    indicatorController = AnimationController(vsync: this, duration: const Duration(seconds: 63));
  }

  @override
  void dispose(){
    super.dispose();
    indicatorController.dispose();
  }

  timerIndicator(GameModel gameModel){
    if(gameModel.playerTimerCountdown==null || (gameModel.playerTimerCountdown != null && gameModel.playerTimerCountdown! > 60)){
      //todo: aggiungere animazione di attesa turno per il counter
      return const Text("");
    }
    else{
      return TweenAnimationBuilder<double>(duration: const Duration(seconds: 63),
        curve: Curves.easeInOut,
        tween: Tween<double>(
          begin: 1,
          end: 0
        ),
        builder: (context, value, _) {
          var colorAnim = ColorTween(begin: Colors.green, end: Colors.red).animate(indicatorController);
          indicatorController.value = 1 - value;
          return LinearProgressIndicator(value: value, valueColor:  colorAnim);
        });
    }
  }

  @override
  Widget build(BuildContext context) {

    //todo: il timer non aggiorna i dati ad ogni secondo, sostituire con progress bar
    return Consumer<GameModel>(builder: (context, gameModel, child)
    {

        if (gameModel.playerTimer==null && gameModel.playerTimerCountdown!=null){
          updateData(gameModel, false);
          int duration = gameModel.splash ? 63 : 62;
          gameModel.playerTimer = setPlayerTimer(duration, 1, gameModel);
          Future<void>.delayed(Duration(seconds: duration - 60), () {setState(() {
            infoRowDefaultLayout = true;
          });});
        }

      dynamicContent() {
        switch (gameModel.push.first() as pushResult) {
          case pushResult.InvalidCard :
            {
              return Row(
                mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  Expanded(flex: 2, child: Card(color: backgroundGreen, child: Center(child:  StylizedText(darkOrangePalette, "Carta non valida",
                      screenWidth * 0.07, FontWeight.normal)))),
                  const Spacer()
                ],
              );
            }
          case pushResult.LowBudget :
            {
              return Row(
                mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  Expanded(flex: 2, child: Card(color: backgroundGreen, child: Center(child:  StylizedText(darkOrangePalette, "Budget terminato",
                      screenWidth * 0.07, FontWeight.normal)))),
                  const Spacer()
                ],
              );
            }
          case pushResult.ResearchNeeded :
            {
              return Row(
                mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  Expanded(flex: 2, child: Card(color: backgroundGreen, child: Center(child:  StylizedText(darkOrangePalette, "Ricerche richieste: ${gameModel.push.second()}",
                      screenWidth * 0.07, FontWeight.normal)))),
                  const Spacer()
                ],
              );
            }
          default:
            {
              if (infoRowDefaultLayout) {
                return Card(color: backgroundGreen,
                child: Row(mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(flex: 1, child: Center(child: StylizedText(darkBluePalette, gameModel.team, screenWidth * 0.07, FontWeight.bold))),
                      Expanded(flex: 1, child: Center(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Icon(ModernPictograms.dollar, color: darkOrangePalette),
                            SizedBox(width: screenWidth * 0.02),
                            StylizedText(darkBluePalette, gameModel.teamStats[gameModel.team]?.budget.toString() ?? "", screenWidth * 0.07, FontWeight.bold)
                          ]))),
                      Expanded(flex: 1, child: Center(child: Row(
                        mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Expanded(flex: 2, child: timerIndicator(gameModel)),
                          const Spacer()
                        ],
                      ))),
                    ]));
              }
              else {
                //todo: your turn da animare
               return Row(
                 mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   const Spacer(),
                   Expanded(flex: 2, child: Center(child: StylizedText(darkBluePalette, "Your turn",
                       screenWidth * 0.07, FontWeight.normal))),
                   const Spacer()
                 ],
               );
              }
            }
        }
      }

      return
        Material(
          color: darkBluePalette,
          child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Spacer(),
                  Expanded(flex: 12, child: dynamicContent()),
                  const Spacer()
                ],)),
            ]));
  });
  }

  Future<void> updateData(GameModel gm, bool stateValue) async{
    return Future<void>.delayed(const Duration(milliseconds: 100), () {setState(() {
      infoRowDefaultLayout = stateValue;
    });});
  }

  Timer setPlayerTimer(int timeToFinish, int TickInterval, GameModel gm){
    var counter = timeToFinish;
    var playerTimer = Timer.periodic(Duration(seconds: TickInterval), (timer) {
      gm.playerTimerOnTick();
      counter--;
      if (counter == 0) {
        gm.playerTimerOnFinish();
        timer.cancel();
      }
    });
    return playerTimer;
  }
}