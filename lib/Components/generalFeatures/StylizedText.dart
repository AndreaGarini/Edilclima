
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StylizedText extends StatelessWidget{

  var textColor = Colors.black;
  String text = "";
  double? fontSize = 0;
  FontWeight fontWeight = FontWeight.normal;

  StylizedText(this.textColor, this.text, this.fontSize, this.fontWeight);

  @override
  Widget build(BuildContext context) {
      return Text(text, style: TextStyle(color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: 'Roboto',),
      textAlign: TextAlign.justify,);
  }

}