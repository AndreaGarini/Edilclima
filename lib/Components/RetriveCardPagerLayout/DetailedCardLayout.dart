
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardContent.dart';
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

    if(cardData!=null){

      return Container(
          width: screenWidth * 0.8,
          height: height ?? screenHeight * 0.6,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
              color: Colors.white,
              boxShadow: [ BoxShadow(
                color: lightOrangePalette.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 0), // changes position of shadow
              )]),
        child: Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
            elevation: 10,
            color: backgroundGreen,
            shadowColor: darkGreyPalette,
            child:
                ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(20)),
                child:  Padding(padding: EdgeInsets.only(top: screenWidth * 0.02),
                child: SizedBox(height: screenHeight * 0.57,
                    width: screenWidth * 0.8,
                    child: DetailedCardContent(cardData!, bodyText)))
                )
        )
      );
    }
    else{
      return Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.6,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
              color: Colors.white,
              boxShadow: [ BoxShadow(
                color: darkGreyPalette.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 0), // changes position of shadow
              )]),
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