
import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:edilclima_app/GameLogic.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'DataClasses/CardData.dart';
import 'DataClasses/Context.dart';
import 'DataClasses/DialogData.dart';
import 'DataClasses/Pair.dart';
import 'DataClasses/TeamInfo.dart';

class GameModel extends ChangeNotifier{

  int playerCounter = 0;
  GameLogic gameLogic = GameLogic();
  int count = 1; //todo: variabile per dare un nome in test ai players, da sostituire con i vari uid
  //todo: aggiungi ciò che serve per crare la modalità single player o player<4
  //todo: percorso di rientro automatico anche per il master (e player)
  DatabaseReference db = FirebaseDatabase.instance.ref();
  int teamsNum = 0;
  List<String> teamsNames = [];

  bool startMatch = false;
  String masterLevelStatus = "preparing";
  bool ongoingLevel = false;
  int? levelTimerCountdown;
  String? masterContextCode;
  Function? gameBoardPngCallback;

  Map <String, Map<String, CardData>?> playedCardsPerTeam = {"team1" : {}, "team2" : {}, "team3" : {}, "team4" : {}};
  Map<String, TeamInfo?> teamStats = {};
  Map<String, String> ableToPlayPerTeam = {"team1" : "", "team2" : "", "team3" : "", "team4" : "" };


  //variabili lato player
  List<CardData> playerCards = [];
  List<CardData> drawableCards = [];
  String team = "null";
  int playerLevelCounter = 0;
  String? playerLevelStatus;
  int? playerTimerCountdown;
  String? playerContextCode;
  Timer? playerTimer;
  var push = Pair(pushResult.CardDown, null);
  Future? pushCoroutine;
  DialogData? showDialog;
  bool tutorialOngoing = false;
  bool? tutorialDone;

  //variabili sia master che player per schermate di splash e error
  bool splash = false;
  bool error = false;

  void createNewMatch() async {
    await db.set({
      "matches" : {
      "test" : {
        "masterTutorialDone" : false,
        "level" : "",
        "players" : "",
        "teams" : ""
      }
    }});
  }

  void setPlayerCounter(){
    db.child("matches").child("test").child("players").get().whenComplete(() =>
        db.child("matches").child("test").child("players").onValue.listen((event) {
          if(event.snapshot.children.length!=playerCounter){
            playerCounter = event.snapshot.children.length;
            notifyListeners();
          }
        })
    );
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
    Context context = gameLogic.contextList[Random().nextInt(gameLogic.contextList.length)];
    masterContextCode = context.code;
      await dbPoint.get().then((value) =>
          db.child("matches").child("test").child("players").set(
              gameLogic.selectTeamForPlayers(value)
          )).
      then((_) { db.child("matches").child("test").child("teams").set(gameLogic.createTeamsOnDb());}).
      then((_) {
        giveCardsToPlayers(1);}).
    then((_) => gameLogic.masterLevelCounter = 1);
  }

  void setPlayerTutorial(){
    db.child("matches").child("test").child("players").get().then((value) =>{
    for(final player in value.children){
        db.child("matches").child("test").child("players").child(player.key!)
            .get().then((value) =>{
          if(!value.child("tutorialDone").exists){
            db.child("matches").child("test").child("players")
                .child("1").child("tutorialDone").set(false)
          }})}
        });
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
    then((_) => setDrawableCards(level)).
    then((_) =>  addPlayedCardsListener()).
    then((_) => giveCardsCallback()).
    then((_) => setPlayerTutorial());
  }

  void giveCardsCallback() {
    startMatch = true;
    notifyListeners();
  }

  void setDrawableCards(int level) async{
    //todo: definisci la lista delle drawable cards (non metterci le ricerche)
    //todo: aggiungi un pushResult per quando le drawable sono finite(non metterci le ricerche)
    Map<String, bool> drawableCardsPerLevel = gameLogic.createDrawableCardsMap(level);
    drawableCardsPerLevel.putIfAbsent("void", () => false);

    await db.child("matches").child("test").child("teams").get().then((value) =>{
      for (final team in value.children){
        db.child("matches").child("test").child("teams").child(team.key!)
            .child("drawableCards").set(drawableCardsPerLevel)
      }
      });

  }

  void changePushValue(Pair newPush){
    push = newPush;
    pushCoroutine!=null ? pushCoroutine!.ignore() : (){};
    if(newPush.first()!=pushResult.CardDown){
      pushCoroutine = Future<void>.delayed(const Duration(seconds: 5),
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

  void addPlayedCardsListener() {
    Map<String, Map<String, CardData>?> avatarMap = {};

    //todo: controlla che giocando una carta o perdendola il numero di moves salga di uno
    for (final team in playedCardsPerTeam.keys){
      db.child("matches").child("test").child("teams").child(team).child("playedCards").onValue.listen((event) {
        if(event.snapshot.children.length - 1 != playedCardsPerTeam[team]!.length){
          //questo if serve per fare in modo che i dati cambino solo se una carta è stata presa o posizionata,
          //e non solo se il listener è stato triggerato
          if(gameBoardPngCallback!=null){
            triggerGameBoardCallback(team, event.snapshot);
          }
          Map<String, CardData> map = {};
          for (final playedCard in event.snapshot.children){
            if (playedCard.value.toString() != "no Card")
              {
                String? contextCode = masterContextCode ?? playerContextCode;
                int playerCounter = playerLevelCounter!=0 ? playerLevelCounter : gameLogic.masterLevelCounter;
                map.putIfAbsent(playedCard.key.toString(),
                        () => gameLogic.findCard(playedCard.value.toString(), contextCode!, playerCounter)!);
              }
          }
          newStatsPerTeam(team, map);
          avatarMap = playedCardsPerTeam;
          avatarMap.remove(team);
          avatarMap.putIfAbsent(team, () => gameLogic.obtainPlayedCardsStatsMap(map));
          playedCardsPerTeam = avatarMap;
          notifyListeners();
        }
        else if(event.snapshot.children.length == 1
            && event.snapshot.children.single.key=="void"){
          Map<String, CardData> map = {};
          newStatsPerTeam(team, map);
          avatarMap = playedCardsPerTeam;
          avatarMap.remove(team);
          avatarMap.putIfAbsent(team, () => gameLogic.obtainPlayedCardsStatsMap(map));
          playedCardsPerTeam = avatarMap;
          notifyListeners();
        }
      });
    }
  }

  void triggerGameBoardCallback(String team, DataSnapshot snapshot){

    //todo: controlla che funzioni il trigger del gameboardcallback
    //todo: considera che questa parte anche quando stiamo popolahndo il gameBoardPngStack di partenza

    if(snapshot.children.length > playedCardsPerTeam[team]!.length){
      String newCard = snapshot.children.map((e) => e.value as String).where((element) =>
      !playedCardsPerTeam[team]!.values.map((e) => e.code).contains(element)).single;
      gameBoardPngCallback!(newCard, true, team);
    }
    else if(snapshot.children.length < playedCardsPerTeam[team]!.length){
      String goneCard = playedCardsPerTeam[team]!.values.map((e) => e.code).where((element) => !snapshot.children.map((e) => e.value as String).contains(element)).single;
      gameBoardPngCallback!(goneCard, false, team);
    }

  }

  void newStatsPerTeam(String team, Map<String, CardData?> map){
    Map<String, TeamInfo?> avatarMap = teamStats;
    String? contextCode = masterContextCode ?? playerContextCode;
    int moves = (avatarMap[team]!=null && avatarMap[team]!.nullCheck()) ? avatarMap[team]!.moves! : 0;
    int lv = (playerLevelCounter == 0) ? gameLogic.masterLevelCounter : playerLevelCounter;
    avatarMap.remove(team);
    avatarMap.putIfAbsent(team, () => gameLogic.evaluatePoints(lv, map.isNotEmpty ? map : null, moves +1, contextCode!));
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
      Map<String, Object> levelValue = {"status" : masterLevelStatus, "count" : level, "context" : masterContextCode!};
      await db.child("matches").child("test").child("level").set(levelValue).
    then((_) => masterLevelStatus = "play");
    }
    else {
      String contextCode = gameLogic.contextList[Random().nextInt(gameLogic.contextList.length)].code;
      masterContextCode = contextCode;

      //todo: controlla che se parte il secondo livello non blocchi tutto (si dovrebbe anche bloccare il timer del player alla fine del timer di livello)
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
      String contextCode = gameLogic.contextList[Random().nextInt(gameLogic.contextList.length)].code;
      masterContextCode = contextCode;
      ongoingLevel = false;
      masterLevelStatus = "preparing";
      levelTimerCountdown = null;
      gameLogic.masterLevelCounter = gameLogic.nextLevel();
      Map<String , Object> levelValue = {"status" : masterLevelStatus, "count" : gameLogic.masterLevelCounter, "context" : masterContextCode!};
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

  Future<bool> masterTutorialDoneCheck() async{
    return await db.child("matches").child("test").child("masterTutorialDone").get().then((response) => response.value as bool);
  }

  void setMasterTutorialDone() async{
    db.child("matches").child("test").child("masterTutorialDone").set(true);
  }

  //logica lato player

  //todo : ovunque ci sia la chiave dell'utente (ad es. 1) devi inserire il suo uid

  void joinMatch() async {

    await db.child("matches").child("test").child("players")
        .child(count.toString()).set("").then((_) => count++);
  }

  Future<bool?> matchJoinedYet() async{

    //todo: fai in modo che ci sia il check sull' uid, e che in nessun modo il master
    //todo:  possa venir mandato nel main screen
    return await db.child("matches").child("test").child("players").get()
        .then((value) async {
          if(value.child("1").exists){
            return await db.child("matches").child("test").child("players").child("1").get()
                .then((value) {
              if(value.child("ownedCards").exists
                  && value.child("ownedCards").children.isNotEmpty
                  && value.child("tutorialDone").exists
                  && value.child("team").exists
                  && value.child("team").value != ""){
                  return true;
              }
              else{
                return false;
              }
            });
          }
          else{
            return false;
          }
    });
  }

  //todo: listen to level change fa partire la partita anche se il player non si è mai connesso

  void listenToLevelChange() {
    db.child("matches").child("test").child("level").onValue.listen((event) {
      if(!(event.snapshot.value == "")){
        //questo if controlla che il value del level sia cambiato effettivamente (e non che l'ondatachange sia stato chiamato e basta)
        //e che lo stato sia preparing

        if(playerLevelCounter != event.snapshot.child("count").value as int){
          playerLevelCounter = event.snapshot.child("count").value as int;
          playerContextCode = event.snapshot.child("context").value as String;
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
              setDialogData(DialogData("level $playerLevelCounter", null, true));
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
    addDrawableCardsListener();
  }

  void setTutorialDone(){
    print("game model set tutorial done");
    db.child("matches").child("test").child("players")
        .child("1").child("tutorialDone").set(true);
  }

  Future<void> checkTutorial() async{
    return await db.child("matches").child("test").child("players")
        .child("1").child("tutorialDone").get().then((value) => {
          tutorialDone = value.value as bool
    });
  }

  void bindCardsForPlayer() {
    db.child("matches").child("test").child("players").child("1").child("ownedCards").onValue.listen((event) {
      List<CardData> list = [];
      for (final card in event.snapshot.children) {
        CardData? crd = gameLogic.findCard(card.key!, playerContextCode!, playerLevelCounter);
        if (crd != null) {
          list.add(crd);
        }
      }
      playerCards = list;
      if(forcingDataBinding!=null){
        forcingDataBinding!(this);
      }
      notifyListeners();
    });
  }

  void addDrawableCardsListener(){
    db.child("matches").child("test").child("teams")
        .child(team).child("drawableCards").onValue.listen((event) {
         event.snapshot.children.map((e) => e.key)
             .toList().forEach((element) {
               if(gameLogic.findCard(element!, playerContextCode!, playerLevelCounter)!=null && element!="void"){
                 drawableCards.add(gameLogic.findCard(element, playerContextCode!, playerLevelCounter)!);
               }
         });
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
        //è l'infoRow a creare il timer e passarlo al gameModel
        notifyListeners();
    }});
  }

  void createPlayerTimer(Timer timer){
    if(playerTimer==null){
      playerTimer = timer;
      notifyListeners();
    }
  }

  void playerTimerOnTick(){
    //todo: se qualcosa nella row non funziona sul timer il problema potrebbe essere il notify listener commentato
    if (playerTimerCountdown!=null){
      //se non è ancora finito il tempo di livello eseguo
      playerTimerCountdown = playerTimerCountdown! - 1;
      //notifyListeners();
    }
  }

  void playerTimerOnFinish(){
    //se il timer finisce mentre c'è ancora tempo nel livello eseguo qui le operazioni di fine turno
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

  bool playCardInPosCheck(int pos, String cardCode){
    //todo: aggiungere un feedback se provi a giocare una carta in una pos occupata?
    String month = gameLogic.months[pos];
    if(!playedCardsPerTeam[team]!.keys.contains(month)){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> playCardInPos(int pos, String cardCode) async{
    await db.child("matches").child("test").child("teams").child(team)
        .child("playedCards").child(gameLogic.months[pos]).set(cardCode).
    then((value) async{
       return await db.child("matches").child("test").child("players").child("1")
          .child("ownedCards").child(cardCode).remove();
    });
  }

  void drawCard() async{
    int randomCardPos;
    do{
      randomCardPos = (drawableCards.length * Random().nextDouble()).toInt();
    }while(randomCardPos >= drawableCards.length);

    String cardCode = drawableCards[randomCardPos].code;
    await db.child("matches").child("test").child("teams").child(team)
        .child("drawableCards").child(drawableCards[randomCardPos].code)
        .remove().then((_) =>
    db.child("matches").child("test").child("players").child("1")
        .child("ownedCards").child(cardCode).set(true)
    );
  }

  void retriveCardInPos(int pos) async{
    String month = gameLogic.months[pos];
    String cardCode = playedCardsPerTeam[team]![month]!.code;

    lastDrawnCards.add(cardCode);
    db.child("matches").child("test").child("teams").child(team)
        .child("playedCards").child(month).remove().
    then((value) => {
      db.child("matches").child("test").child("players").child("1")
          .child("ownedCards").child(cardCode).set(true).then((_) {
            int selectedCardPos = Random().nextInt(playerCards.length);
            discardMechCheck().then((value) {
              if(value){
                discardCardMech(selectedCardPos);
              }
            });
      })
    });
  }

  int getBudgetSnapshot(List<String>? playedCards){
    int totalCost = 0;
    if(playedCards!=null){
      playedCards.map((e) => gameLogic.CardsMap[e]!.money).forEach((element) {
        totalCost += element.abs();
      });

      if(gameLogic.zoneMap[playerLevelCounter]?.budget!=null && playerContextCode!=null)
      {
        int budget = (gameLogic.zoneMap[playerLevelCounter]!.budget *
            gameLogic.contextList.where((element) => element.code==playerContextCode)
                .single.startStatsInfluence["B"]!).round();

        return (budget - totalCost);
      }
      else {
        return 0;
      }
    }
    else {
      return 0;
    }
  }

  Future<bool> discardMechCheck() async{
    return await db.child("matches").child("test").child("players").child("1").child("ownedCards")
        .get().then((value) {
          List<String> cardCodesOnDb = value.children.map((e) => e.key as String).toList();
          if(cardCodesOnDb.length==1 && cardCodesOnDb.single=="void"){
           return false;
          }
          else{
            return true;
          }
    });
  }

  Future<CardData> discardCardMech(int selectedCardPos) async{

    String selectedCardCode = playerCards[selectedCardPos].code;

    if(lastDrawnCards.contains(selectedCardCode)){
      lastDrawnCards.remove(selectedCardCode);
    }

    return await db.child("matches").child("test").child("teams").child(team).child("drawableCards")
    .get().then((drawableCards) async{
      return await db.child("matches").child("test").child("teams").child(team).child("drawableCards")
          .child(selectedCardCode).set(true).then((value) async {
           String extractedCardCode;
            do{
              int extractedPos = Random().nextInt(drawableCards.children.length - 1);
              extractedCardCode = drawableCards.children.toList()[extractedPos].key!;
             } while(extractedCardCode=="void");
            lastDrawnCards.add(extractedCardCode);
            print("extracted card in discard mech: ${extractedCardCode}");
            return await db.child("matches").child("test").child("players").child("1").child("ownedCards")
            .child(selectedCardCode).remove().then((value) async{
              return await db.child("matches").child("test").child("players").child("1").child("ownedCards")
                  .child(extractedCardCode).set(true).then((_) =>
              gameLogic.findCard(extractedCardCode, playerContextCode!, playerLevelCounter)!);
            });
      });
    });
  }

}

enum pushResult{
  Success, CardDown, InvalidCard, LowBudget, ResearchNeeded, //NoDraw
}