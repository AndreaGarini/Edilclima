

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
    double textSize = width * 0.09;
   return ElevatedButton(onPressed: onClick,
     style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size.fromWidth(width)),
     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
         RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(18.0))
    ),
    backgroundColor: onClick!=null ? MaterialStateProperty.all(oceanBluePalette) : MaterialStateProperty.all(backgroundGreen)),
      child: StylizedText(onClick!=null ? Colors.white : darkGreenPalette, buttonText, textSize, FontWeight.bold));
  }
}