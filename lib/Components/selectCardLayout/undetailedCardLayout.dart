
import 'dart:core';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/selectCardLayout/NonNullCardContentLayout.dart';
import 'package:edilclima_app/Components/selectCardLayout/NullCardContentLayout.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';

class UndetailedCardLayout extends StatelessWidget {

  CardData? cardData;
  double angle;
  bool animate;
  Function animCallback;
  Function newCardCallback;
  bool newCard;
  late Widget lottieWidget; 
  UndetailedCardLayout(this.cardData, this.angle, this.animate,
      this.animCallback, this.newCardCallback, this.newCard);
  
  

  @override
  Widget build(BuildContext context) {
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
                if(moveEvent.delta.dx > 3) {
                  rotationSense = rotVersus.Right;
                }
                if(moveEvent.delta.dx < -3) {
                  rotationSense = rotVersus.Left;
                }
              },
          onPointerUp: (_){
            if(!ongoingAnimation){
          animCallback();
          if(newCard){
            newCardCallback(cardData!.code);
          }
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
              child: newCard ?
              Stack(alignment: Alignment.topRight,
                children: [
                  NonNullCardContentLayout(cardData!, true, lottieWidget, newCard),
                  Lottie.asset('assets/animations/new.json', animate: true,
                        width: screenWidth * 0.12, height: screenWidth * 0.12)
                ],) :
              NonNullCardContentLayout(cardData!, true, lottieWidget, newCard)));
      }
      else{
        return
          Container(
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
              child: newCard ?
                  Stack(alignment: Alignment.topRight,
                  children: [
                      NonNullCardContentLayout(cardData!, false, lottieWidget, newCard),
                      Lottie.asset('assets/animations/new.json', animate: true,
                      width: screenWidth * 0.12, height: screenWidth * 0.12)
                  ],) :
              NonNullCardContentLayout(cardData!, false, lottieWidget, newCard));
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
            child:
            Container(
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
            NullCardContentlayout(true)));
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
            NullCardContentlayout(false));
      }
      }
    }
  }