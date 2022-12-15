
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';

class DetailedCardLayout extends StatelessWidget{

  CardData? cardData;
  DetailedCardLayout(this.cardData);

  String bodyText = "Lorem ipsum dolor sit amet, consectetur adipisci elit, sed do eiusmod tempor incidunt ut labore et dolore magna aliqua. "
      "Ut enim ad minim veniam, quis nostrum exercitationem ullamco laboriosam, nisi ut aliquid ex ea "
      "commodi consequatur. Duis aute irure reprehenderit in voluptate velit esse cillum dolore eu"
      "fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  @override
  Widget build(BuildContext context) {
    if(cardData!=null){
      return SizedBox(
          width: screenWidth * 0.8,
          height: screenHeight * 0.6,
        child: Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: Center(child: Text(cardData!.code, style: const TextStyle(color: Colors.black)))),
                const Expanded(flex: 3, child: Icon(Icons.access_alarm)),
                Expanded(flex: 1, child: Center(child: Text("cost: ${cardData!.money}", style: const TextStyle(color: Colors.black),))),
                Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: Center(child: Text("smog: ${cardData!.smog}", style: const TextStyle(color: Colors.black),))),
                  Expanded(flex: 1, child: Center(child: Text("energy: ${cardData!.energy}", style: const TextStyle(color: Colors.black),))),
                  Expanded(flex: 1, child: Center(child: Text("comfort: ${cardData!.comfort}", style: const TextStyle(color: Colors.black),))),
                ],)),
                Expanded(flex: 3, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Spacer(),
                    Expanded(flex: 2, child: Text(bodyText, style: const TextStyle(color: Colors.black))),
                    const Spacer()
                  ],)),
                const Spacer()
              ],
            )
        ),
      );
    }
    else{
      return SizedBox( width: screenWidth * 0.8,
          height: screenHeight * 0.6,
          child: Card(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
          elevation: 10,
          child: const Center(child: Text("no card", style: TextStyle(color: Colors.black)))));
    }
  }




}