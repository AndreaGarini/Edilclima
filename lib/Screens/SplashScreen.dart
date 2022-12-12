

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';

class SplashScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
   return Consumer<GameModel>(builder: (context, gameModel, child) {

     //todo: fai un test senza connessione, per vedere se almeno non si rompe anche senza dati
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        updateData(gameModel);
      });

      if (gameModel.playerLevelCounter >0 && gameModel.playerLevelStatus != null) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          context.go("/cardSelectionScreen");
        });
      }

      return const Text("splash screen");
      //todo: crea lo splash screen e usalo per chiamare player ready to play
    });
  }

  Future<void> updateData(GameModel gm) async{
    return Future<void>.delayed(const Duration(milliseconds: 0), () {gm.playerReadyToPlay();});
  }
}