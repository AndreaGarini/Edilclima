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
import '../DataClasses/Pair.dart';
import '../GameModel.dart';
import 'WaitingScreen.dart';

class CardSelectionScreen extends StatefulWidget{

  @override
  State<CardSelectionScreen> createState() => CardSelectionState();
}

late Function discardMechCallback;
Function? forcingDataBinding;

double parentWidth = 0;
double parentHeight = 0;

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
late bool ongoingAnimation;
bool firstOpening = true;
List<CardData?> playerCards = List.generate(6, (index) => CardData("void", "", 0, 0, 0, 0,
    cardType.Imp, mulType.Int,
    [Pair(influence.None, null)],
    1));
List<String> lastDrawnCards = [];

class CardSelectionState extends State<CardSelectionScreen>
    with TickerProviderStateMixin {

  late bool triggerIndexing;
  late bool firstBinding;
  late bool openingAnimDone;
  late bool buildEnded;
  late bool discardMechOn;
  List<String> newCards = [];

  Map<String, Matrix4> cardsTransformMap = {};
  Map<String, AnimationController> cardsControllerMap = {};
  Map<String, Animation<Matrix4>> cardsMatrixMap = {};
  Map<String, double> cardsAngleMap = {};
  Map<String, int> indexingList = {};
  Map<String, CardData?> cardsDataMap = {};


  @override
  void initState() {
    super.initState();

    onFocusCard = null;
    openingAnimDone = false;
    ongoingAnimation = false;
    triggerIndexing = false;
    firstBinding = false;
    buildEnded = false;
    discardMechOn = false;
    rotationSense = rotVersus.None;

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

    if(firstOpening){
      cardsTransformMap["firstCard"] = Matrix4.identity(); //..setRotationZ(findAngle(cardsAngleMap["firstCard"]!))..setTranslationRaw(-50, 0, 0);
      cardsTransformMap["secondCard"] = Matrix4.identity(); //..setRotationZ(findAngle(cardsAngleMap["secondCard"]!))..setTranslationRaw(-50, 0, 0);
      cardsTransformMap["thirdCard"] = Matrix4.identity(); //..setRotationZ(findAngle(cardsAngleMap["thirdCard"]!))..scale(1.2, 1.2);
      cardsTransformMap["fourthCard"] = Matrix4.identity(); //..setRotationZ(findAngle(cardsAngleMap["fourthCard"]!))..setTranslationRaw(50, 0, 0);
      cardsTransformMap["fifthCard"] = Matrix4.identity();//..setRotationZ(findAngle(cardsAngleMap["fifthCard"]!))..setTranslationRaw(50, 0, 0);
      cardsTransformMap["sixthCard"] = Matrix4.identity();//..setRotationZ(findAngle(cardsAngleMap["sixthCard"]!));
    }
    else{
      cardsTransformMap["firstCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["firstCard"]!))..setTranslationRaw(-50, 0, 0);
      cardsTransformMap["secondCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["secondCard"]!))..setTranslationRaw(-50, 0, 0);
      cardsTransformMap["thirdCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["thirdCard"]!))..scale(1.2, 1.2);
      cardsTransformMap["fourthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["fourthCard"]!))..setTranslationRaw(50, 0, 0);
      cardsTransformMap["fifthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["fifthCard"]!))..setTranslationRaw(50, 0, 0);
      cardsTransformMap["sixthCard"] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap["sixthCard"]!));
    }

    cardsControllerMap["firstCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150)); //150
    cardsControllerMap["secondCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["thirdCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["fourthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["fifthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    cardsControllerMap["sixthCard"] = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));

    cardsMatrixMap["firstCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["firstCard"]).animate(cardsControllerMap["firstCard"]!);
    cardsMatrixMap["secondCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["secondCard"]).animate(cardsControllerMap["secondCard"]!);
    cardsMatrixMap["thirdCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["thirdCard"]).animate(cardsControllerMap["thirdCard"]!);
    cardsMatrixMap["fourthCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["fourthCard"]).animate(cardsControllerMap["fourthCard"]!);
    cardsMatrixMap["fifthCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["fifthCard"]).animate(cardsControllerMap["fifthCard"]!);
    cardsMatrixMap["sixthCard"] = Tween<Matrix4>(begin: Matrix4.identity(), end : cardsTransformMap["sixthCard"]).animate(cardsControllerMap["sixthCard"]!);

    if(!firstOpening){
      WidgetsBinding.instance?.addPostFrameCallback((_){
        for (AnimationController controller in cardsControllerMap.values){
          controller.forward(from: 0);
        }
      });
    }

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

      discardMechCallback = discardSelection;
      forcingDataBinding = forceCardsBindingCallback;

      //primo indexing ad ogni apertura della pagina
      WidgetsBinding.instance?.addPostFrameCallback((_){
        if(!triggerIndexing && !firstBinding){
          firstBinding = true;
          List<CardData?> cardsList = [];
          gameModel.playerCards.forEach((element) {
            cardsList.add(CardData(element.code, element.title, element.money,
                element.energy, element.smog, element.comfort,
                element.type, element.mul, element.inf, element.level));
          });
          if(cardsList.length < 6){
            for(int i = cardsList.length; i<6; i++){
              cardsList.add(CardData("void", "", 0, 0, 0, 0,
                  cardType.Imp, mulType.Int,
                  [Pair(influence.None, null)],
                  gameModel.playerLevelCounter));
            }
          }
          cardsDataBinding(cardsList!);
        }
      });

      //se ho giocato o preso una carta faccio il rebinding
      if(!gameModel.tutorialOngoing && !openingAnimDone){
        openingAnimDone = true;
      }

      return
        Stack(alignment: Alignment.center,
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
                                          !gameModel.tutorialOngoing, animCallback, newCardCallback,
                                       newCards.contains("sixthCard") ? true : false)),
                                animation: cardsMatrixMap["sixthCard"]!,)),
                              Indexed(index: indexingList["firstCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["firstCard"]!.value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child: UndetailedCardLayout(cardsDataMap["firstCard"],
                                          cardsAngleMap["firstCard"]!,
                                          !gameModel.tutorialOngoing, animCallback, newCardCallback,
                                          newCards.contains("firstCard") ? true : false)),
                                animation: cardsMatrixMap["firstCard"]!,)),
                              Indexed(index: indexingList["secondCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["secondCard"]!
                                      .value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child:
                               UndetailedCardLayout(cardsDataMap["secondCard"],
                                            cardsAngleMap["secondCard"]!,
                                            !gameModel.tutorialOngoing, animCallback, newCardCallback,
                                   newCards.contains("secondCard") ? true : false)),
                                animation: cardsMatrixMap["secondCard"]!,)),
                              Indexed(index: indexingList["thirdCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["thirdCard"]!.value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child:
                                      UndetailedCardLayout(cardsDataMap["thirdCard"],
                                          cardsAngleMap["thirdCard"]!,
                                          !gameModel.tutorialOngoing, animCallback, newCardCallback,
                                          newCards.contains("thirdCard") ? true : false)),
                                animation: cardsMatrixMap["thirdCard"]!)),
                              Indexed(index: indexingList["fourthCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["fourthCard"]!
                                      .value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child: UndetailedCardLayout(cardsDataMap["fourthCard"],
                                          cardsAngleMap["fourthCard"]!,
                                          !gameModel.tutorialOngoing, animCallback, newCardCallback,
                                          newCards.contains("fourthCard") ? true : false)),
                                animation: cardsMatrixMap["fourthCard"]!,)),
                              Indexed(index: indexingList["fifthCard"]!, child:
                              AnimatedBuilder(builder: (context, child) =>
                                  Transform(transform: cardsMatrixMap["fifthCard"]!.value,
                                      origin: Offset(pivotPointX, pivotPointY),
                                      child: UndetailedCardLayout(cardsDataMap["fifthCard"],
                                          cardsAngleMap["fifthCard"]!,
                                          !gameModel.tutorialOngoing, animCallback, newCardCallback,
                                          newCards.contains("fifthCard") ? true : false)),
                                animation: cardsMatrixMap["fifthCard"]!,)),
                            ],
                          )
                      ),
                    ]
                ),
                  Positioned(top: screenHeight * 0.33, right: 0,
                  child:
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
                    )))]);
    });
  }

  void animCallback(){
    triggerIndexing = true;
    ongoingAnimation = true;
    updateAnimation(rotationSense, screenHeight, playerCards);
  }

  void newCardCallback(String cardCode){
    lastDrawnCards.remove(cardCode);
    String cardCodePos = cardsDataMap.entries.where((element) =>
    element.value!=null && element.value!.code==cardCode).single.key;
    setState((){
      newCards.remove(cardCodePos);
    });
  }

  void forceCardsBindingCallback(GameModel gameModel){
    if(mounted){
      if(buildEnded && !discardMechOn){
        List<CardData?> cardsList = [];
        gameModel.playerCards.forEach((element) {
          cardsList.add(CardData(element.code, element.title, element.money,
              element.energy, element.smog, element.comfort,
              element.type, element.mul, element.inf, element.level));
        });
        if(cardsList.length < 6){
          for(int i = cardsList.length; i<6; i++){
            cardsList.add(CardData("void", "", 0, 0, 0, 0,
                cardType.Imp, mulType.Int,
                [Pair(influence.None, null)],
                gameModel.playerLevelCounter));
          }
        }
        cardsDataBinding(cardsList!);
      }
    }
  }

  void cardsDataBinding(List<CardData?> cardsList){

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

    String upCardKey = cardsAngleMap.entries.where((element) => element.value==0).single.key;
    playerCards = cardsList;
    newCardsData(avatarMap, upCardKey);
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
        if(lastDrawnCards.isNotEmpty && lastDrawnCards.contains(playerCards[index]!.code)){
          if(!newCards.contains(cardsDownKey)){
            newCards.add(cardsDownKey);
          }
        }
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
        if(lastDrawnCards.isNotEmpty && lastDrawnCards.contains(playerCards[index]!.code)){
          if(!newCards.contains(cardsDownKey)){
            newCards.add(cardsDownKey);
          }
        }
      }
      break;
      default: {

      }
      break;
    }
  }

  void changeIndexing(AnimationStatus status){
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
  });}}

  void updateAnimation(rotVersus versus, double currentHeight, List<CardData?>? playerCards){

    if(firstOpening){
      firstOpening = false;
    }

    if(playerCards!=null){
      updateCardsData(playerCards);
    }


    if(versus == rotVersus.None){
      versus = rotVersus.Right;
      rotationSense = rotVersus.Right;
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

                 cardsControllerMap[key]!.value = 0;
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
                 cardsControllerMap[key]!.value = 0;
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
    String upCardCode = cardsAngleMap.entries.where((element) => element.value==0).single.key;
    if(cardsDataMap[upCardCode]!=null){
      playableCard = cardsDataMap[upCardCode]!.code;
    }
  }

  void discardSelection(GameModel gameModel){

    discardMechOn = true;
    String centralCardCode = cardsAngleMap.entries.where((element) => element.value==0).single.key;
    String cardCode = cardsDataMap[centralCardCode]!.code;
    int cardPosInArray = cardCode == "void" ? 0 :
    gameModel.playerCards.indexOf(gameModel.gameLogic.findCard(cardCode, gameModel.playerContextCode!, gameModel.playerLevelCounter)!);
    int arrayLenght = gameModel.playerCards.length;

    int selectedCardPos = 0;
    if(arrayLenght>1){
      do{
        selectedCardPos = Random().nextInt(arrayLenght - 1);
      }while(selectedCardPos==cardPosInArray);
    }


    if(lastDrawnCards.contains(cardCode) && cardCode!="void"){
      lastDrawnCards.remove(cardCode);
    }

    gameModel.discardMechCheck().then((value) {
      if(value){
        gameModel.discardCardMech(selectedCardPos)
            .then((extractedCardData) {
          int bias = (selectedCardPos - cardPosInArray).abs();
          if(selectedCardPos>cardPosInArray){
            for(int i = 0; i< bias; i++){
              if(i == bias -1 || bias == 0){
                autoRotate(i * 400, rotVersus.Right, true, extractedCardData, gameModel);
              }
              else{
                autoRotate(i * 400, rotVersus.Right, false, extractedCardData, gameModel);
              }
            }
          }
          else{
            for(int i = 0; i< bias; i++){
              if(i == bias -1 || bias == 0){
                autoRotate(i * 400, rotVersus.Left, true, extractedCardData, gameModel);
              }
              else{
                autoRotate(i * 400, rotVersus.Left, false, extractedCardData, gameModel);
              }
            }
          }
        });
      }
    } );
    }

  Future<void> autoRotate(int delay, rotVersus sense, bool posReached, CardData extractedCardData, GameModel gameModel) async{
    return Future<void>.delayed(Duration(milliseconds: delay),
            () {
          if(posReached){
            discardMechFinalBinding(gameModel);
            exitCardAnim(extractedCardData);
          }
          else{
            triggerIndexing = true;
            ongoingAnimation = true;
            updateAnimation(sense, screenHeight, playerCards);
          }
        });
  }

  Future<void> discardMechFinalBinding(GameModel gameModel) async{
    return Future<void>.delayed(const Duration(milliseconds: 700),
            () {
          forceCardsBindingCallback(gameModel);
        });
  }

  void exitCardAnim(CardData extractedCardData){

    String centralCard = cardsAngleMap.entries.where((element) => element.value == 0).single.key;
    Matrix4 oldMatrix = cardsTransformMap[centralCard]!;
    cardsAngleMap[centralCard] = 180;
    cardsTransformMap[centralCard] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[centralCard]!));
    cardsMatrixMap[centralCard] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[centralCard]).animate(cardsControllerMap[centralCard]!);
    cardsControllerMap[centralCard]!.forward(from: 0);
    closeCardWheel(centralCard);
  }

  Future<void> closeCardWheel(String centralCard) async{
    return Future<void>.delayed(const Duration(milliseconds: 400),
            () {
          discardMechOn = false;
          closeCardWheelAnim(centralCard);
        });
  }

  void closeCardWheelAnim(String centralCard){
    for(String key in cardsAngleMap.keys){
      if(cardsAngleMap[key]!=180.0){
        Matrix4 oldMatrix = cardsTransformMap[key]!;
        cardsTransformMap[key] = Matrix4.identity();
        cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
        cardsControllerMap[key]!.value = 0;
        cardsControllerMap[key]!.forward(from: 0);
      }
    }
    //rimetto l'angolo della carta uscita a 0 cos' posso riaprire la ruota di carte correttamente
    cardsAngleMap[centralCard] = 0;
    openCardWheel(centralCard);
  }

  Future<void> openCardWheel(String centralCard) async{
    return Future<void>.delayed(const Duration(milliseconds: 300),
            () {
          //qui stiamo facendo il binding delle carte con discardMechFinalBinding chiamata in autoRotate
          discardMechOn = false;
          reopenCardWheelAnim();
        });
  }

  void reopenCardWheelAnim(){
    changeIndexing(AnimationStatus.completed);
    for(String key in cardsAngleMap.keys) {
      if (cardsAngleMap[key] != 180) {
        Matrix4 oldMatrix = cardsTransformMap[key]!;
        switch(cardsAngleMap[key]!.toInt()){
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
          case 0: {
            cardsTransformMap[key] = Matrix4.identity()..setRotationZ(findAngle(cardsAngleMap[key]!))..scale(1.2, 1.2)
              ..setTranslationRaw(0, -screenHeight * 0.01, 0);
          }
          break;
        }
        cardsMatrixMap[key] = Tween<Matrix4>(begin: oldMatrix, end : cardsTransformMap[key]).animate(cardsControllerMap[key]!);
        cardsControllerMap[key]!.forward(from: 0);
      }
    }
    String upCardKey = cardsAngleMap.entries.where((element) => element.value==0).single.key;
    playableCard = cardsDataMap[upCardKey]!.code;
  }

  Future<void> newCardsData(Map<String, CardData?> avatarMap, String upCardKey) async{
    return Future<void>.delayed(const Duration(milliseconds: 50),
            () {
              if(lastDrawnCards.isNotEmpty){
                newCards = avatarMap.entries.where((element) => element.value!=null &&
                    lastDrawnCards.contains(element.value!.code)).map((e) => e.key).toList();
              }
              setState(() {
                cardsDataMap = avatarMap;
                playableCard = cardsDataMap[upCardKey]!.code;
              });
         });
  }

  Future<void> delayedAnimation(List<AnimationController> delayedControllers) async{
    return Future<void>.delayed(const Duration(milliseconds: 150), //150
        (){
          notifyAnimFinished();
          changeIndexing(AnimationStatus.completed);
          for(final animationController in delayedControllers){
              animationController.forward(from: 0);
          }
        }
        );
  }

  Future<void> notifyAnimFinished() async{
    return Future<void>.delayed(const Duration(milliseconds: 50),
            (){
              ongoingAnimation = false;
        }
    );
  }

}
