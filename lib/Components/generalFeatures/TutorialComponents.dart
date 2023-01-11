
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/GameModel.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';

import 'ColorPalette.dart';
import 'StylizedText.dart';

class TutorialComponents extends StatefulWidget {

  //todo: stile della dialog da sistemare e dialog da arrotondare
  GameModel gameModel;
  Function? closeTutorialCallback;

  TutorialComponents(this.gameModel, this.closeTutorialCallback);

  @override
  State<StatefulWidget> createState() => TutorialComponentsState();
}

class TutorialComponentsState extends State<TutorialComponents> {

  late Widget tutorialScreen;
  late Function currentCallback;

  String textWidget1 = "Le carte simboleggiano le mosse che è possibile effettuare. \n Ogni carta presenta delle icone che indicano : ";

  String textWidget2 = "Ad ogni turno è possibile giocare una carta oppure prelevare una carta già "
      "posizionata sul tabellone di gioco. \n La navigazione in basso permette di scegliere fra queste opzioni."
      "\n L' icona di info nella pagina Gioca carta permette di visualizzare tutte le informazioni relative alla carta centrale."
      "\n Alcune carte possono essere giocate solo se altre carte sono state già posizionate, controlla le info delle carte per scoprire quali!. ";

  String textWidget3 = "Per sfogliare le carte nella pagina Gioca carta : ";

  Widget tutorialWidget1 (){

    return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Spacer(),
          Expanded(flex: 8, child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(flex: 2, child: StylizedText(darkBluePalette, textWidget1, screenWidth * 0.05, FontWeight.normal)),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(flex: 1, child:   Icon(Icons.home, color: lightBluePalette, size: screenWidth * 0.1,)),
                      Expanded(flex: 4, child: Center(child: StylizedText(darkBluePalette, " : l' impatto sul comfort", screenWidth * 0.04, FontWeight.normal),))
                    ])),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(flex: 1, child:    Icon(Elusive.leaf, color: lightOrangePalette, size: screenWidth * 0.1)),
                      Expanded(flex: 4, child: Center(child: StylizedText(darkBluePalette, " : l' impatto ambientale", screenWidth * 0.04, FontWeight.normal),))
                    ])),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(flex: 1, child: Icon(Elusive.lightbulb, color: darkBluePalette, size: screenWidth * 0.1),),
                      Expanded(flex: 4, child: Center(child: StylizedText(darkBluePalette, " : l' impatto energetico", screenWidth * 0.04, FontWeight.normal),))
                    ])) ,
              ])),
        ]);
  }

  Widget tutorialWidget2 (){

    return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Spacer(),
          Expanded(flex: 8, child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(flex: 5, child: Center(child: StylizedText(darkBluePalette, textWidget2, screenWidth * 0.04, FontWeight.normal))),
                const Spacer()
              ])),
        ]);
  }

  Widget tutorialWidget3 () {

    return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Spacer(),
          Expanded(flex: 8, child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(flex: 2, child: StylizedText(darkBluePalette, textWidget3, screenWidth * 0.04, FontWeight.normal)),
                Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(flex: 1, child:   Image.asset('assets/images/arrow-left.png')),
                      Expanded(flex: 2, child: Center(child:
                      StylizedText(darkBluePalette, "Swipe left per scorrere le carte a sinistra", screenWidth * 0.035, FontWeight.normal),))
                    ])),
                const Spacer(),
                Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(flex: 1, child:    Image.asset('assets/images/arrow-right.png')),
                      Expanded(flex: 2, child: Center(child:
                      StylizedText(darkBluePalette, "Swipe right per scorrere le carte a destra", screenWidth * 0.035, FontWeight.normal),))
                    ])),
                const Spacer(),
                Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(flex: 1, child: Image.asset('assets/images/arrow-up.png')),
                      Expanded(flex: 2, child: Center(child:
                      StylizedText(darkBluePalette, "Swipe up per selezionare la carta centrale", screenWidth * 0.035, FontWeight.normal),))
                    ])),
                const Spacer(),
                Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(flex: 1, child:   Image.asset('assets/images/arrow-down.png')),
                      Expanded(flex: 2, child: Center(child:
                      StylizedText(darkBluePalette, "Swipe down sulla carta selezionata per riporla", screenWidth * 0.035, FontWeight.normal),))
                    ])),
              ])),
          const Spacer()
        ]);
  }

  void buttonCallback1 (){
    setState((){
      tutorialScreen = tutorialWidget2();
    });
    currentCallback = buttonCallback2;
  }

  void buttonCallback2 (){
    setState(() {
      tutorialScreen = tutorialWidget3();
    });
    currentCallback = closingCallback;
  }


  void closingCallback (){
    if(widget.closeTutorialCallback!=null){
      widget.closeTutorialCallback!();
    }
    widget.gameModel.endTutorialAndNotify();
  }

  @override
  void initState() {
    super.initState();

    tutorialScreen = tutorialWidget1();
    currentCallback = buttonCallback1;
  }

  @override
  Widget build(BuildContext context) {

    return Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(flex: 8, child: tutorialScreen),
        Expanded(flex: 2, child: Center(child: SizedButton(screenWidth * 0.3, "Ok!", () {currentCallback.call();})))
      ],);
  }

}