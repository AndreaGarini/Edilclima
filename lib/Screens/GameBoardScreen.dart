
import 'package:edilclima_app/Components/gameBoardScreen/GameBoardInfoCircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameBoardScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => GameBoardScreenState();

}

class GameBoardScreenState extends State<GameBoardScreen> {
  @override
  Widget build(BuildContext context) {

    return Material(child:
      Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Spacer(),
        GameBoardInfoCircle(),
          const Spacer()
        ],)
    );
  }
}