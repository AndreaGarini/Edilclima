
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/material.dart';

class DetailedCardText extends StatelessWidget{

  String cardCode;
  DetailedCardText(this.cardCode);

  Map<String, List<DetailedCardTextFragment>> cardTextMap = {

  };

  @override
  Widget build(BuildContext context) {
     return RichText(text: TextSpan(
       children: cardTextMap[cardCode]!.map((e) =>
           TextSpan(text: e.text, style: e.defineStyle())).toList()
     ));
  }

}

class DetailedCardTextFragment{
      String text;
      cardTextType type;

      DetailedCardTextFragment(this.text, this.type);

      TextStyle defineStyle(){
        switch(type){
          case cardTextType.Nerf:
            return TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: screenHeight * 0.02);
          case cardTextType.Up:
            return TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: screenHeight * 0.02);
          case cardTextType.None:
            return TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: screenHeight * 0.02);
        }
      }
}

enum cardTextType{
  Nerf, Up, None
}