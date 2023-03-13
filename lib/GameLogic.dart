
import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:edilclima_app/DataClasses/CardInfluence.dart';
import 'package:edilclima_app/DataClasses/Pair.dart';
import 'package:edilclima_app/DataClasses/kotlinWhen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'DataClasses/CardData.dart';
import 'DataClasses/Context.dart';
import 'DataClasses/TeamInfo.dart';
import 'DataClasses/Zone.dart';

class GameLogic {


  int masterLevelCounter = 0;

  Map<String, List<String>> playersPerTeam = {};

  var months = ["gen", "feb", "mar", "apr", "mag", "giu", "lug", "ago", "set", "ott", "nov", "dec"];

  //contexts:
  // C01: città
  // C02: montagna
  // C03: mare
  List<Context> contextList = [
    Context("C01", null, ["inv03", "inv06"], {"A" : 1, "E" : 1, "C" : 0.7, "B" : 1.2}),
    Context("C02", ["imp07", "imp09", "imp10", "imp11"], null,  {"A" : 1.2, "E" : 1, "C" : 1.2, "B": 0.8}),
    Context("C03", null, ["imp09", "imp10", "imp11", "oth05"], {"A" : 1, "E" : 1, "C" : 0.7, "B" : 0.8})];

  //todo: rimetti il budget della prima zona a 350
  Map<int, Zone> zoneMap = {
    1 : Zone(1, 120, 135, 250, 2330, 150, 100, 50, 10, 1,
        ["inv03", "inv06", "inv08", "imp01", "imp02", "imp04", "imp08", "imp09", "imp11", "oth02", "oth05"],
        ["inv01", "inv02", "imp03", "oth01", "no Card"]),
    2 : Zone(1, 135, 130, 280, 2580, 150, 100, 50, 15, 1,
        ["inv03", "inv06", "inv08", "imp01", "imp02", "imp04", "imp08", "imp09", "imp11", "oth02", "oth04", "oth05"],
        ["inv01", "inv02", "imp03", "oth01", "no Card"])};

  List<CardData> CardsList = [
    //inv
    CardData("inv01", "Muro base",  0, 0, 0, 0, cardType.Build, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("inv02", "Cappotto EPS", -7, -10, 10, 10, cardType.Build, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("inv03", "Cappotto Fibra di Legno", -10, -15, 15, 10, cardType.Build, mulType.Fac, [Pair(influence.None, null)],  1),
    CardData("inv04", "Tetto base", 0, 0, 0, 0, cardType.Build, mulType.Fac, [Pair(influence.None, null)], 1 ),
    CardData("inv05", "Isolamento tetto in poliuretano",  -12, -10, 10, 15, cardType.Build, mulType.Fac, [Pair(influence.None, null)], 1 ),
    CardData("inv06", "Isolamento tetto in fibra di legno",  -17, -15, 15, 20, cardType.Build, mulType.Fac, [Pair(influence.None, null)] ,1 ),
    CardData("inv07", "Serramenti a vetro singolo", -2, 0, 5, 5, cardType.Window, mulType.Int, [Pair(influence.None, null)] ,1 ),
    CardData("inv08", "Serramenti in legno doppio vetro", -5, -5, 15, 10, cardType.Window, mulType.Int, [Pair(influence.None, null)], 1 ),
    CardData("inv09", "Serramenti in PVC doppio vetro",  -4, -5, 10, 10, cardType.Window, mulType.Int, [Pair(influence.None, null)], 1),
    CardData("inv10", "Serramenti in PVC triplo vetro", -6, -7, 15, 10, cardType.Window, mulType.Int, [Pair(influence.None, null)], 1,),

    //imp
    CardData("imp01", "Radiatori", -5, 7, -5, 20, cardType.Gear, mulType.Int, [Pair(influence.Card,
        CardInfluence("inv", {"A": 1.3, "E" : 1.3, "C" : 1.3}, true, 3))], 1),
    CardData("imp02", "Pannelli a pavimento", -9, 5, 5, 20, cardType.Build, mulType.Int,[Pair(influence.None, null)], 1),
    CardData("imp03", "Caldaia tradizionale", -100, -5, -15, 35, cardType.Gear, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("imp04", "Caldaia a condensazione", -150, -5, -10, 35, cardType.Gear, mulType.Fac, [Pair(influence.None, null)],  1),
    CardData("imp05", "Caldaia a pellet", -300, -10, -5, 40, cardType.Gear, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("imp06", "Sistema ibrido", -550, -15, 0, 40, cardType.Gear, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("imp07", "Pompa di calore geotermica",  -1400, -20, -20, 40, cardType.Gear, mulType.Fac,
        [Pair(influence.Card,
              CardInfluence("imp01", {"A": 1.2, "E" : 1.2, "C" : 1.2}, false, null)),
          Pair(influence.Card,
              CardInfluence("imp02", {"A": 1.2, "E" : 1.2, "C" : 1.2}, false, null))], 1),
    CardData("imp08", "Pompa di calore tradizionale", -900, -15, -20, -35, cardType.Gear, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("imp09", "Solare termico",  -200, -5, 20, 20, cardType.Panels, mulType.Fac, [Pair(influence.None, null)],1),
    CardData("imp10", "Fotovoltaico",  -600, -10, 25, 25, cardType.Panels, mulType.Fac, [Pair(influence.None, null)],1),
    CardData("imp11", "Batteria di accumulo", -600, 0, 10, 5, cardType.Gear, mulType.Fac, [Pair(influence.None, null)],1),

    //oth
    CardData("oth01", "Lampade a incandescenza", -8, 5, -10, 5, cardType.Lights, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("oth02", "Lampade a neon", -10, 5, -5, 5, cardType.Lights, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("oth03", "lampade a led", -14, 10, -5, 10, cardType.Lights, mulType.Fac, [Pair(influence.None, null)], 1),
    CardData("oth04", "Ventilazione meccanica", -250, 15, -5, 30, cardType.Gear, mulType.Fac, [Pair(influence.None, null)],  2),
    CardData("oth05", "Split e PDC",  -250, 10, -5, 25, cardType.Gear, mulType.Fac, [Pair(influence.None, null)], 1),
  ];

  Map<String, CardData> CardsMap = {};

  GameLogic(){
    CardsMap = { for (var e in CardsList) e.code : e};
  }

  void setLevelTimer(Function onTick, Function onFinish){
    var counter = 420;
    var levelTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      onTick();
      counter--;
      if (counter == 0) {
        onFinish();
        timer.cancel();
      }
    });
  }

  Map<String, Map<String, String>> selectTeamForPlayers(DataSnapshot snapshot){
    Map<String, Map<String, String>> resultingMap = {};
    int counter = 0;
    var teams = ["team1", "team2", "team3", "team4"];

    for (final player in snapshot.children){
      resultingMap.putIfAbsent(player.key!, () => {"team" : teams[counter%4], "ownedCards" : ""});
      counter++;
    }

    List<Pair> avatarMap = [];
    for (final entry in resultingMap.entries){
      avatarMap.add(Pair(entry.key, entry.value["team"]));
    }


    var grouped = groupBy(avatarMap, (Pair obj) => obj.second());
    Map<String, List<String>> newMap = {};
    for (final key in grouped.keys){
      newMap.putIfAbsent(key as String, () =>  grouped[key]!.map((e) => e.first() as String).toList());
    }

    playersPerTeam = newMap;

    return resultingMap;
  }

  Map<String, Map<String, Object>> createTeamsOnDb(List<String> teams){
    Map<String, Map<String, Object>> resultingMap = {};
    for (final team in teams){
      resultingMap.putIfAbsent(team, () => {"ableToPlay" : "",
        "playedCards" : "",
        "points" : 0,
        "drawableCards" : ""});
    }
    return resultingMap;
  }

  Map<String, Map<String, bool>> CardsToPlayers(int level){
    Map<String, Map<String, bool>> resultingMap = {};

    var startingCardDatasSet = CardsList.where((element) => (!zoneMap[level]!.startingList.contains(element.code) && element.level==level))
                            .map((e) => e.code).toList();

    for (final entry in playersPerTeam.entries){
      int counterCrds = 0;
      Map<String, List<String>> avatarMap = {};

      for (final player in entry.value){
        avatarMap.putIfAbsent(player, () => []);
      }

      while(counterCrds < startingCardDatasSet.length){
        int playersNum = (counterCrds%entry.value.length);
        avatarMap[avatarMap.keys.toList()[playersNum]]!.add(startingCardDatasSet[counterCrds]);
        counterCrds++;
      }

      avatarMap.entries.forEach((element) {element.value.add("void");});
      avatarMap.forEach((k, v) {
        var avatarList = { for (var e in v) e : true };
        resultingMap.putIfAbsent(k, () => avatarList);
      });
    }
    return resultingMap;
  }

  Map<String, bool> createDrawableCardsMap(int level){
    Map<String, bool> avatarMap = {};

    CardsList.where((element) => element.level==level).map((e) => e.code)
        .toList().forEach((element) {
           avatarMap.putIfAbsent(element, () => true);
        });
    return avatarMap;
  }

  Map<String, String> objectivePerTeam(){

     Map<String, String> resultingMap = {};
     List<String> zoneObj = ["smog", "energy", "comfort"];
     List<String> teamList = ["team1", "team2", "team3", "team4"];

     for (int i = 0; i < teamList.length; i++){
      var obj = zoneObj[ (i + masterLevelCounter) % 3];
      resultingMap.putIfAbsent(teamList[i], () => obj);
     }
     return resultingMap;
  }

  String findNextPlayer(String team, String lastPlayer){
    int oldIndex;

    if(lastPlayer == "" || lastPlayer == playersPerTeam[team]![playersPerTeam[team]!.length -1]){
      oldIndex = -1;
    }
    else{
     oldIndex =  playersPerTeam[team]!.indexOf(lastPlayer);
    }

      if (oldIndex == playersPerTeam[team]!.length) {oldIndex = -1;}

      return playersPerTeam[team]![oldIndex +1];
    }

    int nextLevel(){
    masterLevelCounter++;
    return masterLevelCounter;
    }

    CardData? findCard(String CardDataCode, String contextCode, int playerLevelCounter){

      CardData? cardBaseData = CardsMap[CardDataCode];
      Context context = contextList.where((element) => element.code==contextCode).single;

      if(cardBaseData!=null) {
        int newSmog = cardBaseData.smog;
        int newEnergy = cardBaseData.energy;
        int newComfort = cardBaseData.comfort;
        int newMoney = cardBaseData.money;

        KotlinWhen([
            KotlinPair((context.nerfList!=null && context.nerfList!.contains(cardBaseData.code)), (){
              newSmog = (newSmog * 0.8).round();
              newEnergy = (newEnergy * 0.8).round();
              newComfort = (newComfort * 0.8).round();
              }),
            KotlinPair((context.PUList!=null && context.PUList!.contains(cardBaseData.code)), () {
              newSmog = (cardBaseData.smog * 1.2).round();
              newEnergy = (cardBaseData.energy * 1.2).round();
              newComfort = (cardBaseData.comfort * 1.2).round();
             }),
            KotlinPair(cardBaseData.mul==mulType.Int, () {
              newMoney = (cardBaseData.money * zoneMap[playerLevelCounter]!.mulFactorInt).round();
            }),
            KotlinPair(cardBaseData.mul==mulType.Fac, () {
              newMoney = (cardBaseData.money * zoneMap[playerLevelCounter]!.mulFactorFac).round();
            })
          ], () => null).whenExeute();

        return CardData(cardBaseData.code, cardBaseData.title,  newMoney, newSmog, newEnergy,
            newComfort, cardBaseData.type, cardBaseData.mul, cardBaseData.inf, cardBaseData.level);
      }
        else{
          return null;
        }
      }

    Map<String, CardData> obtainPlayedCardsStatsMap(Map<String, CardData> map){

    double winterNerfCoeff = 0.7;

    for(final entry in map.entries){

      int finalSmog = entry.value.smog;
      int finalComfort = entry.value.comfort;
      int finalEnergy = entry.value.energy;

      if(entry.value.inf.first.first()!=influence.None){
        for(Pair pair in entry.value.inf){
          CardInfluence infData = pair.second() as CardInfluence;

          if(infData.multiInfluence){
            int playedCardsWithRequirements = map.values.where((element) =>
                element.code.contains(infData.resNeeded)).length;
            if(playedCardsWithRequirements >= infData.multiObjThreshold!){
              finalSmog = (finalSmog * infData.inCoeff["A"]!).round();
              finalEnergy = (finalEnergy * infData.inCoeff["E"]!).round();
              finalComfort = (finalComfort * infData.inCoeff["C"]!).round();
            }
          }
          else{
            if(map.values.map((e) => e.code).contains(infData.resNeeded)){
              finalSmog = (finalSmog * infData.inCoeff["A"]!).round();
              finalEnergy = (finalEnergy * infData.inCoeff["E"]!).round();
              finalComfort = (finalComfort * infData.inCoeff["C"]!).round();
            }
          }
        }
        }

        List<String> winterMonths = ["ott", "nov", "dec", "gen", "feb", "mar"];
        if(entry.value.code.contains("imp") && winterMonths.contains(entry.key)){
          finalComfort = (finalComfort * winterNerfCoeff).round();
        }

        map.update(entry.key, (value) =>
            CardData(value.code, value.title, value.money, finalSmog, finalEnergy,
                finalComfort, value.type, value.mul, value.inf, value.level));

      }

    return map;
    }



    TeamInfo evaluatePoints(int level, Map<String, CardData?>? map, int moves, String contextCode, String objective) {
      int points = 0;

      Context context = contextList.where((element) => element.code==contextCode).single;

      int budget = (zoneMap[level]!.budget * context.startStatsInfluence["B"]!).round();
      int energy = (zoneMap[level]!.initEnergy * context.startStatsInfluence["E"]!).round();
      int smog = (zoneMap[level]!.initSmog * context.startStatsInfluence["A"]!).round();
      int comfort = (zoneMap[level]!.initComfort * context.startStatsInfluence["C"]!).round();


      if(map!=null){
        for (final value in map.values) {
          budget += value!.money;
        }

        for (final value in map.values) {
          energy += value!.energy;
        }

        for (final value in map.values) {
          smog += value!.smog;
        }

        for (final value in map.values) {
          comfort += value!.comfort;
        }

       points += evaluateCardsPoints(map, level);
      }

      //print("points after cards: $points");

      if(objective!=""){
       points += evaluateTargetPoints(objective, level, smog, energy, comfort);
      }

      //print("points after objective: $points");

      points -= evaluateMovesPoints(moves);

      //print("points after moves: $points");

      return TeamInfo(budget, smog, energy, comfort, points >= 0 ? points : 0, moves);
    }

    int evaluateCardsPoints( Map<String, CardData?> map, int level) {

    int points = 0;

    int exactCardDataPoints = 100;
    int nearlyExactCardDataPoints = 75;
    int wrongCardDataPoints = 50;

        map!.entries.where((element) =>
            zoneMap[level]!.optimalList.contains(element.value!.code)).forEach((
            element) {
          if (zoneMap[level]!.optimalList.indexOf(element.value!.code) ==
              months.indexOf(element.key))
            points += exactCardDataPoints;
          else
            points += nearlyExactCardDataPoints;
        });

        map.entries.where((element) =>
        !zoneMap[level]!.optimalList.contains(element.value!.code)).forEach((element) {
          points +=
              wrongCardDataPoints;
        });

        return points;
    }

  int evaluateTargetPoints(String objective, int level, int smog, int energy, int comfort){

    int points = 0;
    int targetReachedPoints = 200;
    switch(objective){
      case "smog" : {
        if (smog < zoneMap[level]!.TargetA){
          points += 2 * targetReachedPoints;
        }
        else if(smog < zoneMap[level]!.TargetA){
          int maxRange = (zoneMap[level]!.TargetA - zoneMap[level]!.initSmog).abs();
          int actualRange =  (zoneMap[level]!.TargetA - smog).abs();
          points += (targetReachedPoints * (actualRange/maxRange)).toInt();
        }
      }
      break;
      case "energy" : {
        if (energy > zoneMap[level]!.TargetE){
          points += 2 * targetReachedPoints;
        }
        else if(energy > zoneMap[level]!.TargetE){
          int maxRange = (zoneMap[level]!.TargetE - zoneMap[level]!.initEnergy).abs();
          int actualRange =  (zoneMap[level]!.TargetE - energy).abs();
          points += (targetReachedPoints * (actualRange/maxRange)).toInt();
        }
      }
      break;
      case "comfort" : {
        if (comfort > zoneMap[level]!.TargetC){
          points += 2 * targetReachedPoints;
        }
        else if(comfort > zoneMap[level]!.TargetC){
          int maxRange = (zoneMap[level]!.TargetC - zoneMap[level]!.initComfort).abs();
          int actualRange =  (zoneMap[level]!.TargetC - comfort).abs();
          points += (targetReachedPoints * (actualRange/maxRange)).toInt();
        }
      }
      break;
    }
    return points;
  }

  int evaluateMovesPoints (int moves){
    int movesNegPoints = 5;
    return (moves * movesNegPoints);
  }

    String evaluateSingleCard(int level, String month, String cardCode) {

        if(zoneMap[level]!.optimalList.contains(cardCode)) {
          if (zoneMap[level]!.optimalList.indexOf(cardCode) == months.indexOf(month)) {
            return "Bene";
          }
          else{
            return "Ok";
          }
        }
        else{
          return "Non male";
        }
    }

  }