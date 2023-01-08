
import 'package:edilclima_app/Components/generalFeatures/AnimatedGradient.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
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

DialogData? lastDialogData;
bool tutorialOpened = false;

class MainScreenContentState extends State<MainScreenContent>{


  @override
  Widget build(BuildContext parentContext) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

      var tutorialComponents = TutorialComponents(gameModel);

      //todo: far partire il tutorial solo una volta
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if(gameModel.playerLevelCounter == 1
            && gameModel.playerLevelStatus == "preparing"
            && gameModel.showDialog==null
            && gameModel.tutorialOngoing
            && !tutorialOpened){
          startTutorial(parentContext, gameModel, tutorialComponents);
        }
      });

      if(gameModel.showDialog!=null && gameModel.showDialog!=lastDialogData){
        setDialogAvailable(parentContext, gameModel.showDialog!, gameModel);
      }

      return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: infoRow()),
            Expanded(flex: 10, child: widget.child)
          ],),
        bottomNavigationBar:  SizedBox(width: screenWidth, height: screenHeight * 0.1, child: BottomNavBar(context))
      );
    });
  }


  //todo: sistemare lo stile della dialog
  Future<void> openDialog(BuildContext context, DialogData data, GameModel gameModel){

    return showDialog<void>(context: context, builder: (BuildContext context){

      if(!data.addButton)
        {
          Future.delayed(const Duration(seconds: 2), () {
            gameModel.setDialogData(null);
            Navigator.of(context).pop();
          });
          return Dialog(child: Center(child:
            AnimatedGradient(data.title, screenWidth * 0.4, 1500, 'Inspiration', false)));
        }

      else {
        return Dialog(child: Column(mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded( child: Center(child: StylizedText(darkBluePalette, data.title, screenWidth * 0.08, FontWeight.bold))),
              ],
            )),
            Expanded(flex: 6, child: Row(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(flex: 10, child: data.body!),
                const Spacer()
              ],
            )),
            const Spacer(),
            data.addButton ? SizedButton(screenWidth * 0.5, data.buttonText!,
                        (){ Navigator.of(context).pop();
                data.buttonCallback!.call(); })
                : const Spacer(),
            const Spacer()
          ],
        ));
      }
  });
  }

  Future<void> startTutorial(BuildContext parentContext,
      GameModel gameModel,
      TutorialComponents tutorialComponents) async{
    return Future<void>.delayed(const Duration(milliseconds: 100),
            () {
              setState((){
                tutorialOpened = true;
              });
              DialogData data = DialogData("Le carte", tutorialComponents.tutorialWidget1(), true, "Ok!", tutorialComponents.buttonCallback1);
              gameModel.setDialogData(data);
  });}

  Future<void> setDialogAvailable(BuildContext parentContext, DialogData data, GameModel gameModel) async{
    return Future<void>.delayed(const Duration(milliseconds: 200),
            () {
      openDialog(parentContext, data, gameModel);
      setState((){ lastDialogData = gameModel.showDialog;});});
  }
}