
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Screens/WaitingScreen.dart';
import '../gameBoardScreen/GameBoardChartBar.dart';
import '../gameBoardScreen/GameBoardPngStack.dart';
import 'ColorPalette.dart';
import 'SizedButton.dart';

class MasterTutorialFeatures extends StatefulWidget{

  Function closeMasterTutorialDialog;

  MasterTutorialFeatures(this.closeMasterTutorialDialog);

  @override
  State<StatefulWidget> createState() => MasterTutorialFeaturesState();
}

class MasterTutorialFeaturesState extends State<MasterTutorialFeatures> {
  
  late int tutorialPhase; 
  late List<Widget> tutorialContent;

  //todo: aggiungere animazione dein png in modo da mostrarla già nel tutorial

  Map<int, Map<String, double>> coordMaps = {
    2 : {
      "top" : screenHeight * 0.04,
      "left" :  screenWidth * 0.065,
      "width" : screenWidth * 0.20,
      "height" : screenHeight * 0.33
    },
    3 : {
      "top" : screenHeight * 0.07,
      "left" :  screenWidth * 0.25,
      "width" : screenWidth * 0.26,
      "height" : screenHeight * 0.37
    }
  };

  String textWidget1 = "Il gioco sarà diviso in livelli: in ognuno di essi sarete chiamati a progettare un intervento su un edificio differente per necessità e caratteristiche."
      "\nL'intervento si svilupperà lungo 12 mesi e per oguno di essi potrete scegliere quali lavori effettuare."
      "\nAl termine del tempo stabilito per un livello ogni squadra otterrà dei punti in base all'adeguatezza degli interventi progettati.";
  String textWidget2 = "Il tabellone di gioco verrà diviso in quattro aree come quella qui presentata, una per ogni squadra. "
      "\nAll'inizio di ogni livello la squadra riceverà un obbiettivo specifico.\nIl grafico qui indicato rappresenta la vicinanza in percentuale all' ottenimento "
      "dell' obbiettivo.";
  String textWidget3 = "Nella parte centrale troverete una rappresentazione dell' edficio sul quale state lavorando. "
      "\nIn base agli interventi sceglti l'ambiente si modificherà di consesguenza.";
  String textWidget4 = "";

  Widget titleWidget = Text("Tutorial", style: TextStyle(color: darkBluePalette,
    fontSize: screenWidth * 0.035,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',),
      textAlign: TextAlign.justify);
  
  Widget exampleGameBoardChart =
  Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
  crossAxisAlignment: CrossAxisAlignment.center, children: [
    const Spacer(),
      Expanded(flex: 10, child:
      Card(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
          elevation: 10,
          child:
          Stack(alignment: Alignment.topLeft,
              children: [
                Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: Center(child: Text("Your team", style:
                      TextStyle(color: darkBluePalette,
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.bold)))),
                      Expanded(flex: 4, child: GameBoardPngStack(screenHeight * 0.65, screenWidth * 0.4))]),
                Padding(padding: EdgeInsets.only(top: screenHeight * 0.05, left: screenHeight * 0.01),
                    child:
                    SizedBox(width: screenHeight * 0.3, height: screenHeight * 0.3,
                        child:
                        Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                            shadowColor: darkGreyPalette,
                            child: Stack(alignment: Alignment.center,
                                children: [
                                  Container(color: Colors.transparent, height: screenHeight * 0.25, width:  screenHeight * 0.25,
                                    child: GameBoardChartBar("smog", "team1", screenHeight),),
                                  Container(color: Colors.transparent, height: screenHeight * 0.15, width: screenHeight * 0.15,
                                    child: GameBoardChartBar("energy", "team1", screenHeight),),
                                  Container(color: Colors.transparent, height: screenHeight * 0.05, width: screenHeight * 0.05,
                                    child: GameBoardChartBar("comfort", "team1", screenHeight),)
                                ]))))
              ]))),
    const Spacer()
    ],);
  

  @override
  void initState() {
    super.initState();
    tutorialPhase = 1;
    tutorialContent = dynamicTutorialContent(tutorialPhase);
  }
  
  @override
  Widget build(BuildContext context) {

      return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, children: tutorialContent);
  }

  List<Widget> dynamicTutorialContent(int tutorialPhase) {
    switch(tutorialPhase){
      case 1:
        return [
          //introduzione
          Expanded(child: Center(child:
          generateTutorialCard(textWidget1,screenWidth * 0.025, true)
            ,))
        ];
      case 2:
        return [
          //focus grafico
          Expanded(child: generateTutorialView(coordMaps[2]!),),
          Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Spacer(),
              Expanded(flex: 6, child:  generateTutorialCard(textWidget2, screenWidth * 0.02, false)),
              const Spacer()
            ]))
        ];
      case 3:
        return [
          //focus png stack
          Expanded(child: generateTutorialView(coordMaps[3]!),),
          Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Spacer(flex: 2),
              Expanded(flex: 6, child:  generateTutorialCard(textWidget3, screenWidth * 0.02, false)),
              const Spacer(flex: 2)
            ],))
        ];
      default:
        return [];
    }
  }

  Widget generateTutorialCard(String text, double fontSize, bool showTitle){
    return Card(color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.02)),
        shadowColor: backgroundGreen,
        elevation: 7,
        child: showTitle ? Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 2, child: Center(child: titleWidget)),
              Expanded(flex: 6, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Spacer(),
                    Expanded(flex: 6, child: Text(text, style: TextStyle(color: darkBluePalette,
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',),
                        textAlign: TextAlign.justify)),
                    const Spacer()
                  ])), 
              Expanded(flex: 1, child: SizedButton(screenWidth * 0.2, "Ok!", () {buttonCallback();})),
              const Spacer()
            ]) :
        Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 10, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Spacer(),
                    Expanded(flex: 10, child: Text(text, style: TextStyle(color: darkBluePalette,
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',),
                        textAlign: TextAlign.justify)),
                    const Spacer()
                  ])),
              Expanded(flex: 2, child: SizedButton(screenWidth * 0.2, "Ok!", () {buttonCallback();})),
              const Spacer()
            ])
    );
  }
  
  Widget generateTutorialView(Map<String, double> coordMap){
    return Stack(children: [
          exampleGameBoardChart,
      Positioned(top: coordMap["top"], left: coordMap["left"], width: coordMap["width"], height: coordMap["height"],
          child: Container(
            decoration: BoxDecoration(border: Border.all(
              color: lightBluePalette,
              width: screenWidth * 0.015,
            ), color: Colors.transparent),
          ))
    ]);
  }

  void buttonCallback() {
    if(tutorialPhase==3){
      print("closing callback called");
      widget.closeMasterTutorialDialog();
    }
    else{
      tutorialPhase++;
      setState(() {
        tutorialContent = dynamicTutorialContent(tutorialPhase);
      });
    }
  }
}