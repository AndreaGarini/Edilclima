
import 'package:edilclima_app/Components/generalFeatures/GradientText.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';

class DetailedCardLayout extends StatelessWidget{

  CardData? cardData;
  DetailedCardLayout(this.cardData);

  String bodyText = "Lorem ipsum dolor sit amet, consectetur adipisci elit, sed do eiusmod tempor incidunt ut labore et dolore magna aliqua. "
      "Ut enim ad minim veniam, quis nostrum exercitationem ullamco laboriosam, nisi ut aliquid ex ea "
      "commodi consequatur. Duis aute irure reprehenderit in voluptate velit esse cillum dolore eu"
      "fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  @override
  Widget build(BuildContext context) {

    if(cardData!=null){
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
                Expanded(flex: 1, child: Center(child: StylizedText(darkBluePalette, cardData!.code, null, FontWeight.bold))),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Icon(ModernPictograms.dollar, color: darkOrangePalette),
                    SizedBox(width: screenWidth * 0.02),
                    StylizedText(darkBluePalette, ":  ${cardData!.money}", null, FontWeight.bold)
                  ],)),
                const Expanded(flex: 3, child: Icon(Icons.alarm)/*Lottie.asset('assets/animations/solarpanel.json')*/),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(Icons.home, color: lightBluePalette),
                      ],)),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(Elusive.leaf, color: lightOrangePalette),
                      ],)),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(Elusive.lightbulb, color: darkBluePalette),
                      ],)),
                    const Spacer()
                  ],)),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                          StylizedText(darkBluePalette, "Comfort: ", null, FontWeight.normal),
                          StylizedText(darkBluePalette, "${cardData!.comfort}", null, FontWeight.bold)
                      ],)),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      StylizedText(darkBluePalette, "Smog: ", null, FontWeight.normal),
                      StylizedText(darkBluePalette, "${cardData!.smog}", null, FontWeight.bold)
                      ],)),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      StylizedText(darkBluePalette, "Energy: ", null, FontWeight.normal),
                      StylizedText(darkBluePalette, "${cardData!.energy}", null, FontWeight.bold)
                      ],)),
                    const Spacer()
                  ],)),
                Expanded(flex: 3, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Spacer(),
                    Expanded(flex: 6, child: Text(bodyText, style: const TextStyle(color: Colors.black))),
                    const Spacer()
                  ],)),
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