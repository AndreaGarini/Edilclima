
import 'dart:async';

import 'package:edilclima_app/Components/InfoRowComponents/InfoRowTimerIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/StylizedText.dart';
import 'infoRow.dart';

class InfoRowDynamicContent extends StatefulWidget{

  InfoRowLayout layout;
  Function? startTimer;
  Function? cancelTimer;
  InfoRowDynamicContent(this.layout);

  @override
  State<StatefulWidget> createState() => InfoRowDynamicContentState();

}

class InfoRowDynamicContentState extends State<InfoRowDynamicContent> {

  late bool showTimer;
  StreamController<int>? streamCtrl;

  @override
  void initState() {
    super.initState();
    showTimer = false;
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_){
    widget.startTimer ??= setTimerStart;
    widget.cancelTimer ??= setTimerEnd;
    });


   return Consumer<GameModel>(builder: (context, gameModel, child){

     WidgetsBinding.instance?.addPostFrameCallback((_){
       if(gameModel.playerLevelStatus != "play" && showTimer){
          widget.cancelTimer!();
       }
     });

     switch (widget.layout) {
       case InfoRowLayout.Invalid :
         {
           return Row(
             mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               const Spacer(),
               Expanded(flex: 8, child: Card(color: backgroundGreen, child: Center(child:  StylizedText(darkOrangePalette, "Carta non valida",
                   null, FontWeight.normal)))),
               const Spacer()
             ],
           );
         }
       case InfoRowLayout.Budget :
         {
           return Row(
             mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               const Spacer(),
               Expanded(flex: 8, child: Card(color: backgroundGreen, child: Center(child:  StylizedText(darkOrangePalette, "Budget terminato",
                   null, FontWeight.normal)))),
               const Spacer()
             ],
           );
         }
       case InfoRowLayout.Research :
         {
           return Row(
             mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               const Spacer(),
               Expanded(flex: 8, child: Card(color: backgroundGreen, child: Center(child:  StylizedText(darkOrangePalette, "Gioca prima: ${gameModel.push.second()}",
                   null, FontWeight.normal)))),
               const Spacer()
             ],
           );
         }
       case InfoRowLayout.Base : {
         return Card(color: backgroundGreen,
             child: Row(mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Expanded(flex: 1, child: Center(child: StylizedText(darkBluePalette, gameModel.team, null, FontWeight.bold))),
                   Expanded(flex: 1, child: Center(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center, children: [
                         Icon(ModernPictograms.dollar, color: darkOrangePalette),
                         SizedBox(width: screenWidth * 0.02,),
                         StylizedText(darkBluePalette, gameModel.teamStats[gameModel.team]?.budget.toString() ?? "", null, FontWeight.bold),
                       ]))),
                   Expanded(flex: 1, child: Center(child: Row(
                     mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       const Spacer(),
                       Expanded(flex: 2, child: InfoRowTimerIndicator(showTimer, gameModel.playerTimerCountdown)),
                       const Spacer()
                     ],
                   ))),
                 ]));
       }
       case InfoRowLayout.Turn :  {
         return Row(
           mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
             const Spacer(),
             Expanded(flex: 3, child: Card(color: backgroundGreen, child: Center(child: StylizedText(darkOrangePalette, "Tocca a te",
                 null, FontWeight.bold)))),
             const Spacer()
           ],
         );
       }
     }
   });

   }


   void setTimerStart(){
     Future<void>.delayed(const Duration(milliseconds: 1), () {
       var counter = 60;
       Timer.periodic(const Duration(seconds: 1), (timer) {
         counter--;
         if (counter == 0) {
           timer.cancel();
         }
       });
     });
    setState((){
      showTimer = true;
    });
   }

  void setTimerEnd(){
    setState((){
      showTimer = false;
    });
  }

  }