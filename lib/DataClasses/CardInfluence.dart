
class CardInfluence{

  bool multiInfluence; // se true la carta ottiene un bonus se una qualsiasi carta di un certo tipo è stata giocata
  int? multiObjThreshold; // se multiInfluence è true indica il numero di carte di quel tipo per ottenere il bonus
  String resNeeded; //lista di carte che danno il bonus; se multiInfluence è true c'è solo un prefisso, es. imp
  Map<String, double> inCoeff; //mappa di coefficienti di mul per A, E e C

  CardInfluence(this.resNeeded, this.inCoeff, this.multiInfluence, this.multiObjThreshold);
}