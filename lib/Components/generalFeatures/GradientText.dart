

import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget{

  String text;
  List<Color> colorList = List.generate(3, (index) => darkBluePalette);
  double fontSize;
  GradientText(this.text, this.colorList, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(shaderCallback: (rect) {
      return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.3,0.6, 0.9],
          colors: colorList).createShader(rect);
    },
      child: Text(text, style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Inspiration',
          fontWeight: FontWeight.bold, color: Colors.white)));
  }

}