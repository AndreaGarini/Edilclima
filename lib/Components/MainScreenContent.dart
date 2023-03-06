import 'package:edilclima_app/Components/generalFeatures/AnimatedGradient.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/OverlayerTutorialFeatures.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/Components/generalFeatures/TutorialComponents.dart';
import 'package:edilclima_app/DataClasses/DialogData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

double mainHeight = 0;
double mainWidth = 0;

late Function triggerTutorialOpening;

class MainScreenContentState extends State<MainScreenContent>{

  DialogData? lastDialogData;
  int tutorialPhase = 0;
  late bool openTutorial;
  late bool firstOpening;


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    triggerTutorialOpening = (bool value){
      setOpenTutorial(value);
    };
    openTutorial = false;
    firstOpening = true;
  }


  void buttonCallback(GameModel gameModel){
    setState(() {
      if(tutorialPhase < 4){
        tutorialPhase++;
      }
      else{
        gameModel.setTutorialDone();
        triggerTutorialOpening(false);
        tutorialPhase = 0;
      }
    });
  }

  @override
  Widget build(BuildContext parentContext) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

      WidgetsBinding.instance?.addPostFrameCallback((_){
          if(firstOpening){
            firstOpening = false;
            gameModel.checkTutorial().then((value)  {
              if(gameModel.playerLevelCounter == 1
                  && gameModel.playerLevelStatus == "preparing"
                  && gameModel.tutorialDone==false){
                setOpenTutorial(true);
              }
            });
          }
      });

      if(gameModel.showDialog!=null && gameModel.showDialog!=lastDialogData){
        setDialogAvailable(parentContext, gameModel.showDialog!, gameModel);
      }

      if(openTutorial){
          return
            SafeArea(child:
                LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
                  mainHeight = constraints.maxHeight;
                  mainWidth = constraints.maxWidth;
                  return Stack(children: [Scaffold(
                      body: Column(mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 1, child: infoRow()),
                          Expanded(flex: 10, child: widget.child)
                        ],),
                      bottomNavigationBar:  SizedBox(width: screenWidth, height: screenHeight * 0.12, child: BottomNavBar(context))
                  ),
                    OverlayerTutorialFeatures(tutorialPhase, buttonCallback, gameModel)
                  ]);
            })
            );
        }
        else{
          return
            SafeArea(child:
              LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
            mainHeight = constraints.maxHeight;
            mainWidth = constraints.maxWidth;
            return Scaffold(
              body: Column(mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: infoRow()),
                  Expanded(flex: 10, child: widget.child)
                ],),
              bottomNavigationBar:  SizedBox(width: screenWidth, height: screenHeight * 0.12, child: BottomNavBar(context))
          );
              }));
        }
    });
  }

  Future<void> openDialog(BuildContext context,
      DialogData data,
      GameModel gameModel){

    return showDialog<void>(context: context, builder: (BuildContext context){

      if(data.autoExpire)
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
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
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

  Future<void> setOpenTutorial(bool value) async{

    return Future<void>.delayed(const Duration(milliseconds: 1), (){
            setState((){
               openTutorial = value;
            });
          }
          );
  }
}