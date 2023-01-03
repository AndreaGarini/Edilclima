
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
                children: const [
                  Spacer(),
                  Expanded(flex: 2, child: Center(child:  Text("Carta non valida",
                      style: TextStyle(color: Colors.red)))),
                  Spacer()
                ],
              );
            }
          case pushResult.LowBudget :
            {
              return Row(
                mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Spacer(),
                  Expanded(flex: 2, child: Center(child:  Text("Budget esaurito",
                      style: TextStyle(color: Colors.red)))),
                  Spacer()
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
                  Expanded(flex: 2, child: Center(child:  Text("Ricerche richieste: ${gameModel.push.second()}",
                      style: const TextStyle(color: Colors.red)))),
                  const Spacer()
                ],
              );
            }
          default:
            {
              if (infoRowDefaultLayout) {
                return Row(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 1, child: Center(child: StylizedText(darkGreenPalette, gameModel.team, null, FontWeight.bold))),
                    Expanded(flex: 1, child: Center(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(ModernPictograms.dollar, color: goldPalette),
                        SizedBox(width: screenWidth * 0.02),
                        StylizedText(darkGreenPalette, gameModel.teamStats[gameModel.team]?.budget.toString() ?? "", null, FontWeight.bold)
                      ],))),
                    Expanded(flex: 1, child: Row(
                      mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Expanded(flex: 2, child: timerIndicator(gameModel)),
                        const Spacer()
                      ],
                    )),
                  ],);
              }
              else {
                //todo: your turn da animare
               return Row(
                 mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: const [
                   Spacer(),
                   Expanded(flex: 2, child: Center(child: Text("your turn"))),
                   Spacer()
                 ],
               );
              }
            }
        }
      }

      return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(flex: 7, child: dynamicContent()),
          Expanded(flex: 1, child: Divider(indent: screenWidth * 0.3, endIndent: screenWidth * 0.3,
              thickness: 1.5, color: oceanBluePalette))
        ],);
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