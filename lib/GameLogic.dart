
import 'dart:async';
import 'dart:core';

import 'package:collection/collection.dart';
import 'package:edilclima_app/DataClasses/CardInfluence.dart';
import 'package:edilclima_app/DataClasses/Pair.dart';
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

  Map<int, List<String>> pngMapPerLevel = {
     1 : [
      'assets/gameBoardPng/MuriAlpha.png',
       'assets/gameBoardPng/AccAlpha.png',
       'assets/gameBoardPng/PompaAlpha.png',
       'assets/gameBoardPng/TermoAlpha.png',
       'assets/gameBoardPng/TettoAlpha.png',
       'assets/gameBoardPng/Pan1Alpha.png'
     ],
  };

  //contexts:
  // C01: città
  // C02: montagna
  // C03: mare
  List<Context> contextList = [
    Context("C01", null, ["inv03", "inv06"], {"A" : 1, "E" : 1, "C" : 0.7, "B" : 1.2}),
    Context("C02", ["imp07", "imp09", "imp10", "imp11"], null,  {"A" : 1.2, "E" : 1, "C" : 1.2, "B": 0.8}),
    Context("C03", null, ["imp09", "imp10", "imp11", "Oth05"], {"A" : 1, "E" : 1, "C" : 0.7, "B" : 0.8})];

  //todo: sistema il budget di starting per effetto dell context
  //todo: rimetti il budget della prima zona a 350
  Map<int, Zone> zoneMap = {1 : Zone(1, 50, 190, 280, 1000, 200, 80, 50,
  ["inv01", "inv02", "oth04", "inv06", "imp10", "imp11", "oth03", "imp07", "inv08", "imp08", "oth04","oth01"],
  ["inv01", "inv02", "imp04", "oth03", "no Card"])};

  List<CardData> CardsList = [
    //inv
    CardData("inv01", -80, 20, -30, 30, cardType.Inv, [Pair(influence.None, null)], 2),
    CardData("inv02", -120, 0, -30, 0, cardType.Inv, [Pair(influence.None, null)], 2),
    CardData("inv03", -40, 0, -15, 25, cardType.Inv, [Pair(influence.None, null)],  2),
    CardData("inv04", -50, 0, -20, 15, cardType.Inv, [Pair(influence.None, null)], 1 ),
    CardData("inv05", -60, 0, -30, 25, cardType.Inv, [Pair(influence.None, null)], 2 ),
    CardData("inv06", -30, 0, -25, 20, cardType.Inv, [Pair(influence.None, null)] ,1 ),
    CardData("inv07", -50, 0, -25, 20, cardType.Inv, [Pair(influence.None, null)] ,2 ),
    CardData("inv08", 0, 0, -20, 20, cardType.Inv, [Pair(influence.None, null)], 1 ),
    CardData("inv09", -40, -20, -30, 15, cardType.Inv, [Pair(influence.None, null)], 1),
    CardData("inv10", -30, 0, -20, 0, cardType.Inv, [Pair(influence.None, null)], 1,),

    //imp
    CardData("imp01", -20, 30, 40, -20, cardType.Imp, [Pair(influence.Card,
        CardInfluence("inv", {"A": 1.3, "E" : 1.3, "C" : 1.3}, true, 3))], 2),
    CardData("imp02", -40, 50, 30, -10, cardType.Imp,[Pair(influence.None, null)], 2),
    CardData("imp03", -70, 70, 10, -20, cardType.Imp, [Pair(influence.None, null)], 2),
    CardData("imp04", -15, 10, 0, 10, cardType.Imp, [Pair(influence.None, null)],  1),
    CardData("imp05", -10, 10, 0, 10, cardType.Imp, [Pair(influence.None, null)], 2),
    CardData("imp06", -20, 10, 10, 10, cardType.Imp, [Pair(influence.None, null)], 1),
    CardData("imp07", -30, 20, 10, 20, cardType.Imp,
        [Pair(influence.Card,
              CardInfluence("imp01", {"A": 1.2, "E" : 1.2, "C" : 1.2}, false, null)),
          Pair(influence.Card,
              CardInfluence("imp02", {"A": 1.2, "E" : 1.2, "C" : 1.2}, false, null))], 1),
    CardData("imp08", -20, 10, -20, -20, cardType.Imp, [Pair(influence.None, null)], 2),
    CardData("imp09", -10, 10, 0, 10, cardType.Imp, [Pair(influence.None, null)],1),
    CardData("imp10", 0, 15, 10, 20, cardType.Imp, [Pair(influence.None, null)],1),
    CardData("imp11", 0, 15, 0, 20, cardType.Imp, [Pair(influence.None, null)],1),

    //oth
    CardData("oth01", -40, 10, 0, 20, cardType.Oth, [Pair(influence.None, null)], 1),
    CardData("oth02", -80, 0, 0, 10, cardType.Oth, [Pair(influence.None, null)], 1),
    CardData("oth03", -20, 0, 0, 0, cardType.Oth, [Pair(influence.None, null)], 1),
    CardData("oth04", -50, 10, -10, 20, cardType.Oth,[Pair(influence.None, null)],  1),
    CardData("oth05", -60, 0, 0, 20, cardType.Oth, [Pair(influence.None, null)], 1),
  ];
  Map<String, CardData> CardsMap = {};

  GameLogic(){
    CardsMap = { for (var e in CardsList) e.code : e };
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

  Map<String, Map<String, Object>> createTeamsOnDb(){
    Map<String, Map<String, Object>> resultingMap = {};
    var teams = ["team1", "team2", "team3", "team4"];
    for (final team in teams){
      resultingMap.putIfAbsent(team, () => {"ableToPlay" : "",
        "playedCards" : "",
        "points" : 0,
        "drawableCards" : ""});
    }
    return resultingMap;
  }

  Map<String, Map<String, bool>> CardsToPLayers(int level){
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

    CardData? findCard(String CardDataCode, String contextCode){

      //todo: testa che i dati siano giusti con il context e le inf fra cards
      CardData? cardBaseData = CardsMap[CardDataCode];
      Context context = contextList.where((element) => element.code==contextCode).single;

      if(cardBaseData!=null){
        if(context.nerfList!=null && context.nerfList!.contains(cardBaseData.code)){
          int newSmog = (cardBaseData.smog * 0.8).round();
          int newEnergy = (cardBaseData.energy * 0.8).round();
          int newComfort = (cardBaseData.comfort * 0.8).round();

          return CardData(cardBaseData.code, cardBaseData.money, newEnergy, newSmog,
              newComfort, cardBaseData.type, cardBaseData.inf, cardBaseData.level);
        }

        else if(context.PUList!=null && context.PUList!.contains(cardBaseData.code)){

          int newSmog = (cardBaseData.smog * 1.2).round();
          int newEnergy = (cardBaseData.energy * 1.2).round();
          int newComfort = (cardBaseData.comfort * 1.2).round();

          return CardData(cardBaseData.code, cardBaseData.money, newEnergy, newSmog,
              newComfort, cardBaseData.type, cardBaseData.inf, cardBaseData.level);
        }

        else{
          return cardBaseData;
        }

      }
      else{
        return null;
      }
    }

    Map<String, CardData> obtainPlayedCardsStatsMap(Map<String, CardData> map){

    for(final entry in map.entries){
      if(entry.value.inf.first.first()!=influence.None){

        int finalSmog = entry.value.smog;
        int finalComfort = entry.value.comfort;
        int finalEnergy = entry.value.energy;

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

        map.update(entry.key, (value) =>
            CardData(value.code, value.money, finalEnergy, finalSmog,
                finalComfort, value.type, value.inf, value.level));
        }
      }

    return map;
    }



    TeamInfo evaluatePoints(int level, Map<String, CardData?>? map, int moves, String contextCode) {
      int points = 0;

      int exactCardDataPoints = 100;
      int nearlyExactCardDataPoints = 75;
      int wrongCardDataPoints = 50;
      int targetReachedPoints = 200;
      int movesNegPoints = 5;

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

        map.entries.where((element) =>
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
              wrongCardDataPoints; //todo: trovare un modo più intelligente per dire valutare i punti di un valore fisso per le carte sbagliate
        });
      }

      if (energy > zoneMap[level]!.TargetE) points += targetReachedPoints;
      if (smog < zoneMap[level]!.TargetA) points += targetReachedPoints;
      if (comfort > zoneMap[level]!.TargetC) points += targetReachedPoints;

      points -= (moves * movesNegPoints);

      return TeamInfo(budget, smog, energy, comfort, points >= 0 ? points : 0, moves);
    }

  }