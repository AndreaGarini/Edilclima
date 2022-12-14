
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/DataClasses/TeamInfo.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:lottie/lottie.dart';

import '../generalFeatures/ColorPalette.dart';

class TeamCardLayout extends StatelessWidget{

  MapEntry<String, TeamInfo?> teamStat;

  TeamCardLayout(this.teamStat);


  @override
  Widget build(BuildContext context) {
   return  Container(
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
    child: Container(
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
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
    darkBluePalette,
    lightBluePalette,
    Colors.transparent,
    Colors.transparent,
    lightOrangePalette,
    darkOrangePalette,
    ],
    stops: const [0,0.1,0.2,0.8,0.9, 1]
    )),
    child: Card(shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(15.0)),
    elevation: 10,
    color: backgroundGreen,
    child: Stack(
      alignment: Alignment.bottomRight,
      children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              StylizedText(darkBluePalette, teamStat.key, screenHeight * 0.04, FontWeight.bold)
            ])),
          Expanded(flex: 3, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Expanded(flex: 13, child:  Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Expanded(flex: 5, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(flex: 2, child: Icon(Elusive.leaf, color: lightOrangePalette)),
                              Expanded(flex: 4, child: StylizedText(darkBluePalette, "Smog : ", screenHeight * 0.025, FontWeight.normal)),
                              Expanded(flex: 2, child: StylizedText(darkBluePalette, teamStat.value?.smog!=null ? teamStat.value!.smog.toString() : "" ,
                                  screenHeight * 0.025, FontWeight.bold)),
                            ])),
                      ])),
                    Expanded(flex: 13, child:  Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Expanded(flex: 5, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(flex: 2, child:  Icon(Elusive.lightbulb, color: darkBluePalette)),
                              Expanded(flex: 4, child: StylizedText(darkBluePalette, "Energy : ", screenHeight * 0.025, FontWeight.normal)),
                              Expanded(flex: 2, child: StylizedText(darkBluePalette, teamStat.value?.energy!=null ? teamStat.value!.energy.toString() : "" ,
                                  screenHeight * 0.025, FontWeight.bold)),
                            ]))
                      ])),
                    Expanded(flex: 13, child:  Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Expanded(flex: 5, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(flex: 2, child:   Icon(Icons.home, color: lightBluePalette)),
                              Expanded(flex: 4, child: StylizedText(darkBluePalette, "Comfort : ", screenHeight * 0.025, FontWeight.normal)),
                              Expanded(flex: 2, child: StylizedText(darkBluePalette, teamStat.value?.comfort!=null ? teamStat.value!.comfort.toString() : "" ,
                                  screenHeight * 0.025, FontWeight.bold)),
                            ]))
                      ])),
                  ])),
              Expanded(child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded( child: Center(child: StylizedText(darkBluePalette, "Punteggio", screenHeight * 0.025, FontWeight.normal))),
                      ])),
                  Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded( child: Center(child: StylizedText(darkBluePalette, "${teamStat.value?.points}", screenHeight * 0.04, FontWeight.bold)))
                      ])),
                  const Spacer(flex: 4)
                ],))
            ],)),
        ],),
      SizedBox(
        height: screenWidth * 0.32,
        width: screenWidth * 0.5,
        child: Center(child: Lottie.asset('assets/animations/TeamWorking.json',
            width: screenWidth * 0.35,
            height: screenWidth * 0.35,
            animate: false)),
      )
    ])
   )));
  }


}