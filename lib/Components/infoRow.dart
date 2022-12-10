
import 'package:edilclima_app/GameModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DataClasses/Pair.dart';
import '../Screens/CardSelectionScreen.dart';

bool infoRowDefaultLayout = true;

class infoRow extends StatefulWidget{

  Pair push;

  infoRow(this.push);
  @override
  State<infoRow> createState() => infoRowState();

}

class infoRowState extends State<infoRow>{

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {

      if (gameModel.playerTimer!= null && gameModel.levelTimerCountdown!=null && gameModel.levelTimerCountdown! > 60){
        infoRowDefaultLayout = false;
      }

      timerText(){

        Future.delayed(const Duration(milliseconds: 2200),() {infoRowDefaultLayout = true;});

        if(gameModel.levelTimerCountdown==null || (gameModel.levelTimerCountdown != null && gameModel.levelTimerCountdown! > 60)){
          //todo: aggiungere animazione di attesa turno per il counter
          return const Text("");
        }
        else{
          return Text(gameModel.levelTimerCountdown.toString());
        }
      }

      dynamicContent() {
        switch (widget.push.first() as pushResult) {
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
              return Text("Ricerche richieste: ${widget.push.second()}",
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
}