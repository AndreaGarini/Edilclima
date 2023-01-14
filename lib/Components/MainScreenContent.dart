import 'package:edilclima_app/Components/generalFeatures/AnimatedGradient.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/OverlayerTutorialFeatures.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/Components/generalFeatures/TutorialComponents.dart';
import 'package:edilclima_app/DataClasses/DialogData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';
import '../Screens/WaitingScreen.dart';
import 'BottomNavBar.dart';
import 'InfoRowComponents/infoRow.dart';

class MainScreenContent extends StatefulWidget {

  Widget child;

  MainScreenContent(this.child);

  @override
  State<MainScreenContent> createState() => MainScreenContentState();
}

class MainScreenContentState extends State<MainScreenContent>{

  DialogData? lastDialogData;
  int tutorialPhase = 0;
  late TutorialComponents tutorialComponents;
  bool firstOpening = true;

  void buttonCallback(GameModel gameModel){
    setState(() {
      if(tutorialPhase <= 4){
        tutorialPhase++;
      }
      else{
        gameModel.setTutorialDone();
      }
    });
  }

  @override
  Widget build(BuildContext parentContext) {

    //todo: dialog ancora appaiono 2 volte
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      WidgetsBinding.instance?.addPostFrameCallback((_){
        if(firstOpening){
           gameModel.checkTutorial();
           firstOpening = false;
        }
      });
      /*tutorialComponents = TutorialComponents(gameModel,
              (){ Navigator.of(parentContext).pop();});*/

      if(gameModel.showDialog!=null && gameModel.showDialog!=lastDialogData){
        setDialogAvailable(parentContext, gameModel.showDialog!, gameModel);
      }

      if(gameModel.playerLevelCounter == 1
          && gameModel.playerLevelStatus == "preparing"
          && gameModel.tutorialDone==false){
          return
            Stack(children: [Scaffold(
                body: Column(mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: screenHeight * 0.05, color: darkBluePalette),
                    Expanded(flex: 1, child: infoRow()),
                    Expanded(flex: 10, child: widget.child)
                  ],),
                bottomNavigationBar:  SizedBox(width: screenWidth, height: screenHeight * 0.12, child: BottomNavBar(context))
            ),
              OverlayerTutorialFeatures(tutorialPhase, buttonCallback, gameModel)
            ]);
        }
        else{
          return Scaffold(
              body: Column(mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: screenHeight * 0.05, color: darkBluePalette),
                  Expanded(flex: 1, child: infoRow()),
                  Expanded(flex: 10, child: widget.child)
                ],),
              bottomNavigationBar:  SizedBox(width: screenWidth, height: screenHeight * 0.12, child: BottomNavBar(context))
          );
        }
    });
  }

  Future<void> openDialog(BuildContext context,
      DialogData data,
      GameModel gameModel){

    return showDialog<void>(context: context, builder: (BuildContext context){

      if(!data.buttonAdded)
        {
          Future.delayed(const Duration(seconds: 2), () {
            if(gameModel.tutorialOngoing){
              gameModel.endTutorialAndNotify();
            }
            gameModel.setDialogData(null);
            Navigator.of(context).pop();
          });
          return Dialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(child:
            AnimatedGradient(data.title, screenWidth * 0.4, 1500, 'Inspiration', false)));
        }
      else{
        return Dialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded( child: Center(child: StylizedText(darkBluePalette, data.title, screenWidth * 0.08, FontWeight.bold))),
              ],
            )),
            Expanded(flex: 8, child: Row(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(flex: 10, child: data.body!),
                const Spacer()
              ],
            )),
          ],
        ));
      }
  });
  }

  Future<void> setDialogAvailable(BuildContext parentContext, DialogData data, GameModel gameModel) async{
    return Future<void>.delayed(const Duration(milliseconds: 1),
            () {
      openDialog(parentContext, data, gameModel);
      lastDialogData = data;});
  }
}