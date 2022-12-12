
import 'dart:core';

class CardData {

  String code;
  int money;
  int energy;
  int smog;
  int comfort;
  researchSet research;
  List<String>? resCard;
  int level;



  CardData(this.code, this.money, this.energy, this.smog, this.comfort, this.research, this.resCard, this.level);

}

enum researchSet{
  None, Needed, Develop
}