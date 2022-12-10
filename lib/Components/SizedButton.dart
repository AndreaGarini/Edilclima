

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizedButton extends StatelessWidget {

  double width;
  String buttonText;
  void Function () onClick;
  SizedButton(this.width, this.buttonText, this.onClick);

  @override
  Widget build(BuildContext context) {
    double textSize = width * 0.1;

   return ElevatedButton(onPressed: onClick,
     style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size.fromWidth(width))),
      child: Text(buttonText, style: TextStyle(fontSize: textSize)));

  }
}