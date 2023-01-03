
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:lottie/lottie.dart';

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
      return SizedBox(
        width: screenWidth * 0.8,
        height: screenHeight * 0.6,
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
                Expanded(flex: 1, child: Center(child: StylizedText(darkGreenPalette, cardData!.code, null, FontWeight.bold))),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Icon(ModernPictograms.dollar, color: goldPalette),
                    SizedBox(width: screenWidth * 0.02),
                    StylizedText(darkGreenPalette, ":  ${cardData!.money}", null, FontWeight.bold)
                  ],)),
                const Expanded(flex: 3, child: Icon(Icons.alarm)/*Lottie.asset('assets/animations/solarpanel.json')*/),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(Icons.home, color: accentGreenPalette),
                      ],)),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(Elusive.leaf, color: lightGreenPalette),
                      ],)),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(Elusive.lightbulb, color: lightBluePalette),
                      ],)),
                    const Spacer()
                  ],)),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                          StylizedText(darkGreenPalette, "Comfort: ", null, FontWeight.normal),
                          StylizedText(darkGreenPalette, "${cardData!.comfort}", null, FontWeight.bold)
                      ],)),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      StylizedText(darkGreenPalette, "Smog: ", null, FontWeight.normal),
                      StylizedText(darkGreenPalette, "${cardData!.smog}", null, FontWeight.bold)
                      ],)),
                    Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      StylizedText(darkGreenPalette, "Energy: ", null, FontWeight.normal),
                      StylizedText(darkGreenPalette, "${cardData!.energy}", null, FontWeight.bold)
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
      return SizedBox( width: screenWidth * 0.8,
          height: screenHeight * 0.6,
          child: Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
              elevation: 10,
              child: const Center(child: Text("no card", style: TextStyle(color: Colors.black)))));
    }
  }
}