
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/CardSelectionScreen.dart';
import '../../Screens/WaitingScreen.dart';

class UndetailedCardLayout extends StatelessWidget {

  CardData? cardData;
  UndetailedCardLayout(this.cardData);

  @override
  Widget build(BuildContext context) {

    if (cardData != null){

      return SizedBox(
          width: screenWidth * 0.45,
          height: screenHeight * 0.35,
          child: Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
              elevation: 10,
              child:
              Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(flex: 1, child: Text(cardData!.code),),
                  const Expanded(flex: 1, child: Icon(Icons.access_alarm)),
                  Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Cost : ${cardData!.money}")],)),
                  Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Comfort : ${cardData!.comfort}")],)),
                  Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Smog : ${cardData!.smog}")],)),
                  Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Energy : ${cardData!.energy}")],)),
                ],)));
    }
    else{
      return SizedBox(
          width: parentWidth * 0.4,
          height: parentHeight * 0.4,
          child: Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
              elevation: 10,
              child:
              Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Expanded(flex : 2, child: Text("no card")),
                ],)));
    }
  }

}