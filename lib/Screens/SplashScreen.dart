

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';

class SplashScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child){
      return const Text("splash screen");
    });
    //todo: crea lo splash screen e usalo per chiamare player ready to play
  }

}