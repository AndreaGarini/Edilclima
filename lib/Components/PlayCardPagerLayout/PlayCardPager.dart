
import 'package:edilclima_app/Components/MainScreenContent.dart';
import 'package:edilclima_app/Components/PlayCardPagerLayout/PageLayout.dart';
import 'package:edilclima_app/Components/PlayCardPagerLayout/TabLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';

class PlayCardPager extends StatefulWidget{

  int cardListLength;

  PlayCardPager(this.cardListLength);
  @override
  State<PlayCardPager> createState() => PlayCardPagerState();

}

class PlayCardPagerState extends State<PlayCardPager>
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

      List<Widget> tabsChildren = gameModel.gameLogic.months.map((e) => TabLayout(e)).toList();

       return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisSize: MainAxisSize.max, children: [
         Expanded(flex: 1, child:
             Material(color: darkBluePalette,
               child: TabBar(tabs: tabsChildren,
                 indicatorColor: midColorPalette,
                 labelColor: midColorPalette,
                 indicatorWeight: screenHeight * 0.008,
                 unselectedLabelColor: lightBluePalette,
                 controller: tabController,isScrollable: true,
                 padding: EdgeInsets.zero,
                 indicatorPadding: EdgeInsets.zero,
                 labelPadding: EdgeInsets.zero,))),
           Expanded(flex: 3, child: TabBarView(controller: tabController,
                                    children: generateBarChildren(gameModel),))
         ],);
      });
    }

    List<Widget> generateBarChildren(GameModel gm){
     Map<String, String> playedCardsCodes = {};
     gm.playedCardsPerTeam[gm.team]!.forEach((key, value) {
       playedCardsCodes.putIfAbsent(key, () => value.code);
     });

     return gm.gameLogic.months.map((e) => PageLayout(gm.gameLogic.findCard(playedCardsCodes[e] ?? "null",
         gm.playerContextCode!), gm.gameLogic.months.indexOf(e))).toList();
    }
  }











