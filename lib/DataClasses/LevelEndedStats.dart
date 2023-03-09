
class LevelEndedStats{
  int cardsPoints;
  int targetPoints;
  int movesPoints;
  int oldPoints;
  int level;

  LevelEndedStats(this.cardsPoints, this.targetPoints, this.movesPoints,this.oldPoints, this.level);

  int getTotalPoints(){
    return cardsPoints + targetPoints - movesPoints;
  }
}