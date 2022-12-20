
import 'package:edilclima_app/DataClasses/TeamInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeamCardLayout extends StatelessWidget{

  MapEntry<String, TeamInfo?> teamStat;

  TeamCardLayout(this.teamStat);


  @override
  Widget build(BuildContext context) {
   return  Card(shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(15.0)),
    elevation: 10,
    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(teamStat.key, style: const TextStyle(color: Colors.black),)
        ],)),
      Expanded(flex: 3, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child:  Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Expanded(flex: 2, child: Text("Smog : ${teamStat.value?.smog}", style: const TextStyle(color: Colors.black)))
                ],),),
              Expanded(child:  Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Expanded(flex: 2, child: Text("Energy : ${teamStat.value?.energy}", style: const TextStyle(color: Colors.black)))
                ],),),
              Expanded(child:  Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Expanded(flex: 2, child: Text("Comfort : ${teamStat.value?.comfort}", style: const TextStyle(color: Colors.black)))
                ],))
            ])),
          Expanded(child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Expanded( child: Center(child: Text("Punteggio: ", style: TextStyle(color: Colors.black)))),
              ])),
            Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded( child: Center(child: Text("${teamStat.value?.points}", style: const TextStyle(color: Colors.black))))
              ])),
            const Spacer()
          ],))
        ],)),
      const Spacer()
    ],));
  }


}