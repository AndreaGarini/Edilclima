
import 'dart:core';

import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:lottie/lottie.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/CardSelectionScreen.dart';
import '../../Screens/WaitingScreen.dart';

class UndetailedCardLayout extends StatelessWidget {

  CardData? cardData;
  UndetailedCardLayout(this.cardData);

  @override
  Widget build(BuildContext context) {

    if (cardData != null){

      return SizedBox(
          width: screenWidth * 0.45,
          height: screenHeight * 0.35,
          child: Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
              elevation: 10,
              shadowColor: darkGreyPalette,
              color: backgroundGreen,
              child:
              Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Expanded(flex: 1, child: StylizedText(darkGreenPalette, cardData!.code, null, FontWeight.bold)),
                  Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(ModernPictograms.dollar, color: goldPalette),
                        SizedBox(width: screenWidth * 0.02),
                        StylizedText(darkGreenPalette, ":  ${cardData!.money}", null, FontWeight.bold)
                      ])),
                  const Expanded(flex: 5, child: Icon(Icons.alarm)/*Lottie.asset('assets/animations/solarpanel.json')*/),
                  Expanded(flex: 5, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                     const Spacer(flex: 2),
                        Expanded(flex: 10, child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Icon(Icons.home, color: accentGreenPalette),
                                StylizedText(darkGreenPalette, "Comfort: ", null, FontWeight.normal),
                                StylizedText(darkGreenPalette, "${cardData!.comfort}", null, FontWeight.bold)])),
                            Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  Icon(Elusive.leaf, color: lightGreenPalette),
                                StylizedText(darkGreenPalette, "Smog: ", null, FontWeight.normal),
                                StylizedText(darkGreenPalette, "${cardData!.smog}", null, FontWeight.bold)
                              ])),
                            Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Icon(Elusive.lightbulb, color: lightBluePalette),
                                StylizedText(darkGreenPalette, "Energy: ", null, FontWeight.normal),
                                StylizedText(darkGreenPalette, "${cardData!.energy}", null, FontWeight.bold)
                              ])),
                          ])),
                        const Spacer()
                    ])),
                  const Spacer()
                ],)));
    }
    else{
      return SizedBox(
          width: parentWidth * 0.4,
          height: parentHeight * 0.4,
          child: Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
              elevation: 10,
              child:
              Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Expanded(flex : 2, child: Text("no card")),
                ],)));
    }
  }

}