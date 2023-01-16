
import 'package:edilclima_app/Components/gameBoardScreen/GameBoard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GameBoardChartBar.dart';

class GameBoardCard extends StatefulWidget{

  String team;
  double usableHeight;
  GameBoardCard(this.team, this.usableHeight);

  @override
  State<StatefulWidget> createState() => GameBoardCardState();
}

class GameBoardCardState extends State<GameBoardCard> {

  @override
  Widget build(BuildContext context) {
    return  Card(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)),
        elevation: 10,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Center(child: Text(widget.team),)),
            Expanded(flex : 4, child: Stack(alignment: Alignment.center,
              children: [
              Container(color: Colors.transparent, height: widget.usableHeight * 0.57, width: widget.usableHeight * 0.57,
                        child: GameBoardChartBar("smog", widget.team, widget.usableHeight),),
                Container(color: Colors.transparent, height: widget.usableHeight * 0.45, width: widget.usableHeight * 0.45,
                  child: GameBoardChartBar("energy", widget.team, widget.usableHeight),),
                Container(color: Colors.transparent, height: widget.usableHeight * 0.33, width: widget.usableHeight * 0.33,
                  child: GameBoardChartBar("comfort", widget.team, widget.usableHeight),)
            ],)),
            //qui la zona per le carte giocate
            const Expanded(flex: 2, child: Text(""))
          ]));
  }

}