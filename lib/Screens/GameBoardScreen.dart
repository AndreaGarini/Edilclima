
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Components/gameBoardScreen/GameBoard.dart';

class GameBoardScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => GameBoardScreenState();

}

class GameBoardScreenState extends State<GameBoardScreen> {

  //todo: devi fare in modo che si giri la game board anche qui (waiting screen la blocca)
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(child:
        Material(
        color: Colors.white,
        child:
        Stack(alignment: Alignment.center,
          children: [
            GameBoard(),
            //GameBoardInfoCircle(),
          ])
    ));
  }
}