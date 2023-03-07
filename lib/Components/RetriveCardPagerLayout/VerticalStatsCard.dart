
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';

import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/ShinyContent.dart';
import '../generalFeatures/StylizedText.dart';

class VerticalStatsCard extends StatelessWidget{

  String dataType;
  int dataValue;
  int baseDataValue;
  late Widget icon;
  late String text;
  late bool statUp;
  VerticalStatsCard(this.dataType, this.dataValue, this.baseDataValue);

  @override
  Widget build(BuildContext context) {

      statUp = dataValue > baseDataValue;

    switch(dataType){
      case "smog" : {
        icon = Icon(Elusive.leaf,
            color: lightOrangePalette,
            size: screenWidth * 0.075);
        text = "Smog : ";
      }
      break;
      case "energy" : {
        icon = Icon(Elusive.lightbulb,
            color: darkBluePalette,
            size: screenWidth * 0.075);
        text = "Energy : ";
      }
      break;
      case "comfort" : {
        icon = Icon(Icons.home,
            color: lightBluePalette,
            size: screenWidth * 0.075);
        text = "Comfort : ";
      }
      break;
      case "money" : {
        icon = Icon(ModernPictograms.dollar,
          color: darkOrangePalette,
          size: screenWidth * 0.075);
        text = "Cost : ";
      }
    }

    if(dataType == "smog"){
      print("value: $dataValue, base: $baseDataValue");
    }


   return Card(
       color: Colors.white,
       shadowColor: lightOrangePalette,
       elevation: 3,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(screenHeight * 0.02)),
       child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Spacer(flex: 3),
           Expanded(flex: 10, child:  Container(
               width: screenWidth * 0.1,
               height: screenWidth * 0.1,
               decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.1)),
                   color: backgroundGreen,
                   boxShadow: [ BoxShadow(
                     color: lightBluePalette.withOpacity(0.5),
                     spreadRadius: 1,
                     blurRadius: 1,
                     offset: const Offset(0, 0), // changes position of shadow
                   )]),
               child: icon)),
           Expanded(flex: 10, child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
           crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(text, style: TextStyle(color: darkBluePalette,
                 fontSize: screenWidth * 0.045,
                 fontWeight: FontWeight.normal,
                 fontFamily: 'Roboto',),
                   textAlign: TextAlign.justify),
               dataValue != baseDataValue ? ShinyContent(Text(dataValue.toString(), style:
               TextStyle(fontSize: screenWidth * 0.045,
                 color: Colors.white,
                 fontWeight: FontWeight.bold,
                 fontFamily: 'Roboto',),
                   textAlign: TextAlign.justify), dataValue > baseDataValue ? Colors.green : Colors.red, true) :
               Text(dataValue.toString(), style: TextStyle(color: darkBluePalette,
                 fontSize: screenWidth * 0.045,
                 fontWeight: FontWeight.bold,
                 fontFamily: 'Roboto',),
                   textAlign: TextAlign.justify),
             ],))
         ],)
   );
  }

}