
import 'dart:async';
import 'dart:core';

import 'package:collection/collection.dart';
import 'package:edilclima_app/DataClasses/Pair.dart';
import 'package:firebase_database/firebase_database.dart';

import 'DataClasses/CardData.dart';
import 'DataClasses/TeamInfo.dart';
import 'DataClasses/Zone.dart';

class GameLogic {


  int masterLevelCounter = 0;

  Map<String, List<String>> playersPerTeam = {};

  var months = ["gen", "feb", "mar", "apr", "mag", "giu", "lug", "ago", "set", "ott", "nov", "dec"];

  Map<int, Zone> zoneMap = {1 : Zone(1, 50, 190, 280, 350, 200, 80, 50,
  ["H01", "H02", "H04", "H06", "E10", "E11", "E13", "E07", "E12", "A08", "A09","A12" ],
  ["H01", "E04", "A04", "E07", "no CardData"])};

  List<CardData> CardsList = [
    CardData("A01", -80, 20, -30, 30, researchSet.Needed, ["H13"], 2 ),
    CardData("A02", -120, 0, -30, 0, researchSet.Needed, ["H08"],2),
    CardData("A03", -40, 0, -15, 25, researchSet.Needed, ["H09"], 2  ),
    CardData("A04", -50, 0, -20, 15, researchSet.None, null,1  ),
    CardData("A05", -60, 0, -30, 25, researchSet.None, null,2  ),
    CardData("A06", -30, 0, -25, 20, researchSet.None, null,1   ),
    CardData("A07", -50, 0, -25, 20, researchSet.Needed, ["H03"],2 ),
    CardData("A08", 0, 0, -20, 20, researchSet.None, null,1   ),
    CardData("A09", -40, -20, -30, 15, researchSet.None, null,1  ),
    CardData("A10", -30, 0, -20, 0, researchSet.None, null,1,    ),
    CardData("A11", -50, 0, -25, 20, researchSet.Needed, ["H05"],1,  ),
    CardData("A12", 0, 25, 20, -30, researchSet.None, null,1   ),
    CardData("A13", 0, 20, -20, -30, researchSet.None, null,2,   ),
    CardData("A14", 0, 30, -30, 10, researchSet.None, null,2,    ),
    CardData("A15", -40, 0, -30, 30, researchSet.Needed, ["H05", "H07"],1, ),
    CardData("A16", -30, 0, -40, -30, researchSet.None, null,2,   ),
    CardData("A17", -20, 0, -10, 10, researchSet.Needed, ["H12"],2, ),
    CardData("A18", -30, 0, -15, 20, researchSet.None, null,1,   ),
    CardData("A19", -70, 0, -30, 40, researchSet.None, null,2,  ),
    CardData("A20", 0, 0, -25, -45, researchSet.None, null,1,   ),

    //ministero energia
    CardData("E01", -20, 30, 40, -20, researchSet.None, null, 2),
    CardData("E02", -40, 50, 30, -10, researchSet.None, null,  2),
    CardData("E03", -70, 70, 10, -20, researchSet.Needed, ["H08"],2),
    CardData("E04", -15, 10, 0, 10, researchSet.None, null,  1),
    CardData("E05", -10, 10, 0, 10, researchSet.None, null, 2),
    CardData("E06", -20, 10, 10, 10, researchSet.Needed, ["H08"],1),
    CardData("E07", -30, 20, 10, 20, researchSet.Needed, ["H04"],1),
    CardData("E08", -20, 10, -20, -20, researchSet.None, null,2),
    CardData("E09", -10, 10, 0, 10, researchSet.Needed, ["H03", "H06"],1),
    CardData("E10", 0, 15, 10, 20, researchSet.Needed, ["H06"], 1),
    CardData("E11", 0, 15, 0, 20, researchSet.Needed, ["H01", "H02"],1),
    CardData("E12", 0, 10, -25, 10, researchSet.Needed, ["H06"],1),
    CardData("E13", 0, 10, 0, 20, researchSet.Needed, ["H01", "H02"],1),
    CardData("E14", 0, 20, 0, 10, researchSet.Needed, ["H13"],2),
    CardData("E15", -10, 20, 10, 35, researchSet.None, null,  1),
    CardData("E16", -40, 50, 10, -50, researchSet.None, null,  2),
    CardData("E17", -50, 40, 0, 0, researchSet.None,  null,1),
    CardData("E18", -200, 150, 0, 50, researchSet.Needed, ["H08"], 2),

    //ministero HR
    CardData("H01", -40, 10, 0, 20, researchSet.Develop, null,1),
    CardData("H02", -80, 0, 0, 10, researchSet.Develop, null,  1),
    CardData("H03", -20, 0, 0, 0, researchSet.Develop, null,1),
    CardData("H04", -50, 10, -10, 20, researchSet.Develop,  null,1),
    CardData("H05", -60, 0, 0, 20, researchSet.Develop, null,1),
    CardData("H06", -60, 10, 0, 20, researchSet.Develop, null,1),
    CardData("H07", -20, 0, -10, 10, researchSet.Develop, null,1),
    CardData("H08", -30, 0, 0, 0, researchSet.Develop, null,2),
    CardData("H09", -30, 0, -10, 10, researchSet.Develop, null,2),
    //mosse.add(Mossa("H10", 0, 15, 10, 20, Mossa.researchSet.Develop, 1));
    //mosse.add(Mossa("H11", 0, 15, 0, -20, Mossa.researchSet.Develop, 1));
    CardData("H12", -40, 0, -10, 20, researchSet.Develop, null,2),
    CardData("H13", -40, 10, 0, 20, researchSet.Develop, null,2)
  ];
  Map<String, CardData> CardsMap = {};

  GameLogic(){
    CardsMap = { for (var e in CardsList) e.code : e };
  }

  Timer setPlayerTimer(int timeToFinish, int TickInterval, Function onTick, Function onFinish){
    var counter = timeToFinish;
    var playerTimer = Timer.periodic(Duration(seconds: TickInterval), (timer) {
      onTick;
      counter--;
      if (counter == 0) {
        onFinish;
        timer.cancel();
      }
    });

    return playerTimer;
  }

  void setLevelTimer(Function onTick, Function onFinish){
    var counter = 420;
    var playerTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      onTick;
      counter--;
      if (counter == 0) {
        onFinish;
        timer.cancel();
      }
    });
  }

  Map<String, Map<String, String>> selectTeamForPlayers(DataSnapshot snapshot){
    Map<String, Map<String, String>> resultingMap = {};
    int counter = 0;
    var teams = ["team1", "team2", "team3", "team4"];

    for (final player in snapshot.children){
      resultingMap.putIfAbsent(player.key!, () => {"team" : teams[counter%4], "ownedCardDatas" : ""});
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
      resultingMap.putIfAbsent(team, () => {"ableToPlay" : "", "playedCardDatas" : "", "points" : 0});
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

    CardData? findCard(String CardDataCode){
     return CardsMap[CardDataCode];
    }

    TeamInfo evaluatePoints(int level, Map<String, String> map, int moves) {
      int points = 0;

      int exactCardDataPoints = 100;
      int nearlyExactCardDataPoints = 75;
      int wrongCardDataPoints = 50;
      int targetReachedPoints = 200;
      int movesNegPoints = 5;

      //todo: qui potresti ottenere dei null check (sulle pllayedCardDatas ma anche sulla zone), per cui se serve rendi le variabili nullable

      int budget = zoneMap[level]!.budget;
      for (final value in map.values) {
        budget += CardsMap[value]!.money;
      }

      int energy = zoneMap[level]!.initEnergy;
      for (final value in map.values) {
        energy += CardsMap[value]!.energy;
      }

      int smog = zoneMap[level]!.initSmog;
      for (final value in map.values) {
        smog += CardsMap[value]!.smog;
      }

      int comfort = zoneMap[level]!.initComfort;
      for (final value in map.values) {
        budget += CardsMap[value]!.comfort;
      }

      if (energy > zoneMap[level]!.TargetE) points += targetReachedPoints;
      if (smog < zoneMap[level]!.TargetA) points += targetReachedPoints;
      if (comfort > zoneMap[level]!.TargetC) points += targetReachedPoints;

      map.entries.where((element) =>
          zoneMap[level]!.optimalList.contains(element.value)).forEach((
          element) {
        if (zoneMap[level]!.optimalList.indexOf(element.value) ==
            months.indexOf(element.key))
          points += exactCardDataPoints;
        else
          points += nearlyExactCardDataPoints;
      });

      map.entries.where((element) =>
      !zoneMap[level]!.optimalList.contains(element.value)).forEach((element) {
        points +=
            wrongCardDataPoints; //todo: trovare un modo più intelligente per dire valutare i punti di un valore fisso per le carte sbagliate
      });

      points -= (moves * movesNegPoints);

      return TeamInfo(budget, smog, energy, comfort, points, moves);
    }

  }