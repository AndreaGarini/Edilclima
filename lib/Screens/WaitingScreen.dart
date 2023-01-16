
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

  @override
  void initState() {
    super.initState();
    lottieLoaded = false;
    routerCalled = false;
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
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints)
        {
            if(constraints.maxWidth != screenWidth && constraints.maxHeight!=screenHeight){
              newDimensions(constraints.maxHeight, constraints.maxWidth);
            }

          if (screenHeight > screenWidth){
            return Material(color: Colors.white, child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Spacer(),
                lottieLoaded ? Expanded(flex: 2, child: Center(child:
                AnimatedGradient("Edilclima", screenHeight * 0.10, 5200, 'Inspiration', true)))
                    : const Spacer(flex: 2),
                const Spacer(),
                Expanded(flex : 7, child: Lottie.asset('assets/animations/WaitingScreenHome.json',
                    onLoaded: (_){
                      setState((){
                        lottieLoaded = true;
                      });
                    })),
                lottieLoaded ? Expanded(flex: 1, child: Center(child:
                Text("Chi sei?", style: TextStyle(color: darkBluePalette,
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto',),
                    textAlign: TextAlign.justify)))
                    : const Spacer(),
                lottieLoaded ? Divider(indent: screenWidth * 0.3, endIndent: screenWidth * 0.3, color: darkBluePalette, thickness: 2,)
                    : const Spacer(),
                const Spacer(),
                lottieLoaded ? Expanded(flex: 1, child:
                SizedButton(screenWidth * 0.6, "Il master", () {context.push("/initialScreen/matchMakingScreen");}))
                    : const Spacer(),
                const Spacer(),
                lottieLoaded ? Expanded(flex: 1, child:
                SizedButton(screenWidth * 0.6, "Un giocatore", () {context.push("/initialScreen/cameraScreen");}))
                    : const Spacer(),
                const Spacer(),
              ],
            ),);
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
                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const Spacer(),
                        lottieLoaded ? Expanded(flex: 2, child: Center(child:
                        AnimatedGradient("Edilclima", screenHeight * 0.15, 5200, 'Inspiration', true)))
                            : const Spacer(flex: 2),
                        const Spacer(),
                        lottieLoaded ? Expanded(flex: 1, child: Center(child:
                        Text("Chi sei?", style: TextStyle(color: darkBluePalette,
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',),
                            textAlign: TextAlign.justify)))
                            : const Spacer(),
                        lottieLoaded ? Divider(indent: screenWidth * 0.1, endIndent: screenWidth * 0.1, color: darkBluePalette, thickness: 2)
                            : const Spacer(),
                        const Spacer(),
                        lottieLoaded ? Expanded(flex: 1, child:
                        SizedButton(screenWidth * 0.3, "Il master", () {context.push("/initialScreen/matchMakingScreen");}))
                            : const Spacer(),
                        const Spacer(),
                        lottieLoaded ? Expanded(flex: 1, child:
                        SizedButton(screenWidth * 0.3, "Un giocatore", () {context.push("/initialScreen/cameraScreen");}))
                            : const Spacer(),
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