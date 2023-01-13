
import 'dart:math';

import 'package:edilclima_app/Components/DrawCardFab/DrawCardFab.dart';
import 'package:edilclima_app/Components/PlayCardPagerLayout/PlayCardPager.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/DataClasses/CardData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indexed/indexed.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../Components/selectCardLayout/undetailedCardLayout.dart';
import '../GameModel.dart';
import 'WaitingScreen.dart';

class CardSelectionScreen extends StatefulWidget{

  @override
  State<CardSelectionScreen> createState() => CardSelectionState();
}


Map<String, Matrix4> cardsTransformMap = Map();
Map<String, AnimationController> cardsControllerMap = Map();
Map<String, Animation<Matrix4>> cardsMatrixMap = Map();
Map<String, double> cardsAngleMap = Map();
Map<String, int> indexingList = Map();//List.generate(6, (index) => 0);
Map<String, CardData?> cardsDataMap = {};


double parentWidth = 0;
double parentHeight = 0;

int counter = 0;

enum rotVersus {
  Right,
  Left,
  Up,
  Down,
  None
}

rotVersus rotationSense = rotVersus.None;
String playableCard = "null";
CardData? onFocusCard;
bool ongoingAnimation = false;
List<CardData?> playerCards = List.generate(6, (index) => CardData("void", 0, 0, 0, 0,
    cardType.Pollution,
    researchSet.None, null,
    1));

class CardSelectionState extends State<CardSelectionScreen>
    with TickerProviderStateMixin {

  late bool triggerIndexing;
  late bool firstBinding;
  late bool openingAnimDone;
  late bool buildEnded;


  @override
  void initState() {
    super.initState();

    openingAnimDone = false;
    ongoingAnimation = false;
    triggerIndexing = false;
    firstBinding = false;
    buildEnded = false;
    counter = 0;

    indexingList["firstCard"] = 1;
    indexingList["secondCard"] = 2;
    indexingList["thirdCard"] = 3;
    indexingList["fourthCard"] = 2;
    indexingList["fifthCard"] = 1;
    indexingList["sixthCard"] = 0;

    cardsAngleMap["firstCard"] = -60;
    cardsAngleMap["secondCard"] = -30;
    cardsAngleMap["thirdCard"] = 0;
    cardsAngleMap["fourthCard"] = 30;
    cardsAngleMap["fifthCard"] = 60;
    cardsAngleMap["sixthCard"] = 180;

    cardsDataMap["firstCard"] = null;
    cardsDataMap["secondCard"] = null;
    cardsDataMap["thirdCard"] = null;
    cardsDataMap["fourthCard"] = null;
    cardsDataMap["fifthCard"] = null;
    cardsDataMap["sixthCard"] = null;

    cardsTransformMap["firstCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["firstCard"]!))..setTranslationRaw(-50, 0, 0);
    cardsTransformMap["secondCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["secondCard"]!))..setTranslationRaw(-50, 0, 0);
    cardsTransformMap["thirdCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["thirdCard"]!))..scale(1.2, 1.2);
    cardsTransformMap["fourthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["fourthCard"]!))..setTranslationRaw(50, 0, 0);
    cardsTransformMap["fifthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["fifthCard"]!))..setTranslationRaw(50, 0, 0);
    cardsTransformMap["sixthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["sixthCard"]!));

    cardsControllerMap["firstCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["secondCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["thirdCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["fourthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["fifthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["sixthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));

    cardsMatrixMap["firstCard"] = Tween<Matrix4>(begin: cardsTransformMap["firstCard"], end : cardsTransformMap["firstCard"]).animate(cardsControllerMap["firstCard"]!);
    cardsMatrixMap["secondCard"] = Tween<Matrix4>(begin: cardsTransformMap["secondCard"], end : cardsTransformMap["secondCard"]).animate(cardsControllerMap["secondCard"]!);
    cardsMatrixMap["thirdCard"] = Tween<Matrix4>(begin: cardsTransformMap["thirdCard"], end : cardsTransformMap["thirdCard"]).animate(cardsControllerMap["thirdCard"]!);
    cardsMatrixMap["fourthCard"] = Tween<Matrix4>(begin: cardsTransformMap["fourthCard"], end : cardsTransformMap["fourthCard"]).animate(cardsControllerMap["fourthCard"]!);
    cardsMatrixMap["fifthCard"] = Tween<Matrix4>(begin: cardsTransformMap["fifthCard"], end : cardsTransformMap["fifthCard"]).animate(cardsControllerMap["fifthCard"]!);
    cardsMatrixMap["sixthCard"] = Tween<Matrix4>(begin: cardsTransformMap["sixthCard"], end : cardsTransformMap["sixthCard"]).animate(cardsControllerMap["sixthCard"]!);

  }

  double findAngle(double angle){
    return pi * angle/180;
  }

  @override
  void dispose() {
    super.dispose();
    for (AnimationController controller in cardsControllerMap.values){
      controller.dispose();
    }
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_){
      buildEnded = true;
    });

    double pivotPointX = screenWidth * 0.2;
    double pivotPointY = screenHeight * 0.4;

    //todo: sistema il giro delle carte perchè c'è sempre quella che salta
    //todo: vedere se riesci a diminuire i rebuild inutili qui, magari scorpora in più components
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      var playerCardsCodes = playerCards.map((e) => e!.code).toList();
      var gameModelCardsCodes = gameModel.playerCards.map((e) => e!.code).toList();
      var matchingCardsCodes = gameModelCardsCodes.where((element) => playerCardsCodes.contains(element)).length;
      var cardCodesInScreen = playerCardsCodes.where((element) => element!="void").length;

      //primo indexing ad ogni apertura della pagina
      WidgetsBinding.instance?.addPostFrameCallback((_){
        if(!triggerIndexing && !firstBinding){
          firstBinding = true;
          List<CardData?> cardsList = gameModel.playerCards;
          if(cardsList.length < 6){
            for(int i = cardsList.length; i<6; i++){
              cardsList.add(CardData("void", 0, 0, 0, 0,
                  cardType.Pollution,
                  researchSet.None, null,
                  gameModel.playerLevelCounter));
            }
          }
          firstCardsDataBinding(cardsList!);
        }
      });

      //se ho giocato o preso una carta faccio il rebinding
      if(matchingCardsCodes!=cardCodesInScreen && buildEnded){
        List<CardData?> cardsList = gameModel.playerCards;
        if(cardsList.length < 6){
          for(int i = cardsList.length; i<6; i++){
            cardsList.add(CardData("void", 0, 0, 0, 0,
                cardType.Pollution,
                researchSet.None, null,
                gameModel.playerLevelCounter));
          }
        }
        firstCardsDataBinding(cardsList!);
      }

      if(!gameModel.tutorialOngoing && !openingAnimDone){
        openingAnimDone = true;
      }

      if(gameModel.playerTimer == null && rotationSense== rotVersus.Up){
        //animateToStart(playerCards!);
      }

      return
        Stack(alignment: Alignment.centerRight,
            children: [
        Column(mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded( flex: 1,
                          child: PlayCardPager(gameModel.gameLogic.months.length)),
                      Expanded(flex: 1, child:
                          Indexer(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Indexed(index: indexingList["sixthCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["sixthCard"]!.value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child: UndetailedCardLayout(cardsDataMap["sixthCard"],
                                          cardsAngleMap["sixthCard"]!,
                                          !gameModel.tutorialOngoing, animCallback)),
                                animation: cardsMatrixMap["sixthCard"]!,)),
                              Indexed(index: indexingList["firstCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["firstCard"]!.value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child: UndetailedCardLayout(cardsDataMap["firstCard"],
                                          cardsAngleMap["firstCard"]!,
                                          !gameModel.tutorialOngoing, animCallback)),
                                animation: cardsMatrixMap["firstCard"]!,)),
                              Indexed(index: indexingList["secondCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["secondCard"]!
                                      .value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child:
                               UndetailedCardLayout(cardsDataMap["secondCard"],
                                            cardsAngleMap["secondCard"]!,
                                            !gameModel.tutorialOngoing, animCallback)),
                                animation: cardsMatrixMap["secondCard"]!,)),
                              Indexed(index: indexingList["thirdCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["thirdCard"]!.value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child:
                                      UndetailedCardLayout(cardsDataMap["thirdCard"],
                                          cardsAngleMap["thirdCard"]!,
                                          !gameModel.tutorialOngoing, animCallback)),
                                animation: cardsMatrixMap["thirdCard"]!)),
                              Indexed(index: indexingList["fourthCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["fourthCard"]!
                                      .value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child: UndetailedCardLayout(cardsDataMap["fourthCard"],
                                          cardsAngleMap["fourthCard"]!,
                                          !gameModel.tutorialOngoing, animCallback)),
                                animation: cardsMatrixMap["fourthCard"]!,)),
                              Indexed(index: indexingList["fifthCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["fifthCard"]!.value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child: UndetailedCardLayout(cardsDataMap["fifthCard"],
                                          cardsAngleMap["fifthCard"]!,
                                          !gameModel.tutorialOngoing, animCallback)),
                                animation: cardsMatrixMap["fifthCard"]!,)),
                            ],
                          )
                      ),
                    ]
                ),
                InkWell(
                    onTap: (){
                      String cardPosition = cardsAngleMap.entries.where((element) => element.value == 0).single.key;
                      onFocusCard = cardsDataMap[cardPosition];
                      context.push("/cardSelectionScreen/cardInfoScreen");
                    },
                    child: SizedBox(
                      height: screenWidth * 0.2,
                      width: screenWidth * 0.2,
                      child: Center(child: Lottie.asset('assets/animations/InfoIcon.json',
                          width: screenWidth * 0.35,
                          height: screenWidth * 0.35,
                          animate: /*!gameModel.tutorialOngoing*/ false)),
                    ))]);
    });
  }

  void animCallback(){
    triggerIndexing = true;
    ongoingAnimation = true;
    updateAnimation(rotationSense, screenHeight, playerCards);
  }

  void firstCardsDataBinding(List<CardData?> cardsList){
    Map<String, CardData?> avatarMap = {};
    int counter = 0;
    for(final entry in cardsAngleMap.entries){
      if(entry.value.toInt() != 180 && counter < cardsList.length){
        avatarMap[entry.key] = cardsList[counter];
        counter++;
      }
      else{
        avatarMap[entry.key] = null;
      }
    }
    playerCards = cardsList;
    newCardsData(avatarMap);
  }

  void updateCardsData(List<CardData?> playerCards){
    String cardsDownKey = cardsAngleMap.entries.where((element) => element.value.toInt() == 180).single.key;
    String lastCardRight = cardsAngleMap.entries.where((element) => element.value.toInt() == -60).single.key;
    String lastCardLeft = cardsAngleMap.entries.where((element) => element.value.toInt() == 60).single.key;
    switch(rotationSense){
      case rotVersus.Right: {
        int index = playerCards.indexOf(cardsDataMap[lastCardRight]!);

        if(index == 0){
          index = playerCards.length -1;
        }
        else{
          index = index -1;
        }
        cardsDataMap[cardsDownKey] = playerCards[index];
      }
      break;
      case rotVersus.Left: {
        int index = playerCards.indexOf(cardsDataMap[lastCardLeft]!);

        if(index == playerCards.length - 1){
          index = 0;
        }
        else{
          index = index + 1;
        }
        cardsDataMap[cardsDownKey] = playerCards[index];
      }
      break;
      default: {

      }
      break;
    }
  }

  void changeIndexing(AnimationStatus status){
      print("change indexing");
       if (status == AnimationStatus.completed && triggerIndexing){
         setState(() {
           for(final entry in cardsAngleMap.entries){
             switch(entry.value.toInt()){
               case 30: {
                 indexingList[entry.key] = 2;
               }
               break;
               case 60: {
                 indexingList[entry.key] = 1;
               }
               break;
               case -30: {
                 indexingList[entry.key] = 2;
               }
               break;
               case -60: {
                 indexingList[entry.key] = 1;
               }
               break;
               case 180: {
                 indexingList[entry.key] = 0;
               }
               break;
               case 0: {
                 indexingList[entry.key] = 3;
               }
               break;
             }
           }

           /*switch(rotationSense){
             case rotVersus.Right : {
               for (int i = 0; i < 3; i++){
                 indexingList[((6 - counter)%6 + i)%6] += 1;
               }
               for (int i = 0; i < 3; i++){
                 indexingList[(5 - (6 + counter)%6 -i)%6 ] -= 1;
               }
               counter++;
             } break;
             case rotVersus.Left : {
               for (int i = 0; i < 3; i++){
                 indexingList[(6 - (6 + counter)%6 -i)%6 ] += 1;
               }
               for (int i = 0; i < 3; i++){
                 indexingList[((6 - counter)%6 + i + 1)%6] -= 1;
               }
               counter--;
             } break;
             default:
               break;
           }*/
  });}}

  void updateAnimation(rotVersus versus, double currentHeight, List<CardData?>? playerCards){

    if(playerCards!=null){
      updateCardsData(playerCards);
    }

       switch (versus){
         case rotVersus.Right :{
               for (String key in cardsTransformMap.keys){

                 double oldAngle = cardsAngleMap[key]!;
                 Matrix4 oldMatrix = cardsTransformMap[key]!;

                 double newAngle;
                 switch (oldAngle.toInt()){
                   case 180: {
                     newAngle = -60;
                   } break;
                   case 60: {
                     newAngle = 180;
                   } break;
                   default : {
                     newAngle = oldAngle + 30;
                   }
                   break;
                 }

                 cardsAngleMap[key] = newAngle;

                 switch(newAngle.toInt()){
                   case 30: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(50, 0, 0);
                   }
                   break;
                   case 60: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(50, 0, 0);
                   }
                   break;
                   case -30: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(-50, 0, 0);
                   }
                   break;
                   case -60: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(-50, 0, 0);
                   }
                   break;
                   case 180: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(0, 100, 0);
                   }
                   break;
                   case 0: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..scale(1.2, 1.2)
                       ..setTranslationRaw(0, -currentHeight * 0.01, 0);
                   }
                   break;
                 }

                 cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
               }

               List<AnimationController> delayedControllers = [];

               for (final entry in cardsControllerMap.entries){
                 if(cardsAngleMap[entry.key]! > 0 && cardsAngleMap[entry.key]!=180){
                   entry.value.forward(from: 0);
                 }
                 else{
                   delayedControllers.add(entry.value);
                 }
               }
               delayedAnimation(delayedControllers);
         } break;

         case rotVersus.Left :{
               for (String key in cardsTransformMap.keys){

                 double oldAngle = cardsAngleMap[key]!;
                 Matrix4 oldMatrix = cardsTransformMap[key]!;

                 double newAngle;
                 switch (oldAngle.toInt()){
                   case 180: {
                     newAngle = 60;
                   } break;
                   case -60: {
                     newAngle = 180;
                   } break;
                   default : {
                     newAngle = oldAngle - 30;
                   }
                   break;
                 }
                 cardsAngleMap[key] = newAngle;

                 switch(newAngle.toInt()){
                   case 30: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(50, 0, 0);
                   }
                   break;
                   case 60: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(50, 0, 0);
                   }
                   break;
                   case -30: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(-50, 0, 0);
                   }
                   break;
                   case -60: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(-50, 0, 0);
                   }
                   break;
                   case 180: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))
                       ..setTranslationRaw(0, 100, 0);
                   }
                   break;
                   case 0: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..scale(1.2, 1.2)
                       ..setTranslationRaw(0, -currentHeight * 0.01, 0);
                   }
                   break;
                 }
                 cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
               }

               List<AnimationController> delayedControllers = [];

               for (final entry in cardsControllerMap.entries){
                 if(cardsAngleMap[entry.key]! < 0 && cardsAngleMap[entry.key]!=180){
                   entry.value.forward(from: 0);
                 }
                 else{
                   delayedControllers.add(entry.value);
                 }
               }
               delayedAnimation(delayedControllers);
         } break;

         case rotVersus.Up : {
           for (String key in cardsAngleMap.keys){
             Matrix4 oldMatrix = cardsTransformMap[key]!;

             switch(cardsAngleMap[key]!.toInt()){
               case 0: {
                 cardsTransformMap[key] = Matrix4.identity()..scale(1.3, 1.3);
                 //modifico playable card in base alla carta che viene messa in up
                 playableCard = cardsDataMap[key]!.code;
               }
               break;
               default: {
                 cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..scale(0.8, 0.8);
               }
               break;
             }
             cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
           }

           for (AnimationController controller in cardsControllerMap.values){
             controller.forward(from: 0);
           }
         }
         break;
         case rotVersus.Down : {

           for (String key in cardsAngleMap.keys){
             Matrix4 oldMatrix = cardsTransformMap[key]!;

             switch(cardsAngleMap[key]!.toInt()){
               case 0: {
                 cardsTransformMap[key] = Matrix4.identity()..scale(1.2, 1.2);
                 //faccio tornare null la playable card perchè nessuna carta ha il focus
                 playableCard = "null";
               }
               break;
               default: {
                 cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..scale(1.0, 1.0);
               }
               break;
             }
             cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
           }

           for (AnimationController controller in cardsControllerMap.values){
             controller.forward(from: 0);
           }
         }
       }
  }

  void animateToStart(List<CardData?> playerCards){
    //se il timer del player finisce con la card up la faccio tornare in down, ma anche se il player gioca
    for (String key in cardsAngleMap.keys){
      Matrix4 oldMatrix = cardsTransformMap[key]!;

      switch(cardsAngleMap[key]!.toInt()){
        case 0: {
          cardsTransformMap[key] = Matrix4.identity()..scale(1.2, 1.2);
          playableCard = "null";
        }
        break;
        default: {
          cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..scale(1.0, 1.0);
        }
        break;
      }
      cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
    }

    for (AnimationController controller in cardsControllerMap.values){
      controller.forward(from: 0);
    }
    rotationSense = rotVersus.Down;
  }

  Future<void> triggerOpeningAnim() async{
    return Future<void>.delayed(const Duration(milliseconds: 200),
            () {
      for (final animController in cardsControllerMap.values){
        animController.forward();
    }});
  }

  Future<void> newCardsData(Map<String, CardData?> avatarMap) async{
    return Future<void>.delayed(const Duration(milliseconds: 50),
            () {
              setState(() {
                cardsDataMap = avatarMap;
              });
         });
  }

  Future<void> delayedAnimation(List<AnimationController> delayedControllers) async{
    return Future<void>.delayed(const Duration(milliseconds: 150),
        (){
          changeIndexing(AnimationStatus.completed);
          notifyAnimFinished();
          for(final animationController in delayedControllers){
              animationController.forward(from: 0);
          }
        }
        );
  }

  Future<void> notifyAnimFinished() async{
    return Future<void>.delayed(const Duration(milliseconds: 150),
            (){
              ongoingAnimation = false;
        }
    );
  }



}

enum pushResult{
Success, CardDown, InvalidCard, LowBudget, ResearchNeeded, //NoDraw
}
