
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';

import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/StylizedText.dart';

class HorizontalStatsCard extends StatefulWidget{

  String dataType;
  int dataValue;
  HorizontalStatsCard(this.dataType, this.dataValue);

  @override
  State<StatefulWidget> createState() => HorizontalStatsCardState();



}

class HorizontalStatsCardState extends State<HorizontalStatsCard>
 with SingleTickerProviderStateMixin{

  late Widget icon;
  late AnimationController controller;
  late double elevation;

  @override
  void initState() {
    super.initState();

    elevation = 0;
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
        ..forward(from: 0)..addListener(() {
          setState(() {

          });
      })..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          setState(() {
            elevation = 3;
          });
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  @override
  Widget build(BuildContext context) {

    print("controller value: ${controller.value}");
    int alphaValue = (255 * controller.value).toInt();

    switch(widget.dataType){
      case "smog" : {
        icon = Icon(Elusive.leaf, color: lightOrangePalette.withAlpha(alphaValue));
      }
      break;
      case "energy" : {
        icon = Icon(Elusive.lightbulb, color: darkBluePalette.withAlpha(alphaValue));
      }
      break;
      case "comfort" : {
        icon = Icon(Icons.home, color: lightBluePalette.withAlpha(alphaValue));
      }
      break;
      case "money" : {
        icon = Icon(ModernPictograms.dollar,
          color: darkOrangePalette.withAlpha(alphaValue),
          size: screenWidth * 0.05,);
      }
    }

    return Card(color: Colors.white.withAlpha(alphaValue),
        shadowColor: lightOrangePalette.withAlpha(alphaValue),
        elevation: elevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.02)),
        child:
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                width: screenWidth * 0.03,
              ),
              Container(
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.1)),
                      color: backgroundGreen,
                      boxShadow: [ BoxShadow(
                        color: lightBluePalette.withOpacity(0.5).withAlpha(alphaValue),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 0), // changes position of shadow
                      )]),
                  child: icon),
              StylizedText(darkBluePalette.withAlpha(alphaValue), " : ", null, FontWeight.normal),
              StylizedText(darkBluePalette.withAlpha(alphaValue), "${widget.dataValue}", null, FontWeight.bold)
            ]));
  }
}