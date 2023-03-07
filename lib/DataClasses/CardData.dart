
import 'dart:core';

import 'package:edilclima_app/DataClasses/Pair.dart';

class CardData {

  String code;
  String title;
  int money;
  int energy;
  int smog;
  int comfort;
  cardType type;
  mulType mul;
  List<Pair> inf;
  int level;


  CardData(this.code,
      this.title,
      this.money,
      this.smog,
      this.energy,
      this.comfort,
      this.type,
      this.mul,
      this.inf,
      this.level);
}

enum cardType{
  Build, Lights, Gear, Panels, Window
}
enum mulType{
  Int, Fac
}
enum influence{
  None, Card
}