
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Screens/WaitingScreen.dart';

class TabLayout extends StatelessWidget{

  String text;
  TabLayout( this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth/4,
      height: screenHeight,
      child: Center(child: Text(text))
    );
  }

}