
import 'dart:core';

class Card {

  String code;
  int money;
  int energy;
  int smog;
  int comfort;
  researchSet research;
  List<String>? resCard;
  int level;



  Card(this.code, this.money, this.energy, this.smog, this.comfort, this.research, this.resCard, this.level);

}

enum researchSet{
  None, Needed, Develop
}