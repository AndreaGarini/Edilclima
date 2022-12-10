
class Zone {

  int id;
  int TargetA;
  int TargetE;
  int TargetC;
  int budget;
  int initSmog;
  int initEnergy;
  int initComfort;
  List<String> optimalList;
  List<String> startingList;

  Zone(this.id, this.TargetA, this.TargetE, this.TargetC, this.budget, this.initSmog, this.initEnergy,
      this.initComfort, this.optimalList, this.startingList);



}