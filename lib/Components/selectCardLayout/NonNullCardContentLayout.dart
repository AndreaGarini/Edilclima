
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/StylizedText.dart';
import 'HorizontalStatsCard.dart';

class NonNullCardContentLayout extends StatelessWidget{

  CardData cardData;
  bool angleZero;
  Widget lottieWidget;
  bool newCard;
  NonNullCardContentLayout(this.cardData, this.angleZero, this.lottieWidget, this.newCard);

  @override
  Widget build(BuildContext context) {

    if(angleZero){
     return
          Card(
              color: backgroundGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.02)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Spacer(flex: 1),
                  Expanded(flex: 2, child:  Text(cardData.title,
                    style: TextStyle(color: darkBluePalette,
                    fontSize: screenHeight * 0.015,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',),
                      textAlign: TextAlign.center)),
                  Divider(indent: screenWidth * 0.1, endIndent: screenWidth * 0.1, color: darkBluePalette, thickness: 1),
                  Expanded(flex: 10, child: lottieWidget),
                  Expanded(flex: 10, child:
                  Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Expanded(flex: 10, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Expanded(flex: 5, child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  Expanded(flex: 1, child: HorizontalStatsCard("comfort", cardData!.comfort)),
                                  Expanded(flex: 1, child: HorizontalStatsCard("smog", cardData!.smog)),
                                ])),
                            Expanded(flex: 5, child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Expanded(flex: 1, child: HorizontalStatsCard("money", cardData!.money)),
                                Expanded(flex: 1, child: HorizontalStatsCard("energy", cardData!.energy)),
                              ],),),
                          ],)),
                      ])),
                ],)
          );
    }
    else{
      return
          Card(
              color: backgroundGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.02)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(flex: 1),
                    Expanded(flex: 2, child: Text(cardData.title,
                        style: TextStyle(color: darkBluePalette,
                          fontSize: screenHeight * 0.012,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',),
                        textAlign: TextAlign.center)),
                    Divider(indent: screenWidth * 0.1, endIndent: screenWidth * 0.1, color: darkBluePalette, thickness: 1),
                    const Spacer(flex: 20)
                  ])
          );
    }
  }

}