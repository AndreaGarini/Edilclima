
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/CardSelectionScreen.dart';

class UndetailedCardLayout extends StatefulWidget {

  double width;
  double height;
  int indexZ;
  String cardNum;
  UndetailedCardLayout(this.width, this.height, this.indexZ, this.cardNum);

  @override
  State<StatefulWidget> createState() => UndetailedCardLayoutState();

}

class UndetailedCardLayoutState extends State<UndetailedCardLayout> {

  @override
  Widget build(BuildContext context) {
      return SizedBox(
          width: parentWidth * 0.4,
          height: parentHeight * 0.4,
          child: Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
              elevation: 10,
              child:
              Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.cardNum + widget.indexZ.toString())
                ],)));
  }

}