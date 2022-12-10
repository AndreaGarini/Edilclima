
import 'dart:async';
import 'dart:ffi';

import 'package:edilclima_app/GameLogic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'DataClasses/Card.dart';
import 'DataClasses/Pair.dart';
import 'DataClasses/TeamInfo.dart';

class GameModel extends ChangeNotifier{

  int playerCounter = 0;
  GameLogic gameLogic = GameLogic();
  int count = 0; //todo: variabile per dare un nome in test ai players, da sostituire con i vari uid

  DatabaseReference db = FirebaseDatabase.instance.ref();

  bool startMatch = false;
  String masterLevelStatus = "preparing";
  bool ongoingLevel = false;
  int? levelTimerCountdown;

  Map <String, Map<String, String>?> playedCardsPerTeam = {};
  Map<String, TeamInfo?> teamStats = {};
  Map<String, String> ableToPlayPerTeam = {"team1" : "", "team2" : "", "team3" : "", "team4" : "" };


  //variabili lato player
  List<Card> playerCards = [];
  String team = "null";
  int playerLevelCounter = 0;
  String? playerLevelStatus;
  int? playerTimerCountdown;
  Timer? playerTimer;
  //var pushResult = Pair(pushResult.CardDown, null);
  //var showDialog : MutableLiveData<dialogData?> = MutableLiveData(null)

  //variabili sia master che player per schermate di splash e error
  bool splash = false;
  bool error = false;

  void createNewMatch() async {
    await db.set({
      "matches" : {
      "test" : {
        "level" : "",
        "players" : "",
        "teams" : ""
      }
    }}).then((_) {print("create new match finished with success");
    setPlayerCounter();})
    .catchError((error){/*do smothing*/});
  }

  void setPlayerCounter(){
    db.child("test").child("players").onValue.listen((event) {
      playerCounter = event.snapshot.children.length;
      notifyListeners();
    });
  }

  void prepareMatch() async{
    var dbPoint = db.child("matches").child("test").child("players");

    await dbPoint.get().then((value) =>
        db.child("matches").child("test").child("players").set(
            gameLogic.selectTeamForPlayers(value)
        )).
    then((_) {print("create teams on db"); db.child("matches").child("test").child("teams").set(gameLogic.createTeamsOnDb());}).
    then((_) => { giveCardsToPlayers(gameLogic.nextLevel())});
  }

  void giveCardsToPlayers(int level) async{
    Map<String, Map<String, bool>> cardsPerPlayerMap = gameLogic.cardsToPLayers(level);

    await db.child("matches").child("test").child("players").get().then((value) =>{
      for (final player in value.children){
        db.child("matches").child("test").child("players").child(player.key!)
            .child("ownedCards").set(cardsPerPlayerMap[player.key])
      }
    }).
    then((_) => setStartingCardsPerLevel(level)).
    then((_) =>  addPlayedCardsListener()).
    then((_) => giveCardsCallback());
  }

  void giveCardsCallback() {
    startMatch = true;
    notifyListeners();
  }


  void setStartingCardsPerLevel(int level) async{
    String noCard = "void";
    Map<String, String> startingCardMap = Map.fromIterable(gameLogic.zoneMap[level]!.startingList,
                                          key: (element) => (element=="no card") ? noCard :  gameLogic.months[gameLogic.zoneMap[level]!.startingList.indexOf(element)],
                                          value: (element) => element);
    for (final team in gameLogic.playersPerTeam.keys){
      await db.child("matches").child("test").child("teams").child(team)
          .child("playedCards").set(startingCardMap);
    }
  }

  addPlayedCardsListener() {
    Map<String, Map<String, String>?> avatarMap = {};

    for (final team in ["team1", "team2", "team3", "team4"]){
      db.child("matches").child("test").child("teams").child(team).child("playedCards").onValue.listen((event) {
        Map<String, String> map = {};
        for (final playedCard in event.snapshot.children){
          if (!(playedCard.value.toString() == "no card")) map.putIfAbsent(playedCard.key.toString(), () => playedCard.value.toString());
        }
        newStatsPerTeam(team, map);
        avatarMap = playedCardsPerTeam;
        avatarMap.remove(team);
        avatarMap.putIfAbsent(team, () => map);
        playedCardsPerTeam = avatarMap;
      });
    }
  }

  void newStatsPerTeam(String team, Map<String, String> map){
    Map<String, TeamInfo?> avatarMap = teamStats;
    int moves = (avatarMap[team]!=null && avatarMap[team]!.nullCheck()) ? avatarMap[team]!.moves! : 0;
    int lv = (playerLevelCounter as int == 0) ? gameLogic.masterLevelCounter : playerLevelCounter as int;
    avatarMap.remove(team);
    avatarMap.putIfAbsent(team, () => gameLogic.evaluatePoints(lv, map, moves +1));
    teamStats = avatarMap;
  }

  void addTeamTimeOutListener(){
    for (final team in ["team1", "team2", "team3", "team4"]){
      db.child("matches").child("test").child("teams").child(team).child("ableToPlay").onValue.listen((event) {
        if(event.snapshot.value.toString() == ""){
          String newPlayer = gameLogic.findNextPlayer(team, ableToPlayPerTeam[team]!);
          ableToPlayPerTeam.update(team, (_) => newPlayer);
          setPlayerAbleToPlay(newPlayer, team);
        }
      });
    }
  }

  void setPlayerAbleToPlay(String newPlayer, String team) async{
    await db.child("matches").child("test").child("teams").child(team)
        .child("ableToPlay").set(newPlayer);
  }

  void prepareLevel(int level) async{
    if(gameLogic.masterLevelCounter == 1){
      Map<String, Object> levelValue = {"status" : masterLevelStatus, "count" : level};
      await db.child("matches").child("test").child("level").set(levelValue).
    then((_) => masterLevelStatus = "play");
    }
    else {
      //todo: controlla che se parte il secondo livello non esploda tutto (si dovrebbe anche bloccare il timer del player alla fine del timer di livello)
      masterLevelStatus = "play";
      giveCardsToPlayers(level);
      setStartingCardsPerLevel(level);
    }
  }

  void startLevel() async {
    onTick(){
      levelTimerCountdown = levelTimerCountdown! - 1;
    }

    onFinish() async {
      ongoingLevel = false;
      masterLevelStatus = "preparing";
      levelTimerCountdown = null;
      gameLogic.masterLevelCounter = gameLogic.nextLevel();
      Map<String , Object> levelValue = {"status" : masterLevelStatus, "count" : gameLogic.masterLevelCounter};
      await db.child("matches").child("test").child("level").set(levelValue);
    }

    await  db.child("matches").child("test").child("level").child("status").set("play").
    then((_) => {startLevelCallback1(onTick, onFinish)});

  }

  void startLevelCallback1(Function() onTick, Function() onFinish){
    addTeamTimeOutListener();
    ongoingLevel = true;
    levelTimerCountdown = 420;
    gameLogic.setLevelTimer(onTick, onFinish);
  }

  //logica lato player

  //todo : ovunque ci sia la chiave dell'utente (ad es. 1) devi inserire il suo uid

  void joinMatch() async {

    await db.child("matches").child("test").child("players")
        .child(count.toString()).set("").then((_) => count++);
  }

  //todo: listen to level change fa partire la partita anche se il player non si è mai connesso

  void listenToLevelChange() {
    db.child("matches").child("test").child("level").onValue.listen((event) {
      if(!(event.snapshot.value == "")){
        //questo if controlla che il value del level sia cambiato effettivamente (e non che l'ondata change sia stato chiamato e basta)
        //e che lo stato sia preparing

        if(playerLevelCounter != event.snapshot.child("count").value as int &&
            playerLevelStatus != event.snapshot.child("status").value as String &&
            event.snapshot.child("status").value.toString() == "preparing"){
      splash = true;
      }
        playerLevelCounter = event.snapshot.child("count").value as int;
        playerLevelStatus = event.snapshot.child("status").value as String;

        if (event.snapshot.child("status").value.toString() == "preparing" && playerTimerCountdown != null){

          playerTimer!.cancel();
          playerTimer = null;
          playerTimerCountdown= null;
          setTimeOutTrue();

        }
        notifyListeners();
      }
    });
  }

  //per preparare il giocatore alla partita
  void playerReadyToPlay(){
    bindCardsForPlayer();
    notifyAbleToPlayChange();
    addPlayedCardsListener();
  }

  void bindCardsForPlayer() {
    db.child("matches").child("test").child("players").child("1").child("ownedCards").onValue.listen((event) {
      List<Card> list = [];
      for (final card in event.snapshot.children) {
        Card? crd = gameLogic.findCard(card.key!);
        if (crd != null) {
          list.add(crd);
        }
      }
      playerCards = list;
    });
  }

  void notifyAbleToPlayChange() async{
    // da chiamare quando si passa alla schermata di gioco
    // (per arrivare alla schermata di gioco devi popolare il resto del db con il master,
    // quindi popola i failure)
    //todo: togli 1 e metti il player uid
    await db.child("matches").child("test").child("players")
        .child("1").child("team").get().
    then((value) => {notifyCallback1(value)});

  }

  void notifyCallback1(DataSnapshot value) async{
    String team = value.toString();
    db.child("matches").child("test").child("teams").child(team).child("ableToPlay").onValue.listen((event) {
      if (event.snapshot.value.toString()=="1" && playerLevelCounter != 0 as Long && playerLevelStatus == "play"){
        playerTimerCountdown = 62;
        onTick () {
      if (playerTimerCountdown!=null){
      //se non è ancora finito il tempo di livello eseguo
      playerTimerCountdown = playerTimerCountdown! - 1;
      }
      }
      onFinish () {
      //se il timer finisce mentre c'è ancora tempo nel livello eseguo qui le operazioni di fine turno
      // (altrimenti in listenToLevelChange)
      if (playerTimer!=null){
      playerTimer!.cancel();
      playerTimerCountdown = null;
      setTimeOutTrue();
      }
      }
        playerTimer = gameLogic.setPlayerTimer( (splash) ? 63000 : 62000, 1000, onTick, onFinish);
    }});
  }

  void setTimeOutTrue() async {

    await db.child("matches").child("test").child("teams").child(team)
        .child("ableToPlay").set("");
  }

  void playCardInPos(int pos, String cardCode) async{

    await db.child("matches").child("test").child("teams").child(team)
        .child("playedCards").child(gameLogic.months[pos]).set(cardCode).
    then((value) => {
      db.child("matches").child("test").child("players").child("1")
          .child("ownedCards").child(cardCode).remove()
    });
  }

  void retriveCardInPos(int pos) async{
    String month = gameLogic.months[pos];
    String cardCode = playedCardsPerTeam[team]![month]!;

    db.child("matches").child("test").child("teams").child(team)
        .child("playedCards").child(month).remove().
    then((value) => {
      db.child("matches").child("test").child("players").child("1")
          .child("ownedCards").child(cardCode).set(true)
    });

  }

  int getBudgetSnapshot(List<String>? playedCards){

    int totalCost = 0;
    if(playedCards!=null){
      playedCards.map((e) => gameLogic.cardsMap[e]!.money).forEach((element) {
        totalCost += element;
      });
    }

    if(playedCards!=null && gameLogic.zoneMap[playerLevelCounter]?.budget!=null)
    { return (gameLogic.zoneMap[playerLevelCounter]!.budget - totalCost);}
    else {
      return 0;
    }
  }

}