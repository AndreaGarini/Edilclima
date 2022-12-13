
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/CardSelectionScreen.dart';
import '../MainScreenContent.dart';

class UndetailedCardLayout extends StatefulWidget {

  CardData? cardData;
  UndetailedCardLayout( this.cardData);

  @override
  State<StatefulWidget> createState() => UndetailedCardLayoutState();

}

class UndetailedCardLayoutState extends State<UndetailedCardLayout> {

  @override
  Widget build(BuildContext context) {

      if (widget.cardData != null){
        return SizedBox(
            width: screenWidth * 0.45,
            height: screenHeight * 0.35,
            child: Card(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
                elevation: 10,
                child:
                Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 1, child: Text(widget.cardData!.code),),
                    const Expanded(flex: 1, child: Icon(Icons.access_alarm)),
                    Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Cost : ${widget.cardData!.money}")],)),
                    Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Comfort : ${widget.cardData!.comfort}")],)),
                    Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Smog : ${widget.cardData!.smog}")],)),
                    Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Energy : ${widget.cardData!.energy}")],)),
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