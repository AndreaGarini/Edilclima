
import 'package:edilclima_app/Components/gameBoardScreen/GameBoard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GameBoardChartBar.dart';

class GameBoardCard extends StatelessWidget{

  String team;
  double usableHeight;
  GameBoardCard(this.team, this.usableHeight);

  @override
  Widget build(BuildContext context) {
    return  Card(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)),
        elevation: 10,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Expanded(flex : 4, child: Row(
              mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Expanded(child: Center(child: Text("100%", style: TextStyle(color: Colors.black)))),
                    Spacer(flex: 5),
                    Expanded(child: Center(child: Text("0%", style: TextStyle(color: Colors.black)))),
                    Spacer(flex: 2)
                  ],),),
                const Expanded(child: Center(child: VerticalDivider(color: Colors.black, indent: 0, endIndent: 0, thickness: 5))),
                const Spacer(),
                Expanded(flex: 2, child: GameBoardChartBar(team, "smog", usableHeight * 0.67)),
                Expanded(flex: 2, child: GameBoardChartBar(team, "energy", usableHeight * 0.67)),
                Expanded(flex: 2, child: GameBoardChartBar(team, "comfort", usableHeight * 0.67)),
                const Spacer()
              ],
            )),
            //qui la zona per le carte giocate
            const Expanded(child: Text("ckjh j"))
          ],));
  }
}