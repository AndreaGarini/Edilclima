
import 'package:edilclima_app/Components/RetriveCardPagerLayout/VerticalStatsCard.dart';
import 'package:edilclima_app/Components/generalFeatures/GradientText.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';

class DetailedCardLayout extends StatelessWidget{

  CardData? cardData;
  double? height;
  DetailedCardLayout(this.cardData);
  DetailedCardLayout.fromHeight(this.cardData, this.height);

  String bodyText = "Lorem ipsum dolor sit amet, consectetur adipisci elit, sed do eiusmod tempor incidunt ut labore et dolore magna aliqua. "
      "Ut enim ad minim veniam, quis nostrum exercitationem ullamco laboriosam, nisi ut aliquid ex ea "
      "commodi consequatur. Duis aute irure reprehenderit in voluptate velit esse cillum dolore eu"
      "fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  @override
  Widget build(BuildContext context) {

    late Widget lottieWidget;

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

    if(cardData!=null){
      return Container(
          width: screenWidth * 0.8,
          height: height ?? screenHeight * 0.6,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
              boxShadow: [ BoxShadow(
                color: darkGreyPalette.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 0), // changes position of shadow
              )],
              gradient:  LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    darkBluePalette,
                    lightBluePalette,
                    backgroundGreen,
                    backgroundGreen,
                    lightOrangePalette,
                    darkOrangePalette,
                  ],
                  stops: const [0,0.1,0.2,0.8,0.9, 1]
              )),
        child: Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
            elevation: 10,
            color: backgroundGreen,
            shadowColor: darkGreyPalette,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: Center(child: StylizedText(darkBluePalette, cardData!.code, screenWidth * 0.07, FontWeight.bold))),
                Divider(indent: screenWidth * 0.2, endIndent: screenWidth * 0.2, color: darkBluePalette, thickness: 1),
                Expanded(flex: 3, child: lottieWidget),
                Expanded(flex: 3, child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(flex: 4, child: VerticalStatsCard("comfort", cardData!.comfort)),
                    Expanded(flex: 4, child: VerticalStatsCard("smog", cardData!.comfort)),
                    Expanded(flex: 4, child: VerticalStatsCard("energy", cardData!.comfort)),
                    Expanded(flex: 4, child: VerticalStatsCard("money", cardData!.money)),
                  ])),
                Divider(indent: screenWidth * 0.2, endIndent: screenWidth * 0.2, color: darkBluePalette, thickness: 1),
                Expanded(flex: 3, child:
                Card(color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                shadowColor: lightOrangePalette,
                elevation: 3,
                child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Spacer(),
                    Expanded(flex: 6, child: Text(bodyText, style: const TextStyle(color: Colors.black))),
                    const Spacer()
                  ]))
                ),
                const Spacer()
              ],
            )
        ),
      );
    }
    else{
      return Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.6,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
              boxShadow: [ BoxShadow(
                color: darkGreyPalette.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 0), // changes position of shadow
              )],
              gradient:  LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    darkBluePalette,
                    lightBluePalette,
                    backgroundGreen,
                    backgroundGreen,
                    lightOrangePalette,
                    darkOrangePalette,
                  ],
                  stops: const [0,0.1,0.2,0.8,0.9, 1]
              )),
          child: Card(
              color: backgroundGreen,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
              elevation: 10,
              child: Center(child: GradientText("No card",
                  [darkBluePalette, lightBluePalette, lightOrangePalette],
                  screenWidth * 0.2))));
    }
  }
}