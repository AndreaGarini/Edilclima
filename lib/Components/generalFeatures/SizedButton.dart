

import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizedButton extends StatelessWidget {

  double width;
  String buttonText;
  void Function()? onClick;
  SizedButton(this.width, this.buttonText, this.onClick);

  @override
  Widget build(BuildContext context) {
    double textSize = width * 0.07;
   return ElevatedButton(onPressed: onClick,
     style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size.fromWidth(width)),
     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
         RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(5))
    ),
    backgroundColor: onClick!=null ? MaterialStateProperty.all(lightBluePalette) : MaterialStateProperty.all(backgroundGreen)),
      child: StylizedText(onClick!=null ? Colors.white : darkBluePalette, buttonText, textSize, FontWeight.bold));
  }
}