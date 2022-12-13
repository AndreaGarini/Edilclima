

import 'package:edilclima_app/Components/MainScreenContent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabLayout extends StatelessWidget{

  String text;
  TabLayout( this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth/4,
      height: screenHeight,
      child: Center(child: Text(text, style: const TextStyle(color: Colors.black)))
    );
  }

}