
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
  InfoRowDynamicContent(this.layout);

  @override
  State<StatefulWidget> createState() => InfoRowDynamicContentState();

}

class InfoRowDynamicContentState extends State<InfoRowDynamicContent> {

  @override
  Widget build(BuildContext context) {

    //todo: sistemare fontsize delle scritte
   return Consumer<GameModel>(builder: (context, gameModel, child){

     switch (widget.layout) {
       case InfoRowLayout.Invalid :
         {
           return Row(
             mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               const Spacer(),
               Expanded(flex: 8, child: Card(color: backgroundGreen, child: Center(child:  StylizedText(darkOrangePalette, "Carta non valida",
                   screenWidth * 0.05, FontWeight.normal)))),
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
                   screenWidth * 0.05, FontWeight.normal)))),
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
                   screenWidth * 0.05, FontWeight.normal)))),
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
                       Expanded(flex: 2, child: InfoRowTimerIndicator()),
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
             Expanded(flex: 2, child: Card(color: backgroundGreen, child: Center(child: StylizedText(darkOrangePalette, "Your turn",
                 screenWidth * 0.06, FontWeight.bold)))),
             const Spacer()
           ],
         );
       }
     }
   });

   }
  }