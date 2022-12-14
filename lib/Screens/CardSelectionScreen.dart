
import 'dart:math';

import 'package:edilclima_app/Components/PlayCardPagerLayout/PlayCardPager.dart';
import 'package:edilclima_app/DataClasses/CardData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
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
var indexingList = List.generate(6, (index) => 0);
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

class CardSelectionState extends State<CardSelectionScreen>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    indexingList[0] = 0;
    indexingList[1] = 1;
    indexingList[2] = 2;
    indexingList[3] = 3;
    indexingList[4] = 2;
    indexingList[5] = 1;

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

    cardsTransformMap["firstCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["firstCard"]!));
    cardsTransformMap["secondCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["secondCard"]!));
    cardsTransformMap["thirdCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["thirdCard"]!))..scale(1.2, 1.2);
    cardsTransformMap["fourthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["fourthCard"]!));
    cardsTransformMap["fifthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["fifthCard"]!));
    cardsTransformMap["sixthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["sixthCard"]!));

    cardsControllerMap["firstCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    cardsControllerMap["secondCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    cardsControllerMap["thirdCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    cardsControllerMap["fourthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    cardsControllerMap["fifthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    cardsControllerMap["sixthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    cardsMatrixMap["firstCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["firstCard"]).animate(cardsControllerMap["firstCard"]!)
    ..addStatusListener((status) {changeIndexing(status);});
    cardsMatrixMap["secondCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["secondCard"]).animate(cardsControllerMap["secondCard"]!);
    cardsMatrixMap["thirdCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["thirdCard"]).animate(cardsControllerMap["thirdCard"]!);
    cardsMatrixMap["fourthCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["fourthCard"]).animate(cardsControllerMap["fourthCard"]!);
    cardsMatrixMap["fifthCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["fifthCard"]).animate(cardsControllerMap["fifthCard"]!);
    cardsMatrixMap["sixthCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["sixthCard"]).animate(cardsControllerMap["sixthCard"]!);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      for (AnimationController controller in cardsControllerMap.values){
        controller.forward(from: 0);
      }
    });
  }

  double findAngle(double angle){
    return pi * angle/180;
  }

  void createMatrix(Map<String, int> cardsTransformMap){

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

    double pivotPointX = screenWidth * 0.2;
    double pivotPointY = screenHeight * 0.4;

    //todo: sistema il giro delle carte perchè c'è sempre quella che salta

    return Consumer<GameModel>(builder: (context, gameModel, child) {

      firstCardsDataBinding(gameModel.playerCards);

      if(gameModel.playerTimerCountdown == null && rotationSense== rotVersus.Up){
        animateToStart();
      }

      return Column(mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1,
                child: PlayCardPager(gameModel.gameLogic.months.length)),

            Expanded(flex: 1, child:
            GestureDetector(
            onHorizontalDragUpdate: (dragEndDetails){
            if(rotationSense != rotVersus.Up && dragEndDetails.delta.dx > 20){
            //swipe left
              rotationSense = rotVersus.Right;
            }
            else if(rotationSense != rotVersus.Up && dragEndDetails.delta.dx < -20){
            //swipe right
                rotationSense = rotVersus.Left;
            }
            },

            onVerticalDragUpdate: (dragEndDetails) {
            if(rotationSense != rotVersus.Up && dragEndDetails.delta.dy < -20 && gameModel.playerTimerCountdown!=null){
            //swipe down
            rotationSense = rotVersus.Up;
            }
            else if(rotationSense == rotVersus.Up && dragEndDetails.delta.dy > 20 && gameModel.playerTimerCountdown!=null){
            //swipe up
            rotationSense = rotVersus.Down;
            }
            },
                onHorizontalDragEnd: gameModel.playerTimerCountdown!=null ? (_){
                updateAnimation(rotationSense, screenHeight);
                updateCardsData(gameModel.playerCards);} : (_){},

                onVerticalDragEnd:  gameModel.playerTimerCountdown!=null ? (_){
                updateAnimation(rotationSense, screenHeight);} : (_){},

            child:
                SizedBox(width: screenWidth, height: screenHeight * 0.5, child:
            Indexer(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Indexed(index: indexingList[0], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["sixthCard"]!.value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(cardsDataMap["sixthCard"])),
                      animation: cardsMatrixMap["sixthCard"]!,)),
                    Indexed(index: indexingList[1], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["firstCard"]!.value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(cardsDataMap["firstCard"])),
                      animation: cardsMatrixMap["firstCard"]!,)),
                    Indexed(index: indexingList[2], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["secondCard"]!
                            .value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(cardsDataMap["secondCard"])),
                      animation: cardsMatrixMap["secondCard"]!,)),
                    Indexed(index: indexingList[3], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["thirdCard"]!.value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(cardsDataMap["thirdCard"])),
                      animation: cardsMatrixMap["thirdCard"]!,)),
                    Indexed(index: indexingList[4], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["fourthCard"]!
                            .value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(cardsDataMap["fourthCard"])),
                      animation: cardsMatrixMap["fourthCard"]!,)),
                    Indexed(index: indexingList[5], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["fifthCard"]!.value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(cardsDataMap["fifthCard"])),
                      animation: cardsMatrixMap["fifthCard"]!,)),

                  ],
                )))),
          ]
      );
    });
  }

  void firstCardsDataBinding(List<CardData> playerCards){
    int counter = 0;
    for(final entry in cardsAngleMap.entries){
      if(entry.value.toInt() != 180 && counter < playerCards.length){
        cardsDataMap[entry.key] = playerCards[counter];
        counter++;
      }
      else{
        cardsDataMap[entry.key] = null;
      }
    }
  }

  //todo: popolare di carte vuote se finiscono le carte giocabili
  void updateCardsData(List<CardData> playerCards){
    String cardsDownKey = cardsAngleMap.entries.where((element) => element.value.toInt() == 180).single.key;
    switch(rotationSense){
      case rotVersus.Right: {
        if(counter>0){
          cardsDataMap[cardsDownKey] = playerCards[(counter -1)%playerCards.length];
        }
        else {
          cardsDataMap[cardsDownKey] = playerCards[playerCards.length - (counter.abs() - 1)%playerCards.length];
        }
      }
      break;
      case rotVersus.Left: {
        if(counter>0){
          cardsDataMap[cardsDownKey] = playerCards[(counter + 1)%playerCards.length];
        }
        else {
          cardsDataMap[cardsDownKey] = playerCards[playerCards.length - (counter.abs() + 1)%playerCards.length];
        }
      }
      break;
      default: {

      }
      break;
    }
  }

  void changeIndexing(AnimationStatus status){
       if (status == AnimationStatus.completed){
         setState(() {
           switch(rotationSense){
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
           }
  });}}

  void updateAnimation(rotVersus versus, double currentHeight){
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
                   case 180: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..setTranslationRaw(0, 100, 0);
                   }
                   break;
                   case 0: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..scale(1.2, 1.2)
                       ..setTranslationRaw(0, -currentHeight * 0.01, 0);
                   }
                   break;
                   default: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!));
                   }
                   break;
                 }

                 cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
               }

               for (AnimationController controller in cardsControllerMap.values){
                 controller.forward(from: 0);
               }
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
                   case 180: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..setTranslationRaw(0, 100, 0);
                   }
                   break;
                   case 0: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..scale(1.2, 1.2)
                       ..setTranslationRaw(0, -currentHeight * 0.01, 0);
                   }
                   break;
                   default: {
                     cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!));
                   }
                   break;
                 }
                 cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
               }

               for (AnimationController controller in cardsControllerMap.values){
                 controller.forward(from: 0);
               }
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

  void animateToStart(){
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
  }
}

enum pushResult{
Success, CardDown, InvalidCard, LowBudget, ResearchNeeded
}
