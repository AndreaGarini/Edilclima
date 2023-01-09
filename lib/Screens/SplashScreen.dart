
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';

class SplashScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => SpashScreenState();
}

class SpashScreenState extends State<SplashScreen> {

  bool pushRoute = false;

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

      //todo: fai un test senza connessione, per vedere se almeno non si rompe anche senza dati
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        updateData(gameModel);
        if (gameModel.playerLevelCounter >0 && gameModel.playerLevelStatus != null) {
          if(!pushRoute){
            pushRoute = true;
            Future.delayed(const Duration(milliseconds: 3000), () {
              gameModel.tutorialOngoing = true;
              context.go('/cardSelectionScreen');
            });
          }
        }
      });

      return Material(color: Colors.white, child: Lottie.asset('assets/animations/SplashScreenHand.json'));
    });
  }

  Future<void> updateData(GameModel gm) async{
    return Future<void>.delayed(const Duration(milliseconds: 0), () {gm.playerReadyToPlay();});
  }
}