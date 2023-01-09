
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Components/gameBoardScreen/GameBoard.dart';

class GameBoardScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => GameBoardScreenState();

}

class GameBoardScreenState extends State<GameBoardScreen> {
  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.white,
        child:
      Stack(alignment: Alignment.center,
      children: [
        GameBoard(),
        //GameBoardInfoCircle(),
      ],)
    );
  }
}