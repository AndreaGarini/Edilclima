
import 'dart:core';

import 'package:edilclima_app/DataClasses/Pair.dart';

class CardData {

  String code;
  int money;
  int energy;
  int smog;
  int comfort;
  cardType type;
  mulType mul;
  List<Pair> inf;
  int level;


  CardData(this.code,
      this.money,
      this.energy,
      this.smog,
      this.comfort,
      this.type,
      this.mul,
      this.inf,
      this.level);

}

enum cardType{
  Inv, Imp, Oth
}
enum mulType{
  Int, Fac
}
enum influence{
  None, Card
}