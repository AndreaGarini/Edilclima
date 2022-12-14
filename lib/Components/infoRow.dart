
import 'dart:async';

import 'package:edilclima_app/GameModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/CardSelectionScreen.dart';

bool infoRowDefaultLayout = true;
int? infoRowCounter;

class infoRow extends StatefulWidget{

  @override
  State<infoRow> createState() => infoRowState();

}

class infoRowState extends State<infoRow>{

  @override
  Widget build(BuildContext context) {

    //todo: il timer non aggiorna i dati ad ogni secondo, sostituire con progress bar
    return Consumer<GameModel>(builder: (context, gameModel, child)
    {

        if (gameModel.playerTimer== null && gameModel.playerTimerCountdown!=null && gameModel.playerTimerCountdown! > 60){
          updateData(gameModel, false);
          gameModel.playerTimer = setPlayerTimer(gameModel.splash ? 63 : 62, 1, gameModel);
        }
        else{
          updateData(gameModel, true);
        }

      timerText(){
        if(gameModel.playerTimerCountdown==null || (gameModel.playerTimerCountdown != null && gameModel.playerTimerCountdown! > 60)){
          //todo: aggiungere animazione di attesa turno per il counter
          return const Text("");
        }
        else{
          return Text(infoRowCounter.toString());
        }
      }

      dynamicContent() {
        switch (gameModel.push.first() as pushResult) {
          case pushResult.InvalidCard :
            {
              return const Text(
                  "Carta non valida", style: TextStyle(color: Colors.red));
            }
          case pushResult.LowBudget :
            {
              return const Text(
                  "Budget esaurito", style: TextStyle(color: Colors.red));
            }
          case pushResult.ResearchNeeded :
            {
              return Text("Ricerche richieste: ${gameModel.push.second()}",
                  style: const TextStyle(color: Colors.red));
            }
          default:
            {
              if (infoRowDefaultLayout) {
                return Row(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 1, child: Center(child: Text(gameModel.team),)),
                    Expanded(flex: 1,
                        child: Center(child: Text(
                            "B : ${gameModel.teamStats[gameModel.team]?.budget ?? ""}"),)),
                    Expanded(flex: 1, child: Center(child: timerText(),)),
                  ],);
              }
              else {
               return const Text("Your turn");
              }
            }
        }
      }


      return Row(mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: dynamicContent())
        ],);
  });
  }

  Future<void> updateData(GameModel gm, bool stateValue) async{
    return Future<void>.delayed(const Duration(milliseconds: 500), () {setState(() {
      infoRowDefaultLayout = stateValue;
    });});
  }

  Timer setPlayerTimer(int timeToFinish, int TickInterval, GameModel gm){
    var counter = timeToFinish;
    var playerTimer = Timer.periodic(Duration(seconds: TickInterval), (timer) {
      gm.playerTimerOnTick();
      setState((){infoRowCounter = counter;});
      counter--;
      if (counter == 0) {
        gm.playerTimerOnFinish();
        setState((){infoRowCounter = null;});
        timer.cancel();
      }
    });
    return playerTimer;
  }
}