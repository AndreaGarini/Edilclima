
import 'dart:async';
import 'dart:ffi';

import 'package:edilclima_app/Components/generalFeatures/TutorialComponents.dart';
import 'package:edilclima_app/GameLogic.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'DataClasses/CardData.dart';
import 'DataClasses/DialogData.dart';
import 'DataClasses/Pair.dart';
import 'DataClasses/TeamInfo.dart';

class GameModel extends ChangeNotifier{

  int playerCounter = 0;
  GameLogic gameLogic = GameLogic();
  int count = 1; //todo: variabile per dare un nome in test ai players, da sostituire con i vari uid

  DatabaseReference db = FirebaseDatabase.instance.ref();
  int teamsNum = 0;
  List<String> teamsNames = [];

  bool startMatch = false;
  String masterLevelStatus = "preparing";
  bool ongoingLevel = false;
  int? levelTimerCountdown;

  Map <String, Map<String, String>?> playedCardsPerTeam = {"team1" : {}, "team2" : {}, "team3" : {}, "team4" : {}};
  Map<String, TeamInfo?> teamStats = {};
  Map<String, String> ableToPlayPerTeam = {"team1" : "", "team2" : "", "team3" : "", "team4" : "" };


  //variabili lato player
  List<CardData> playerCards = [];
  String team = "null";
  int playerLevelCounter = 0;
  String? playerLevelStatus;
  int? playerTimerCountdown;
  Timer? playerTimer;
  var push = Pair(pushResult.CardDown, null);
  Future? pushCoroutine;
  DialogData? showDialog;
  bool tutorialOngoing = false;

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
    }}).then((_) {setPlayerCounter();})
    .catchError((error){/*do something*/});
  }

  void setPlayerCounter(){
    db.child("matches").child("test").child("players").onValue.listen((event) {
      print("player counter called: ${playerCounter}");
      playerCounter = event.snapshot.children.length;
      notifyListeners();
    });
  }

  void prepareMatch() async{
    var dbPoint = db.child("matches").child("test").child("players");

    await dbPoint.get().then((value) {
      switch(value.children.length){
        case 1 : {
          teamsNum = 1;
          teamsNames = ["team1"];
        }
        break;
        case 2 : {
          teamsNum = 2;
          teamsNames = ["team1", "team2"];
        }
        break;
        case 3 : {
          teamsNum = 3;
          teamsNames = ["team1", "team2", "team3"];
        }
        break;
        default:  {
          teamsNum = 4;
          teamsNames = ["team1", "team2", "team3", "team4"];
        }
        break;
      }
    });

    await dbPoint.get().then((value) =>
        db.child("matches").child("test").child("players").set(
            gameLogic.selectTeamForPlayers(value)
        )).
    then((_) { db.child("matches").child("test").child("teams").set(gameLogic.createTeamsOnDb());}).
    then((_) => { giveCardsToPlayers(gameLogic.nextLevel())});
  }

  void giveCardsToPlayers(int level) async{
    Map<String, Map<String, bool>> cardsPerPlayerMap = gameLogic.CardsToPLayers(level);

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

  void changePushValue(Pair newPush){
    push = newPush;
    pushCoroutine!=null ? pushCoroutine!.ignore() : (){};
    if(newPush.first()!=pushResult.CardDown){
      pushCoroutine = Future<void>.delayed(const Duration(seconds: 2),
              () {push = Pair(pushResult.CardDown, null); notifyListeners();})
          .whenComplete(() => pushCoroutine = null);
    }
    notifyListeners();
  }

  void setDialogData(DialogData? data){
    showDialog = data;
    notifyListeners();
  }

  void endTutorialAndNotify(){
    tutorialOngoing = false;
    notifyListeners();
  }

  void stopPlayerTimer(){
    playerTimerCountdown = null;
    playerTimer!.cancel();
    playerTimer = null;
    notifyListeners();
  }


  void setStartingCardsPerLevel(int level) async{
    String noCard = "void";
    Map<String, String> startingCardMap = Map.fromIterable(gameLogic.zoneMap[level]!.startingList,
                                          key: (element) => (element=="no Card") ? noCard :  gameLogic.months[gameLogic.zoneMap[level]!.startingList.indexOf(element)],
                                          value: (element) => element);
    for (final team in gameLogic.playersPerTeam.keys){
      await db.child("matches").child("test").child("teams").child(team)
          .child("playedCards").set(startingCardMap);
    }
  }

  addPlayedCardsListener() {
    Map<String, Map<String, String>?> avatarMap = {};

    //todo: controlla che giocando una carta o perdendola il numero di moves salga di uno
    for (final team in ["team1", "team2", "team3", "team4"]){
      db.child("matches").child("test").child("teams").child(team).child("playedCards").onValue.listen((event) {
        if(event.snapshot.children.length - 1 != playedCardsPerTeam[team]!.length){
          //questo if serve per fare in modo che i dati cambino solo se una carta ?? stata presa o posizionata,
          //e non solo se il listener ?? stato triggerato
          Map<String, String> map = {};
          for (final playedCard in event.snapshot.children){
            if (!(playedCard.value.toString() == "no Card")) map.putIfAbsent(playedCard.key.toString(), () => playedCard.value.toString());
          }
          newStatsPerTeam(team, map);
          avatarMap = playedCardsPerTeam;
          avatarMap.remove(team);
          avatarMap.putIfAbsent(team, () => map);
          playedCardsPerTeam = avatarMap;
          notifyListeners();
        }
      });
    }
  }

  void newStatsPerTeam(String team, Map<String, String> map){
    Map<String, TeamInfo?> avatarMap = teamStats;
    int moves = (avatarMap[team]!=null && avatarMap[team]!.nullCheck()) ? avatarMap[team]!.moves! : 0;
    int lv = (playerLevelCounter == 0) ? gameLogic.masterLevelCounter : playerLevelCounter;
    avatarMap.remove(team);
    avatarMap.putIfAbsent(team, () => gameLogic.evaluatePoints(lv, map, moves +1));
    teamStats = avatarMap;
    notifyListeners();
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
    notifyListeners();
  }

  void startLevel() async {
    onTick(){
      levelTimerCountdown = levelTimerCountdown! - 1;
      notifyListeners();
    }

    onFinish() async {
      ongoingLevel = false;
      masterLevelStatus = "preparing";
      levelTimerCountdown = null;
      gameLogic.masterLevelCounter = gameLogic.nextLevel();
      Map<String , Object> levelValue = {"status" : masterLevelStatus, "count" : gameLogic.masterLevelCounter};
      await db.child("matches").child("test").child("level").set(levelValue);
      notifyListeners();
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

  //todo: listen to level change fa partire la partita anche se il player non si ?? mai connesso

  void listenToLevelChange() {
    db.child("matches").child("test").child("level").onValue.listen((event) {
      if(!(event.snapshot.value == "")){
        //questo if controlla che il value del level sia cambiato effettivamente (e non che l'ondatachange sia stato chiamato e basta)
        //e che lo stato sia preparing

        if(playerLevelCounter != event.snapshot.child("count").value as int){
          playerLevelCounter = event.snapshot.child("count").value as int;
        }

        if(playerLevelStatus != event.snapshot.child("status").value as String){

          playerLevelStatus = event.snapshot.child("status").value as String;

          switch(event.snapshot.child("status").value.toString()){
            case "preparing" : {
              // la finestra di splash fa partire il tutorial
              splash = true;
            }
            break;
            case"play" : {
              setDialogData(DialogData("level $playerLevelCounter", null, false, null, null));
            }
            break;
          }
      }

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
      List<CardData> list = [];
      for (final card in event.snapshot.children) {
        CardData? crd = gameLogic.findCard(card.key!);
        if (crd != null) {
          list.add(crd);
        }
      }
      playerCards = list;
      notifyListeners();
    });
  }

  void notifyAbleToPlayChange() async{
    // da chiamare quando si passa alla schermata di gioco
    // (per arrivare alla schermata di gioco devi popolare il resto del db con il master,
    // quindi popola i failure)
    //todo: togli 1 e metti il player uid
    await db.child("matches").child("test").child("players")
        .child("1").child("team").get().
    then((value) {
      team = value.value as String;
      notifyCallback1(value);
    });

  }

  void notifyCallback1(DataSnapshot value) async{
    String team = value.value.toString();
    db.child("matches").child("test").child("teams").child(team).child("ableToPlay").onValue.listen((event) {

      if (event.snapshot.value.toString()=="1" && playerLevelCounter != 0
          && playerLevelStatus == "play" && playerTimer==null){
        playerTimerCountdown = 62;
        //?? l'infoRow a creare il timer e passarlo al gameModel
        notifyListeners();
    }});
  }

  void createPlayerTimer(Timer timer){
    playerTimer = timer;
  }

  void playerTimerOnTick(){
    if (playerTimerCountdown!=null){
      //se non ?? ancora finito il tempo di livello eseguo
      playerTimerCountdown = playerTimerCountdown! - 1;
      notifyListeners();
    }
  }

  void playerTimerOnFinish(){
    //se il timer finisce mentre c'?? ancora tempo nel livello eseguo qui le operazioni di fine turno
    // (altrimenti in listenToLevelChange)
    if (playerTimer!=null){
      playerTimer!.cancel();
      playerTimer = null;
      playerTimerCountdown = null;
      notifyListeners();
      setTimeOutTrue();
    }
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
      playedCards.map((e) => gameLogic.CardsMap[e]!.money).forEach((element) {
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