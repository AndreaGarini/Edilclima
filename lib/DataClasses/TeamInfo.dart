

class TeamInfo{

  int? budget;
  int? smog;
  int? energy;
  int? comfort;
  int? points;
  int? moves;


  TeamInfo(this.budget, this.smog, this.energy, this.comfort, this.points, this.moves);

  bool nullCheck(){
    return   (smog!=null && energy != null && comfort != null && points != null && moves != null);
  }
}