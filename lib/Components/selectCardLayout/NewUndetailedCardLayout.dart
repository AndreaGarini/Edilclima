import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/StylizedText.dart';
import 'HorizontalStatsCard.dart';

class NewUndetailedCardLayout extends StatefulWidget{

  bool onFocus;
  CardData cardData;
  NewUndetailedCardLayout(this.onFocus, this.cardData);

  @override
  State<StatefulWidget> createState() => NewUndetailedCardLayoutState();

}

class NewUndetailedCardLayoutState extends State<NewUndetailedCardLayout> {

  late Widget lottieWidget;

  @override
  Widget build(BuildContext context) {
    if(widget.onFocus){
      switch (widget.cardData!.type){
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

      return
        Container(
            width: screenWidth * 0.45,
            height: screenHeight * 0.3,
            margin: EdgeInsets.only(right: screenWidth * 0.1, left: screenWidth * 0.1, bottom: screenHeight * 0.05),
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
                    Expanded(flex: 2, child: StylizedText(darkBluePalette, widget.cardData!.code, null, FontWeight.bold)),
                    Divider(indent: screenWidth * 0.1, endIndent: screenWidth * 0.1, color: darkBluePalette, thickness: 1),
                    Expanded(flex: 10, child: lottieWidget),
                    Expanded(flex: 10, child:
                    Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Expanded(flex: 10, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(flex: 5, child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    Expanded(flex: 1, child: HorizontalStatsCard("comfort", widget.cardData!.comfort)),
                                    Expanded(flex: 1, child: HorizontalStatsCard("smog", widget.cardData!.smog)),
                                  ])),
                              Expanded(flex: 5, child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  Expanded(flex: 1, child: HorizontalStatsCard("money", widget.cardData!.money)),
                                  Expanded(flex: 1, child: HorizontalStatsCard("energy", widget.cardData!.energy)),
                                ],),),
                            ],)),
                        ])),
                  ],)
            )
        );
    }
    else{
      return Container(
          width: screenWidth * 0.35,
          height: screenHeight * 0.3,
          margin: EdgeInsets.only(bottom: screenHeight * 0.05),
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
                    Expanded(flex: 2, child: StylizedText(darkBluePalette, widget.cardData!.code, null, FontWeight.bold)),
                    Divider(indent: screenWidth * 0.1, endIndent: screenWidth * 0.1, color: darkBluePalette, thickness: 1),
                    const Spacer(flex: 20)
                  ])
          )
      );
    }
  }
}