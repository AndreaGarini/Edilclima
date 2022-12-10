
import 'dart:math';

import 'package:edilclima_app/Components/SizedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:provider/provider.dart';

import '../Components/undetailedCardLayout.dart';
import '../GameModel.dart';

class CardSelectionScreen extends StatefulWidget{

  @override
  State<CardSelectionScreen> createState() => CardSelectionState();
}


Map<String, Matrix4> cardsTransformMap = Map();
Map<String, AnimationController> cardsControllerMap = Map();
Map<String, Animation<Matrix4>> cardsMatrixMap = Map();
Map<String, double> cardsAngleMap = Map();
var indexingList = List.generate(6, (index) => 0);


double parentWidth = 0;
double parentHeight = 0;

int counter = 0;

enum rotVersus {
  Right,
  Left
}


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

    cardsTransformMap["firstCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["firstCard"]!));
    cardsTransformMap["secondCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["secondCard"]!));
    cardsTransformMap["thirdCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["thirdCard"]!));
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

    //todo: fare il binding carte-dati
    final currentWidth = MediaQuery
        .of(context)
        .size
        .width;
    final currentHeight = MediaQuery
        .of(context)
        .size
        .height;

    double pivotPointX = currentWidth * 0.2;
    double pivotPointY = currentHeight * 0.4;

    parentWidth = currentWidth;
    parentHeight = currentHeight;


    return Consumer<GameModel>(builder: (context, gameModel, child) {


      return Column(mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child:
            Container(width: currentWidth * 0.6, height: currentHeight * 0.6,
                child:
                Indexer(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Indexed(index: indexingList[0], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["sixthCard"]!.value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(
                                currentWidth * 0.4, currentHeight * 0.4,
                                indexingList[0])),
                      animation: cardsMatrixMap["sixthCard"]!,)),
                    Indexed(index: indexingList[1], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["firstCard"]!.value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(
                                currentWidth * 0.4, currentHeight * 0.4,
                                indexingList[1])),
                      animation: cardsMatrixMap["firstCard"]!,)),
                    Indexed(index: indexingList[2], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["secondCard"]!
                            .value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(
                                currentWidth * 0.4, currentHeight * 0.4,
                                indexingList[2])),
                      animation: cardsMatrixMap["secondCard"]!,)),
                    Indexed(index: indexingList[3], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["thirdCard"]!.value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(
                                currentWidth * 0.4, currentHeight * 0.4,
                                indexingList[3])),
                      animation: cardsMatrixMap["thirdCard"]!,)),
                    Indexed(index: indexingList[4], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["fourthCard"]!
                            .value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(
                                currentWidth * 0.4, currentHeight * 0.4,
                                indexingList[4])),
                      animation: cardsMatrixMap["fourthCard"]!,)),
                    Indexed(index: indexingList[5], child:
                    AnimatedBuilder(builder: (context, child) =>
                        Transform(transform: cardsMatrixMap["fifthCard"]!.value,
                            origin: Offset(pivotPointX, pivotPointY),
                            child: UndetailedCardLayout(
                                currentWidth * 0.4, currentHeight * 0.4,
                                indexingList[5])),
                      animation: cardsMatrixMap["fifthCard"]!,)),

                  ],
                ))),
            Expanded(flex: 1,
                child: Row(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedButton(currentWidth * 0.2, "rotate card right", () {
                      setState(() {
                        counter++;
                        updateAnimation(rotVersus.Right);
                      });
                    }),
                    SizedButton(currentWidth * 0.2, "rotate card left", () {
                      setState(() {
                        counter--;
                        updateAnimation(rotVersus.Left);
                      });
                    }),
                    Spacer()
                  ],))
          ]
      );
    });
  }

  //todo: sistemare l'indexing delle carte
  void changeIndexing(AnimationStatus status){
       if (status == AnimationStatus.completed){
         setState(() {
           for (int i = 0; i < indexingList.length; i++){
                if ((i + counter)%6 == 0){
                  indexingList[i] = 1;
                }
                else{
                  indexingList[i] = 3 - ((i + counter)%3);
                }
       }
  });}}

  void updateAnimation(rotVersus versus){
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
                 if (newAngle == 180){
                   cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..setTranslationRaw(0, -100, 0);
                 }
                 else {
                   cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!));
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
                 if (newAngle == 180){
                   cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..setTranslationRaw(0, -100, 0);
                 }
                 else {
                   cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!));
                 }
                 cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
               }

               for (AnimationController controller in cardsControllerMap.values){
                 controller.forward(from: 0);
               }
         } break;

       }
  }
}
