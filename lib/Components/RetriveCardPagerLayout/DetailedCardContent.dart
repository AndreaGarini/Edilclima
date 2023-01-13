
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/StylizedText.dart';
import 'VerticalStatsCard.dart';

class DetailedCardContent extends StatelessWidget{

  CardData cardData;
  String bodyText;
  late Widget lottieWidget;

  DetailedCardContent(this.cardData, this.bodyText);

  @override
  Widget build(BuildContext context) {


    switch (cardData!.type){
      case cardType.Energy: {
        lottieWidget = Lottie.asset('assets/animations/solarpanel.json', animate: false);
      }
      break;
      case cardType.Pollution: {
        lottieWidget = Lottie.asset('assets/animations/55131-grow-your-forest.json', animate: false);
      }
      break;
      case cardType.Research: {
        lottieWidget = Lottie.asset('assets/animations/100337-research-lottie-animation.json', animate: false);
      }
      break;
    }

    return
    SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: screenHeight),
                child:
                IntrinsicHeight(
                  child:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: Center(child: StylizedText(darkBluePalette, cardData!.code, screenWidth * 0.07, FontWeight.bold))),
                      Divider(indent: screenWidth * 0.2, endIndent: screenWidth * 0.2, color: darkBluePalette, thickness: 1),
                      Expanded(flex: 2, child: lottieWidget),
                      Expanded(flex: 2, child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Expanded(flex: 4, child: VerticalStatsCard("comfort", cardData!.comfort)),
                            Expanded(flex: 4, child: VerticalStatsCard("smog", cardData!.comfort)),
                            Expanded(flex: 4, child: VerticalStatsCard("energy", cardData!.comfort)),
                            Expanded(flex: 4, child: VerticalStatsCard("money", cardData!.money)),
                          ])),
                      Divider(indent: screenWidth * 0.2, endIndent: screenWidth * 0.2, color: darkBluePalette, thickness: 1),
                      Expanded(flex: 5, child:
                      Card(color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                          shadowColor: backgroundGreen,
                          elevation: 1,
                          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      const Spacer(),
                                      Expanded(flex: 6, child: StylizedText(darkBluePalette, bodyText, screenHeight * 0.025, FontWeight.normal)),
                                      const Spacer()
                                    ])
                              ])
                      )),
                    ],
                  ),
                )
            )
      );
  }



}