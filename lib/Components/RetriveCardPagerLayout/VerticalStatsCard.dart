
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';

import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/StylizedText.dart';

class VerticalStatsCard extends StatelessWidget{

  String dataType;
  int dataValue;
  late Widget icon;
  late String text;

  VerticalStatsCard(this.dataType, this.dataValue);

  @override
  Widget build(BuildContext context) {

    switch(dataType){
      case "smog" : {
        icon = Icon(Elusive.leaf,
            color: lightOrangePalette,
            size: screenWidth * 0.05);
        text = "Smog : ";
      }
      break;
      case "energy" : {
        icon = Icon(Elusive.lightbulb,
            color: darkBluePalette,
            size: screenWidth * 0.05);
        text = "Energy : ";
      }
      break;
      case "comfort" : {
        icon = Icon(Icons.home,
            color: lightBluePalette,
            size: screenWidth * 0.05);
        text = "Comfort : ";
      }
      break;
      case "money" : {
        icon = Icon(ModernPictograms.dollar,
          color: darkOrangePalette,
          size: screenWidth * 0.05,);
        text = "Cost : ";
      }
    }


   return Card(
       color: Colors.white,
       shadowColor: lightOrangePalette,
       elevation: 3,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(screenHeight * 0.02)),
       child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center, children: [
           const Spacer(),
           Expanded(flex: 3, child:  Container(
               width: screenWidth * 0.06,
               height: screenWidth * 0.06,
               decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.1)),
                   color: backgroundGreen,
                   boxShadow: [ BoxShadow(
                     color: lightBluePalette.withOpacity(0.5),
                     spreadRadius: 1,
                     blurRadius: 1,
                     offset: const Offset(0, 0), // changes position of shadow
                   )]),
               child: icon)),
           Expanded(flex: 6, child: Row(mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center, children: [
               StylizedText(darkBluePalette, text, screenWidth * 0.03, FontWeight.normal),
               StylizedText(darkBluePalette, "${dataValue}", screenWidth * 0.03, FontWeight.bold)
             ],)),
         ],)
   );
  }

}