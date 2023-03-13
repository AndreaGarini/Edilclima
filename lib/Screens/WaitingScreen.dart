
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Components/generalFeatures/AnimatedGradient.dart';
import '../GameModel.dart';
import 'dart:io' show Platform;

class WaitingScreen extends StatefulWidget {
  @override
  State<WaitingScreen> createState() => WaitingScreenState();
}

double screenWidth = 0;
double screenHeight = 0;
bool routerCalled = false;

class WaitingScreenState extends State<WaitingScreen> {

  //todo: dopo che hai aggiunto l'uid ripristina model response null e il commentato
  //todo: sistema matchJoinedYet nel game Model
  late bool lottieLoaded;
  late bool masterPath;
  late bool wrongPassword;
  late bool firstOpening;
  bool? matchJoinedYet;


  @override
  void initState() {
    super.initState();
    firstOpening = true;
    lottieLoaded = false;
    masterPath = false;
    wrongPassword = false;
    routerCalled = false;
  }

  Widget dynamicWaitingContent (GameModel gameModel){

    double dividerIndent = screenHeight > screenWidth ? screenWidth * 0.3 : 0;
    double textFontSize = screenWidth * 0.05;

      if(masterPath){
        return Expanded(flex: 6, child:
         Stack(
           alignment: Alignment.topLeft,
           children: [
             Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center, children: [
                   const Spacer(),
                   Expanded(child: Text("Inserisci la password", style: TextStyle(color: darkBluePalette,
                       fontSize: screenHeight > screenWidth ? screenWidth * 0.05 : screenWidth * 0.03,
                       fontWeight: FontWeight.bold,
                       fontFamily: 'Roboto'),
                       textAlign: TextAlign.justify)),
                   Divider(indent: dividerIndent, endIndent: dividerIndent, color: darkBluePalette, thickness: 2),
                   Spacer(flex:  screenHeight > screenWidth ? 2 : 1),
                   Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center, children: [
                         const Spacer(),
                         Expanded(flex: 4, child: TextField(
                           obscureText: true,
                           decoration: const InputDecoration(
                             border: OutlineInputBorder(),
                             labelText: 'Password',
                           ),
                           onSubmitted: (string) async{
                             await gameModel.checkMasterPassword(string).then((value) {
                               if(value){
                                 context.push("/initialScreen/matchMakingScreen");
                               }
                               else{
                                 setState(() {
                                   wrongPassword = true;
                                   setWrongPasswordFalse();
                                 });
                               }
                             });
                           },
                         )),
                         const Spacer(),
                       ])),
                   const Spacer(),
                   wrongPassword ?  Expanded(flex: 1, child: Text("Password errata", style: TextStyle(color: Colors.redAccent,
                     fontSize: screenWidth * 0.02,
                     fontWeight: FontWeight.normal,
                     fontFamily: 'Roboto',),
                       textAlign: TextAlign.justify)) : const Spacer(flex: 1),
                   const Spacer(flex: 1)
                 ]),
               Positioned( left: screenHeight > screenWidth ? screenWidth * 0.1 : screenWidth * 0,
                   child:
               InkWell(
               onTap: (){
                 setState(() {
                   masterPath = false;
                 });
               },
               child: Icon(Icons.arrow_back_ios, color: darkBluePalette, size:  screenHeight > screenWidth ? screenWidth * 0.1 : screenWidth * 0.05),
             )
             )
           ],
         ));
      }
      else{
        return Expanded(flex: 6, child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 1, child:
              Text("Chi sei?", style: TextStyle(color: darkBluePalette,
                fontSize: textFontSize,
                fontWeight: FontWeight.normal,
                fontFamily: 'Roboto',),
                  textAlign: TextAlign.justify)),
              Divider(indent: dividerIndent, endIndent: dividerIndent, color: darkBluePalette, thickness: 2),
              const Spacer(),
              Expanded(flex: 1, child:
              SizedButton(screenWidth * 0.6, "Il master", () {
                gameModel.masterRegisteredYet().then((value) {
                  if(value) {
                    context.push("/initialScreen/matchMakingScreen");
                  }
                  else{
                    setState(() {
                     masterPath = true;
                    });
                  }
                });
              })),
              const Spacer(),
              Expanded(flex: 1, child:
              SizedButton(screenWidth * 0.6, "Un giocatore", () {context.push("/initialScreen/cameraScreen");})),
              const Spacer(),
            ]));
      }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

      //todo: controlla che to main screen parta solo quando serve;
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if(!routerCalled && firstOpening) {
          firstOpening = false;
          gameModel.matchJoinedYet().then((response) {
            setState(() {
              matchJoinedYet = response;
              if(matchJoinedYet!){
                routerCalled = true;
                if(gameModel.masterUid!=null && gameModel.matchTimestamp!=null){
                  toGameBoard(gameModel);
                }
                else{
                  toMainScreen(gameModel);
                }
              }
            });
          });
        }
      });

      if(matchJoinedYet!=null && !matchJoinedYet!){
        return SafeArea(
             top: Platform.isIOS ? false : true,
             bottom: Platform.isIOS ? false : true,
            child:
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraint) {
              if (constraint.maxWidth != screenWidth &&
                  constraint.maxHeight != screenHeight) {
                newDimensions(constraint.maxHeight, constraint.maxWidth);
              }

              if (screenHeight > screenWidth) {
                return Material(color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const Spacer(),
                        lottieLoaded ? Expanded(flex: 2, child: Center(child:
                        AnimatedGradient("Edilclima", screenHeight * 0.08, 5200,
                            'Inspiration', true)))
                            : const Spacer(flex: 2),
                        const Spacer(),
                        lottieLoaded
                            ? dynamicWaitingContent(gameModel)
                            : const Spacer(flex: 6),
                        Expanded(flex: 7, child: Lottie.asset(
                            'assets/animations/WaitingScreenHome.json',
                            onLoaded: (_) {
                              setState(() {
                                lottieLoaded = true;
                              });
                            })),
                        const Spacer(),
                      ],
                    ));
              }
              else {
                return Material(color: Colors.white, child:
                Row(mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Lottie.asset(
                          'assets/animations/WaitingScreenHome.json',
                          onLoaded: (_) {
                            setState(() {
                              lottieLoaded = true;
                            });
                          })),
                      Expanded(child:
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Spacer(),
                            Expanded(flex: 4,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      const Spacer(),
                                      lottieLoaded ? dynamicWaitingContent(
                                          gameModel) : const Spacer(),
                                      const Spacer(),
                                    ])),
                            const Spacer(),
                          ]))
                    ])
                );
              }
            }));
      }
      else{
          return SafeArea(
              top: Platform.isIOS ? false : true,
              bottom: Platform.isIOS ? false : true,
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
            if(constraints.maxWidth != screenWidth && constraints.maxHeight!=screenHeight){
              newDimensions(constraints.maxHeight, constraints.maxWidth);
            }
            return const Material(color: Colors.white);
          }));
      }
    });
  }

  Future<void> setWrongPasswordFalse() async{
    return Future<void>.delayed(const Duration(milliseconds: 1000), (){
      setState((){
        wrongPassword = false;
      });
    });
  }

  Future<void> newDimensions(height, width) async{
    return Future<void>.delayed(const Duration(milliseconds: 50), (){
      setState((){
        screenWidth = width;
        screenHeight = height;
      });
    });
  }

  Future<void> toMainScreen(GameModel gameModel) async{
    print("to main screen called");
    return Future<void>.delayed(const Duration(milliseconds: 50), () {
      gameModel.listenToLevelChange();
      context.go("/initialScreen/cameraScreen/splashScreen");});
  }

  Future<void> toGameBoard(GameModel gameModel) async{
    print("to game board called");
    return Future<void>.delayed(const Duration(milliseconds: 50), () {
       gameModel.shortPrepareMatch().then((value) =>
           context.go("/initialScreen/matchMakingScreen/gameBoardScreen"));});
  }
}