
class Zone {

  int id;
  int TargetA;
  int TargetE;
  int TargetC;
  int budget;
  int initSmog;
  int initEnergy;
  int initComfort;
  int mulFactorInt;
  int mulFactorFac;
  List<String> optimalList;
  List<String> startingList;

  Zone(this.id, this.TargetA, this.TargetE, this.TargetC, this.budget, this.initSmog, this.initEnergy,
      this.initComfort, this.mulFactorInt, this.mulFactorFac, this.optimalList, this.startingList);



}