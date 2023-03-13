
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DataClasses/CardData.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../generalFeatures/ColorPalette.dart';
import 'DetailedCardContent.dart';
import 'DetailedCardLayout.dart';

class RetrieveDetailedCard extends StatefulWidget{


  CardData? cardData;
  CardData? baseCardData;
  Map<String, Map<String, String>>? cardInfData;

  RetrieveDetailedCard(this.cardData, this.baseCardData, this.cardInfData);

  @override
  State<StatefulWidget> createState() => RetrieveDetailedCardState();
}

class RetrieveDetailedCardState extends State<RetrieveDetailedCard>
 with TickerProviderStateMixin{

  late AnimationController controller;
  Matrix4 animFinalMatrix = Matrix4.identity()..setTranslation(vector.Vector3(-screenWidth, 0, 0));
  late Matrix4Tween anim;

  late bool animEnded;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..addListener(() {
      setState(() {});
    });
    anim = Matrix4Tween(begin: Matrix4.identity(), end: animFinalMatrix);
    startAnim();
    animEnded = false;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: (context, child) =>
        Transform(transform: anim.evaluate(controller),
            alignment: Alignment.centerLeft,
            child:
            DetailedCardLayout(widget.cardData, widget.baseCardData, widget.cardInfData)
            ));
  }

  void startAnim() {
    controller.forward();
  }
}