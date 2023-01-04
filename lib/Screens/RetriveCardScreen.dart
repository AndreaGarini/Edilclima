
import 'package:edilclima_app/Components/RetriveCardPagerLayout/RetriveCardPager.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';

class RetriveCardScreen extends StatefulWidget{

  @override
  State<RetriveCardScreen> createState() => RetriveCardScreenState();

}

class RetriveCardScreenState extends State<RetriveCardScreen>{

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

    return Material(color: backgroundGreen,
    child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Center(child: RetriveCardPager(gameModel.gameLogic.months.length)))
      ],));

  });
  }
}