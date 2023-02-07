
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/Components/generalFeatures/TutorialAnimatedLine.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Screens/WaitingScreen.dart';

class OverlayerTutorialFeatures extends StatelessWidget{

  int tutorialPhase;
  GameModel gameModel;
  void Function(GameModel gameModel) buttonCallback;
  OverlayerTutorialFeatures(this.tutorialPhase, this.buttonCallback, this.gameModel);

  String tutorialText0 = "La barra in alto riporta il tuo team, il budget disponibile per la squadra e, durante il tuo turno di gioco, il timer."
      "\nRicorda, potrai navigare l'app in quaunque momento, ma solo durante il tuo turno potrai fare una mossa.";

  String tutorialText1 = "La sezione centrale indica la carta giocata per ogni mese, potrai giocare una carta soltanto "
      "se il mese corrispondente non è già occupato. scorri i mesi per trovare le restanti posizioni libere.";

  String tutorialText2 = "Nella parte inferiore troverai le tue carte, fai swipe a destra o sinistra per aprire il mazzo."
      "\nPotrai scorrere le carte facendo swipe a destra e sinistra.";

  String tutorialText3 = "La carta giocabile sarà quella al centro della rosa ."
      "\nCliccando logo di info a destra otterrai tutte le inforazioni della carta centrale";

  String tutorialText4 = "Durante ogni turno potrai giocare una carta dalla pagina Gioca carta, "
      "oppure prendere una carta già giocata dalla pagina Prendi carta, o ancora visualizzare i dati delle squadre dalla pagna Squadre. ";

  TutorialAnimatedLine containerLine = TutorialAnimatedLine(screenWidth * 0.02);

  @override
  Widget build(BuildContext context) {
    switch(tutorialPhase){
      case 0: {
        //info row
        return Stack(children: [
          Positioned(top: 0, left: screenWidth * 0.075, width: screenWidth * 0.85, height: screenHeight * 0.08,
              child: containerLine),
          Positioned(top: screenHeight * 0.1, left: 0, width: screenWidth, height: screenHeight * 0.4,
              child: Padding(padding: EdgeInsets.all(screenWidth * 0.02),
              child:
                Container(
                color: lightBluePalette,
                child: Card(
                elevation: 10,
                child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Spacer(),
                  Expanded(flex: 10, child:   Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Expanded(flex: 4, child: Center(child: Text("Tutorial", style: TextStyle(color: darkBluePalette,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',),
                            textAlign: TextAlign.justify))),
                        Expanded(flex: 12, child: Text(tutorialText0, style: TextStyle(color: darkBluePalette,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',),
                            textAlign: TextAlign.justify)),
                        const Spacer(),
                        Expanded(flex: 3, child: SizedButton(screenWidth * 0.3, "Ok!", () {buttonCallback(gameModel);})),
                        const Spacer()
                      ])),
                  const Spacer()
                  ]),
              ))))
        ]);
      }
      case 1: {
        //swipable cards
        return Stack(children: [
          Positioned(top: screenHeight * 0.08, left: 0, width: screenWidth, height: screenHeight * 0.35,
              child: containerLine),
          Positioned(top: screenHeight * 0.45, left: 0, width: screenWidth, height: screenHeight * 0.35,
              child: Padding(padding: EdgeInsets.all(screenWidth * 0.02),
                child:
                    Container(
                        color: lightBluePalette,
                    child:  Card(
                      elevation: 10,
                      child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, children: [
                            const Spacer(),
                            Expanded(flex: 10, child:   Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Expanded(flex: 4, child: Center(child: Text("Tutorial", style: TextStyle(color: darkBluePalette,
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',),
                                      textAlign: TextAlign.justify))),
                                  Expanded(flex: 12, child: Text(tutorialText1, style: TextStyle(color: darkBluePalette,
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Roboto',),
                                      textAlign: TextAlign.justify)),
                                  const Spacer(),
                                  Expanded(flex: 3, child: SizedButton(screenWidth * 0.3, "Ok!", () {buttonCallback(gameModel);})),
                                  const Spacer()
                                ])),
                            const Spacer()
                          ]),
                    ))))
        ]);
      }
      case 2: {
        //rosa carte 1
        return Stack(children: [
          Positioned(top: screenHeight * 0.4, left: 0, width: screenWidth, height: screenHeight * 0.48,
              child: containerLine),
          Positioned(top: screenHeight * 0.08, left: 0, width: screenWidth, height: screenHeight * 0.33,
              child: Padding(padding: EdgeInsets.all(screenWidth * 0.02),
                child: Container(
                  color: lightBluePalette,
                  child:
                  Card(
                  child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const Spacer(),
                        Expanded(flex: 10, child:   Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(flex: 4, child: Center(child: Text("Tutorial", style: TextStyle(color: darkBluePalette,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',),
                                  textAlign: TextAlign.justify))),
                              Expanded(flex: 12, child: Text(tutorialText2, style: TextStyle(color: darkBluePalette,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto',),
                                  textAlign: TextAlign.justify)),
                              const Spacer(),
                              Expanded(flex: 3, child: SizedButton(screenWidth * 0.3, "Ok!", () {buttonCallback(gameModel);})),
                              const Spacer()
                            ])),
                        const Spacer()
                      ]),
                ))))
        ]);
      }
      case 3: {
        //rosa carte 2
        return Stack(children: [
          Positioned(top: screenHeight * 0.4, left: 0, width: screenWidth, height: screenHeight * 0.48,
              child: containerLine),
          Positioned(top: screenHeight * 0.08, left: 0, width: screenWidth, height: screenHeight * 0.33,
              child: Padding(padding: EdgeInsets.all(screenWidth * 0.02),
                child: Container(
                      color: lightBluePalette,
                      child:
                      Card(
                      child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const Spacer(),
                        Expanded(flex: 10, child:   Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(flex: 4, child: Center(child: Text("Tutorial", style: TextStyle(color: darkBluePalette,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',),
                                  textAlign: TextAlign.justify))),
                              Expanded(flex: 12, child: Text(tutorialText3, style: TextStyle(color: darkBluePalette,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto',),
                                  textAlign: TextAlign.justify)),
                              const Spacer(),
                              Expanded(flex: 3, child: SizedButton(screenWidth * 0.3, "Ok!", () {
                                containerLine.lockController();
                                buttonCallback(gameModel);})),
                              const Spacer()
                            ])),
                        const Spacer()
                      ]),
                ))))
        ]);
      }
      case 4: {
        //bottom nav bar
        return Stack(children: [
          Positioned(top: screenHeight * 0.08, left: 0, width: screenWidth, height: screenHeight * 0.33,
              child: Padding(padding: EdgeInsets.all(screenWidth * 0.02),
                child: Container(
                  color: lightBluePalette,
                  child:
                  Card(
                  child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const Spacer(),
                        Expanded(flex: 10, child:   Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Expanded(flex: 4, child: Center(child: Text("Tutorial", style: TextStyle(color: darkBluePalette,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',),
                                  textAlign: TextAlign.justify))),
                              Expanded(flex: 12, child: Text(tutorialText4, style: TextStyle(color: darkBluePalette,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto',),
                                  textAlign: TextAlign.justify)),
                              const Spacer(),
                              Expanded(flex: 3, child: SizedButton(screenWidth * 0.3, "Avanti",
                                      () {
                                buttonCallback(gameModel);
                              })),
                              const Spacer()
                            ])),
                        const Spacer()
                      ]),
                ))))
        ]);
      }
      default: {
        return Text("");
      }
    }
  }

}