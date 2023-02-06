
import 'dart:core';

import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/Components/selectCardLayout/HorizontalStatsCard.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/GradientText.dart';

class UndetailedCardLayout extends StatelessWidget {

  CardData? cardData;
  double angle;
  bool animate;
  Function animCallback;
  late Widget lottieWidget; 
  UndetailedCardLayout(this.cardData, this.angle, this.animate, this.animCallback);
  
  

  @override
  Widget build(BuildContext context) {
    //todo: sistemare l'animazione centrale che impazzisce
   if (cardData!= null && cardData!.code != "void"){
      switch (cardData!.type){
        case cardType.Imp: {
          lottieWidget = Lottie.asset('assets/animations/solarpanel.json', animate: false);
        }
        break;
        case cardType.Inv: {
          lottieWidget = Lottie.asset('assets/animations/55131-grow-your-forest.json',animate: false);
        }
        break;
        case cardType.Oth: {
          lottieWidget = Lottie.asset('assets/animations/100337-research-lottie-animation.json', animate: false);
        }
        break;
      }

      if(angle == 0 && !ongoingAnimation){
        return
                Listener(
                  onPointerMove: (moveEvent){
                if(moveEvent.delta.dx > 5) {
                  rotationSense = rotVersus.Right;
                }
                if(moveEvent.delta.dx < -5) {
                  rotationSense = rotVersus.Left;
                }
              },
          onPointerUp: (_){
          if(!ongoingAnimation){
          animCallback();
          }
          },
          child:

          Container(
            width: screenWidth * 0.45,
            height: screenHeight * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
                color: Colors.white,
                boxShadow: [ BoxShadow(
                  color: lightBluePalette.withOpacity(0.6),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 0), // changes position of shadow
                )]),
            child:
            Card(
                color: backgroundGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(flex: 1),
                    Expanded(flex: 2, child: StylizedText(darkBluePalette, cardData!.code, null, FontWeight.bold)),
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
            )
        ));
      }
      else{
        return Container(
            width: screenWidth * 0.35,
            height: screenHeight * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
                color: Colors.white,
                boxShadow: [ BoxShadow(
                  color: darkBluePalette.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 0), // changes position of shadow
                )]),
            child:
            Card(
                color: backgroundGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(flex: 1),
                    Expanded(flex: 2, child: StylizedText(darkBluePalette, cardData!.code, null, FontWeight.bold)),
                    Divider(indent: screenWidth * 0.1, endIndent: screenWidth * 0.1, color: darkBluePalette, thickness: 1),
                    const Spacer(flex: 20)
                  ])
            )
        );
      }
    }
    else{
      if(angle== 0){
        return Listener(
            onPointerMove: (moveEvent){
              if(moveEvent.delta.dx > 5) {
                rotationSense = rotVersus.Right;
              }
              if(moveEvent.delta.dx < -5) {
                rotationSense = rotVersus.Left;
              }
            },
            onPointerUp: (_){
              if(!ongoingAnimation){
                animCallback();
              }
            },
            child: Container(
                width: screenWidth * 0.35,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
                    color: Colors.white,
                    boxShadow: [ BoxShadow(
                      color: darkBluePalette.withOpacity(0.2),
                      spreadRadius: 0.5,
                      blurRadius: 1,
                      offset: const Offset(0, 0), // changes position of shadow
                    )]),
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
                              screenWidth * 0.15))),
                          const Spacer(),
                        ])
                )
            ));
      }
      else {
        return Container(
            width: screenWidth * 0.35,
            height: screenHeight * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
                color: Colors.white,
                boxShadow: [ BoxShadow(
                  color: darkBluePalette.withOpacity(0.2),
                  spreadRadius: 0.5,
                  blurRadius: 1,
                  offset: const Offset(0, 0), // changes position of shadow
                )]),
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
                          screenWidth * 0.15))),
                      const Spacer(),
                    ])
            )
        );
      }
      }
    }
  }