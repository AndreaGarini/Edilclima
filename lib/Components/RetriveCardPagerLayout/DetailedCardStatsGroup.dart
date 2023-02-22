import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';

import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import 'VerticalStatsCard.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class DetailedCardStatsGroup extends StatefulWidget{

  CardData cardData;
  CardData baseCardData;
  Map<String, Map<String, String>> cardInfData;
  DetailedCardStatsGroup(this.cardData, this.baseCardData, this.cardInfData);

  @override
  State<StatefulWidget> createState() => DetailedCardStatsGroupState();

}

class DetailedCardStatsGroupState extends State<DetailedCardStatsGroup>
  with TickerProviderStateMixin{

  Offset iconShiftUp = Offset(screenWidth * 0.185, -screenHeight * 0.085);
  Offset iconShiftDown = Offset(screenWidth * 0.185, screenHeight * 0.055);
  double textYShiftFromIcon = screenHeight * 0.052;
  double cardYShiftFromIcon =  screenHeight * 0.016;

  Offset finalIconShift = Offset(-screenWidth * 0.23, -screenHeight * 0.085);
  Offset finalTextShift = Offset(-screenWidth * 0.045, -screenHeight * 0.085);

  double cardSizeDeltaX = screenWidth * 0.38;
  double cardSizeDeltaY = screenHeight * 0.25;



  bool triggerAnim = false;
  late AnimationController controller;
  Map<String, Matrix4Tween> animMap = {};
  Widget? iconWidget;
  String? textWidget;
  int? valueWidget;
  List<Widget>? statInfoRows;
  bool animCompleted = false;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        setState((){
          animCompleted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if(triggerAnim){
        return Stack(alignment: Alignment.center, children: [
          AnimatedBuilder(animation: controller, builder: (context, child) =>
          Transform(transform: animMap["Card"]!.evaluate(controller),
          child:
          SizedBox(height: screenHeight * 0.14 + cardSizeDeltaY * controller.value,
              width: screenWidth * 0.33 + cardSizeDeltaX * controller.value,
          child: Card(
              color: Colors.white,
              shadowColor: lightOrangePalette,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.02)))))),
          AnimatedBuilder(animation: controller, builder: (context, child) =>
              Transform(transform: animMap["Icon"]!.evaluate(controller),
              child:
              Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.1)),
                      color: backgroundGreen,
                      boxShadow: [ BoxShadow(
                        color: lightBluePalette.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 0), // changes position of shadow
                      )]),
                  child: iconWidget))),
          AnimatedBuilder(animation: controller, builder: (context, child) =>
          Transform(transform: animMap["Text"]!.evaluate(controller),
          child:
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(textWidget!, style: TextStyle(color: darkBluePalette,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto',),
                    textAlign: TextAlign.justify),
                Text(valueWidget.toString(), style: TextStyle(color: darkBluePalette,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',),
                    textAlign: TextAlign.justify)]),
          ))),
          (animCompleted && statInfoRows!=null) ? Positioned(top: screenHeight * 0.1, left: screenWidth * 0.11,
              child: Container( width: screenWidth * 0.6, height: screenHeight * 0.15, color: Colors.white,
              child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center, children: statInfoRows!))) : const SizedBox(),
           animCompleted ? Positioned(top: screenHeight * 0.015, right: screenWidth * 0.07,
           child:
           InkWell(
             onTap: (){
               setState((){
                 animCompleted = false;
               });
               controller.reverse(from: 1);
               setTriggerAnimFalse();
             },
             child:
             Container(width: screenWidth * 0.1, height: screenWidth * 0.1,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.2)),
                 color: darkBluePalette),
             child: Icon(Icons.cancel_outlined, size: screenWidth * 0.08, color: Colors.white)),
           )) : const SizedBox()
        ]);
    }

    else{
      return
        Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Spacer(),
                  Expanded(flex: 8, child:
                  InkWell(
                      onTap: (widget.cardData.comfort != widget.baseCardData.comfort) ? (){
                       setState(() {
                         triggerAnim = true;
                         animMap = generateMatrix4Anim("comfort");
                         iconWidget = generateIconWidget("comfort");
                         textWidget = "Comfort: ";
                         valueWidget = widget.cardData.comfort;
                         bool statsUp = widget.cardData.comfort > widget.baseCardData.comfort;
                         statInfoRows = generateStatInfoRows("comfort", statsUp);
                       });
                       controller.forward(from: 0);
                      } : null,
                      child: VerticalStatsCard("comfort", widget.cardData.comfort, widget.baseCardData.comfort))),
                  const Spacer(),
                  Expanded(flex: 8, child:
                  InkWell(
                      onTap: (widget.cardData.money != widget.baseCardData.money) ? (){
                        setState((){
                          triggerAnim = true;
                          animMap = generateMatrix4Anim("money");
                          iconWidget = generateIconWidget("money");
                          textWidget = "Cost: ";
                          valueWidget = widget.cardData.money;
                          bool statsUp = widget.cardData.money > widget.baseCardData.money;
                          statInfoRows = generateStatInfoRows("money", statsUp);
                        });
                        controller.forward(from: 0);
                      } : null,
                      child: VerticalStatsCard("money", widget.cardData.money, widget.baseCardData.money))),
                  const Spacer()
                ])),
            Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Spacer(),
                  Expanded(flex: 8, child:
                  InkWell(
                      onTap: (widget.cardData.smog != widget.baseCardData.smog) ? (){
                        setState((){
                          triggerAnim = true;
                          animMap = generateMatrix4Anim("smog");
                          iconWidget = generateIconWidget("smog");
                          textWidget = "Smog: ";
                          valueWidget = widget.cardData.smog;
                          bool statsUp = widget.cardData.smog < widget.baseCardData.smog;
                          statInfoRows = generateStatInfoRows("smog", statsUp);
                        });
                        controller.forward(from: 0);
                      } : null,
                      child: VerticalStatsCard("smog", widget.cardData.smog, widget.baseCardData.smog))),
                  const Spacer(),
                  Expanded(flex: 8, child:
                  InkWell(
                      onTap: (widget.cardData.energy != widget.baseCardData.energy) ? (){
                        if(widget.cardData.code== "inv01"){
                          print("card data energy: ${widget.cardData.energy}");
                          print("card data base energy: ${widget.baseCardData.energy}");
                        }
                        setState((){
                          triggerAnim = true;
                          animMap = generateMatrix4Anim("energy");
                          iconWidget = generateIconWidget("energy");
                          textWidget = "Energy: ";
                          valueWidget = widget.cardData.energy;
                          bool statsUp = widget.cardData.comfort > widget.baseCardData.comfort;
                          statInfoRows = generateStatInfoRows("energy", statsUp);
                        });
                        controller.forward(from: 0);
                      } : null,
                      child: VerticalStatsCard("energy", widget.cardData.energy, widget.baseCardData.energy))),
                  const Spacer()
                ]))
          ]);
    }
  }

  Map<String, Matrix4Tween> generateMatrix4Anim(String animCode){

    double defIconShiftX = 0;
    double defIconShiftY = 0;
    double defTextShiftX= 0;
    double defTextShiftY = 0;
    double defCardShiftX= 0;
    double defCardShiftY = 0;

    switch(animCode){
      case "smog" : {
        defIconShiftX = -iconShiftDown.dx;
        defIconShiftY = iconShiftDown.dy;
        defTextShiftX= -iconShiftDown.dx;
        defTextShiftY = iconShiftDown.dy + textYShiftFromIcon;
        defCardShiftX= -iconShiftDown.dx;
        defCardShiftY = iconShiftDown.dy + cardYShiftFromIcon;
      }
      break;
      case "comfort" : {
        defIconShiftX = -iconShiftUp.dx;
        defIconShiftY = iconShiftUp.dy;
        defTextShiftX= -iconShiftUp.dx;
        defTextShiftY = iconShiftUp.dy + textYShiftFromIcon;
        defCardShiftX= -iconShiftUp.dx;
        defCardShiftY = iconShiftUp.dy + cardYShiftFromIcon;
      }
      break;
      case "energy" : {
        defIconShiftX = iconShiftDown.dx;
        defIconShiftY = iconShiftDown.dy;
        defTextShiftX= iconShiftDown.dx;
        defTextShiftY = iconShiftDown.dy + textYShiftFromIcon;
        defCardShiftX= iconShiftDown.dx;
        defCardShiftY = iconShiftDown.dy + cardYShiftFromIcon;
      }
      break;
      case "money" : {
        defIconShiftX = iconShiftUp.dx;
        defIconShiftY = iconShiftUp.dy;
        defTextShiftX= iconShiftUp.dx;
        defTextShiftY = iconShiftUp.dy + textYShiftFromIcon;
        defCardShiftX= iconShiftUp.dx;
        defCardShiftY = iconShiftUp.dy + cardYShiftFromIcon;
      }
      break;
    }

    Matrix4 startingIconMatrix = Matrix4.identity()..setTranslation(vector.Vector3(defIconShiftX, defIconShiftY, 0));
    Matrix4 endingIconMatrix = Matrix4.identity()..setTranslation(vector.Vector3(finalIconShift.dx, finalIconShift.dy, 0));
    Matrix4 startingTextMatrix = Matrix4.identity()..setTranslation(vector.Vector3(defTextShiftX, defTextShiftY, 0));
    Matrix4 endingTextMatrix = Matrix4.identity()..setTranslation(vector.Vector3(finalTextShift.dx, finalTextShift.dy, 0));
    Matrix4 startingCardMatrix = Matrix4.identity()..setTranslation(vector.Vector3(defCardShiftX, defCardShiftY, 0));
    Matrix4 endingCardMatrix = Matrix4.identity();

    Matrix4Tween iconMatrixAnim = Matrix4Tween(begin: startingIconMatrix, end: endingIconMatrix);
    Matrix4Tween textMatrixAnim =  Matrix4Tween(begin: startingTextMatrix, end: endingTextMatrix);
    Matrix4Tween cardMatrixAnim =  Matrix4Tween(begin: startingCardMatrix, end: endingCardMatrix);

    return {
      "Icon" : iconMatrixAnim,
      "Text" : textMatrixAnim,
      "Card" : cardMatrixAnim
    };

  }

  Widget? generateIconWidget(String iconCode){

    switch(iconCode){
      case "smog" : {
        return Icon(Elusive.leaf,
            color: lightOrangePalette,
            size: screenWidth * 0.075);
      }
      case "energy" :
        {
          return Icon(Elusive.lightbulb,
              color: darkBluePalette,
              size: screenWidth * 0.075);
        }
      case "comfort" : {
        return Icon(Icons.home,
            color: lightBluePalette,
            size: screenWidth * 0.075);
      }
      case "money" : {
        return Icon(ModernPictograms.dollar,
            color: darkOrangePalette,
            size: screenWidth * 0.075);
      }
      default: {
        return null;
      }
    }

  }

  List<Widget> generateStatInfoRows(String statCode, bool statsUp) {

    double containerWidth = screenWidth * 0.6;
    List<Widget> avatarNerfList = [const Spacer()];
    List<Widget> avatarUpList = [const Spacer()];

    Map<String, String> ctxInfMsg = {"C01" : "Città", "C02": "Nord", "C03": "Sud"};

    for(final rowEntry in widget.cardInfData!["Nerf"]!.entries){
      String message = "";
      String infType = "";
      switch(rowEntry.key){
        case "Ctx": {
          if(statCode!="money"){
            infType = ctxInfMsg.entries.where((element) => element.key==rowEntry.value).single.value;
            if(infType=="Città"){
              message = "Perchè in ";
            }
            else{
              message = "Perchè al ";
            }
          }
        }
        break;
        case "Zone": {
          if(statCode == "money"){
            message = "Perchè in ";
            infType = rowEntry.value;
          }
        }
        break;
        case "Win": {
          if(statCode=="comfort"){
            message = "Perchè in ";
            infType = "Inverno";
          }
        }
        break;
      }

      if(message!="" && infType!=""){
        avatarNerfList.add(Expanded(flex: 8, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.1)),
                      color: backgroundGreen,
                      boxShadow: [ BoxShadow(
                        color: Colors.redAccent.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 0), // changes position of shadow
                      )]),
                  child: const Icon(Icons.arrow_downward, color: Colors.redAccent,)),
              SizedBox(width: containerWidth * 0.05),
              SizedBox(width: containerWidth * 0.7, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end, children: [Text(message, style: TextStyle(color: darkBluePalette,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',),
                      textAlign: TextAlign.justify),
                    Text(infType, style: TextStyle(color: Colors.redAccent,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',),
                        textAlign: TextAlign.justify)])),
              const Spacer()
            ])));
        avatarNerfList.add(const Spacer());
      }
    }


    for(final rowEntry in widget.cardInfData!["Up"]!.entries){
      String message = "";
      String infType = "";
      if(statCode!="money"){
        print("statCode: $statCode");
        switch(rowEntry.key){
          case "Ctx" : {
            print("ctx ");
            infType = ctxInfMsg.entries.where((element) => element.key==rowEntry.value).single.value;
            if(infType=="Città"){
              message = "Perchè in ";
            }
            else{
              message = "Perchè al ";
            }
          }
          break;
          case "Card" : {
            infType = "Carta combo";
            message = "Per ";
          }
          break;
        }
      }

      if(message!="" && infType!=""){
        print("avatarUpList.add");
        avatarUpList.add(Expanded(flex: 8, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.1)),
                      color: backgroundGreen,
                      boxShadow: [ BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 0), // changes position of shadow
                      )]),
                  child: const Icon(Icons.arrow_upward, color: Colors.green)),
              SizedBox(width: containerWidth * 0.05),
              SizedBox(width: containerWidth * 0.7, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end, children: [Text(message, style: TextStyle(color: darkBluePalette,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',),
                      textAlign: TextAlign.justify),
                    Text(infType, style: TextStyle(color: Colors.green,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',),
                        textAlign: TextAlign.justify)])),
              const Spacer()])));
        avatarUpList.add(const Spacer());
      }
    }

    if(statsUp){
      return avatarUpList.take(2).toList();
    }
    else{
      return avatarNerfList.take(2).toList();
    }
  }

  Future<void> setTriggerAnimFalse(){
    return Future.delayed(const Duration(milliseconds: 600), (){
      setState((){
        triggerAnim = false;
      });
    });
  }


}