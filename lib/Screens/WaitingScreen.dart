
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
  bool? modelResponse = false;
  late bool masterPath;
  late bool wrongPassword;


  @override
  void initState() {
    super.initState();
    lottieLoaded = false;
    masterPath = false;
    wrongPassword = false;
    routerCalled = false;
  }

  Widget dynamicWaitingContent (GameModel gameModel){

    double dividerIndent = screenHeight > screenWidth ? screenWidth * 0.3 : 0;
    double TextFontSize = screenHeight > screenWidth ? screenWidth * 0.05 : screenWidth * 0.07;

      if(masterPath){
        return Expanded(flex: 6, child:
         Stack(
           alignment: Alignment.topLeft,
           children: [
             Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center, children: [
                   Expanded(child: Text("Inserisci la password", style: TextStyle(color: darkBluePalette,
                       fontSize: screenHeight > screenWidth ? screenWidth * 0.05 : screenWidth * 0.03,
                       fontWeight: FontWeight.bold,
                       fontFamily: 'Roboto'),
                       textAlign: TextAlign.justify)),
                   Divider(indent: dividerIndent, endIndent: dividerIndent, color: darkBluePalette, thickness: 2),
                   const Spacer(flex: 2),
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
               Positioned( left: screenWidth * 0.1,
                   child:
               InkWell(
               onTap: (){
                 setState(() {
                   masterPath = false;
                 });
               },
               child: Icon(Icons.arrow_back_ios, color: darkBluePalette, size: screenWidth * 0.1),
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
                fontSize: TextFontSize,
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
              SizedButton(screenWidth * 0.6, "Un giocatore", () {context.push("/initialScreen/matchMakingScreen");})),
              const Spacer(),
            ]));
      }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

      //todo: controlla che to main screen parta solo quando serve;
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        /*if(!routerCalled) {
          gameModel.matchJoinedYet().then((response) {
            setState(() {
              modelResponse = response;
            });
          });
          if (modelResponse != null && modelResponse!) {
            routerCalled = true;
            toMainScreen(gameModel);
          }
        }*/
      });

      if(modelResponse != null && !modelResponse!){

        return SafeArea(child:
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint)
            {
            if(constraint.maxWidth != screenWidth && constraint.maxHeight!=screenHeight){
              newDimensions(constraint.maxHeight, constraint.maxWidth);
            }

           if (screenHeight > screenWidth){
            return Material( color: Colors.white,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const Spacer(),
                        lottieLoaded ? Expanded(flex: 2, child: Center(child:
                        AnimatedGradient("Edilclima", screenHeight * 0.10, 5200, 'Inspiration', true)))
                            : const Spacer(flex: 2),
                        const Spacer(),
                        lottieLoaded ? dynamicWaitingContent(gameModel) : const Spacer(flex: 6),
                        Expanded(flex : 7, child: Lottie.asset('assets/animations/WaitingScreenHome.json',
                            onLoaded: (_){
                              setState((){
                                lottieLoaded = true;
                              });
                            })),
                        const Spacer(),
                      ],
                    ));
          }
          else{
            return Material(color: Colors.white, child:
            Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: Lottie.asset('assets/animations/WaitingScreenHome.json',
                      onLoaded: (_){
                        setState((){
                          lottieLoaded = true;
                        });
                      })),
                  Expanded(child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max, children: [
                        const Spacer(),
                        Expanded(flex: 4, child:  Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              const Spacer(),
                              lottieLoaded ? dynamicWaitingContent(gameModel) : const Spacer(),
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
          return SafeArea(child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
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
    return Future<void>.delayed(const Duration(milliseconds: 50), () {
      gameModel.listenToLevelChange();
      context.go("/initialScreen/cameraScreen/splashScreen");});
  }
}