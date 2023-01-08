
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardInfoScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Stack(alignment: Alignment.topRight,
    children: [
        Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Spacer(),
                Expanded(flex: 8, child: DetailedCardLayout.fromHeight(onFocusCard, screenHeight * 0.7)),
                const Spacer()
              ])),
        ]),
     Padding(padding: EdgeInsets.only(
       top: screenWidth * 0.03,
       right: screenWidth * 0.03),
       child: Container(width: screenWidth * 0.2, height: screenWidth * 0.2,
         decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.2)),
             color: darkBluePalette),
       )),
      Padding(padding: EdgeInsets.only(
          top: screenWidth * 0.03,
          right: screenWidth * 0.03),
          child: InkWell(
          onTap: (){
          context.go("/cardSelectionScreen");
          },
          child:
          SizedBox(width: screenWidth * 0.2, height: screenWidth * 0.2,
                        child: Icon(Icons.cancel_outlined, size: screenWidth * 0.15, color: Colors.white),
                ))
      )]);
  }


}