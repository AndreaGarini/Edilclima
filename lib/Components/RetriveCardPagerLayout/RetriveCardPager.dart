
import 'package:edilclima_app/Components/PlayCardPagerLayout/TabLayout.dart';
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLayout.dart';
import 'package:edilclima_app/Components/RetriveCardPagerLayout/RetrivePageLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';

class RetriveCardPager extends StatefulWidget{

  //todo: le carte vanno rese scrollable perchè il testo non è detto che ci stia
  //todo : aggiungi un'animazione per il retrive card
  int cardListLength;

  RetriveCardPager(this.cardListLength);

  @override
  State<StatefulWidget> createState() => RetriveCardPagerState();

}

class RetriveCardPagerState extends State<RetriveCardPager>
  with SingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.cardListLength, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {
      List<Widget> tabsChildren = gameModel.gameLogic.months.map((e) =>
          TabLayout(e)).toList();

      return Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(flex: 1, child:
              Material(color: darkBluePalette,
              child:
              TabBar(tabs: tabsChildren,
                controller: tabController,
                isScrollable: true,
                indicatorColor: midColorPalette,
                labelColor: midColorPalette,
                indicatorWeight: screenHeight * 0.008,
                unselectedLabelColor: lightBluePalette,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero))),
              Expanded(flex: 7, child: TabBarView(controller: tabController,
                  children: gameModel.gameLogic.months.map((e) =>
                      RetrivePageLayout(gameModel.gameLogic.months.indexOf(e)))
                      .toList()))
            ]);
    });
  }
}