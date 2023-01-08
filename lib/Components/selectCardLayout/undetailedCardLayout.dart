
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
import '../generalFeatures/GradientText.dart';

class UndetailedCardLayout extends StatelessWidget {

  CardData? cardData;
  double angle;
  bool animate;
  
  late Widget lottieWidget; 
  UndetailedCardLayout(this.cardData, this.angle, this.animate);
  
  

  @override
  Widget build(BuildContext context) {

    if (cardData!= null && cardData!.code != "void"){
      switch (cardData!.type){
        case cardType.Energy: {
          lottieWidget = Lottie.asset('assets/animations/solarpanel.json', animate: animate);
        }
        break;
        case cardType.Pollution: {
          lottieWidget = Lottie.asset('assets/animations/55131-grow-your-forest.json',animate: animate);
        }
        break;
        case cardType.Research: {
          lottieWidget = Lottie.asset('assets/animations/100337-research-lottie-animation.json', animate: animate);
        }
        break;
      }

      if(angle == 0 && !ongoingAnimation){
        return Container(
            width: screenWidth * 0.45,
            height: screenHeight * 0.35,
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
            child:
            Card(
                color: backgroundGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Expanded(flex: 1, child: StylizedText(darkBluePalette, cardData!.code, null, FontWeight.bold)),
                    Expanded(flex: 5, child: lottieWidget),
                    Expanded(flex: 5, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, children: [
                          const Spacer(),
                          Expanded(flex: 10, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(flex: 5, child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end, children: [
                                          Icon(Icons.home, color: lightBluePalette),
                                          StylizedText(darkBluePalette, " : ", null, FontWeight.normal),
                                          StylizedText(darkBluePalette, "${cardData!.comfort}", null, FontWeight.bold)])),
                                    Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end, children: [
                                          Icon(Elusive.leaf, color: lightOrangePalette),
                                          StylizedText(darkBluePalette, " : ", null, FontWeight.normal),
                                          StylizedText(darkBluePalette, "${cardData!.smog}", null, FontWeight.bold)
                                        ])),
                                  ]),),
                              const Spacer(flex: 2),
                              Expanded(flex: 5, child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  Expanded(flex: 1, child:  Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end, children: [
                                        Icon(ModernPictograms.dollar, color: darkOrangePalette),
                                        StylizedText(darkBluePalette, " : ", null, FontWeight.normal),
                                        StylizedText(darkBluePalette, cardData!.money.toString(), null, FontWeight.bold)
                                      ])),
                                  Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end, children: [
                                        Icon(Elusive.lightbulb, color: darkBluePalette),
                                        StylizedText(darkBluePalette, " : ", null, FontWeight.normal),
                                        StylizedText(darkBluePalette, "${cardData!.energy}", null, FontWeight.bold)
                                      ])),
                                ],),),
                            ],)),
                          const Spacer()
                        ])),
                    const Spacer()
                  ],)
            )
        );
      }
      else{
        return Container(
            width: screenWidth * 0.45,
            height: screenHeight * 0.35,
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
            child:
            Card(
                color: backgroundGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Expanded(flex: 1, child: StylizedText(darkBluePalette, cardData!.code, null, FontWeight.bold)),
                    const Spacer(flex: 11),
                  ])
            )
        );
      }
    }
    else{
      return Container(
          width: screenWidth * 0.45,
          height: screenHeight * 0.35,
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
          child:
          Card(
              color: backgroundGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.02)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Expanded(flex: 1, child: Center(child: GradientText("No card",
                        [darkBluePalette, lightBluePalette, lightOrangePalette],
                        screenWidth * 0.2))),
                    const Spacer(),
                  ])
          )
      );
    }
  }

}