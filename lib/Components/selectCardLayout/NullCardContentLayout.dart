
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/GradientText.dart';

class NullCardContentlayout extends StatelessWidget{

  bool angleZero;
  NullCardContentlayout(this.angleZero);

  @override
  Widget build(BuildContext context) {

    if(angleZero){
      return
          Card(
              color: backgroundGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.02)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Expanded(flex: 1, child: Center(child: GradientText("No card",
                        [darkBluePalette, lightBluePalette, lightOrangePalette],
                        screenWidth * 0.12))),
                    const Spacer(),
                  ])
          );
    }
    else{
      return
          Card(
              color: backgroundGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.02)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Expanded(flex: 1, child: Center(child: GradientText("No card",
                        [darkBluePalette, lightBluePalette, lightOrangePalette],
                        screenWidth * 0.12))),
                    const Spacer(),
                  ])
          );
    }
  }

}