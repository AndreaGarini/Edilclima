
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
    with TickerProviderStateMixin{

  late TabController tabController;
  late AnimationController ptsAnimController;
  late bool triggerPtsAnim;
  late String? animText;
  late Color? animColor;
  Function? playedCardCallback;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.cardListLength, vsync: this);
    triggerPtsAnim = true;
    animText = "";
    animColor = Colors.red;
    ptsAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState((){
          triggerPtsAnim = false;
        });
      }
    })..addListener(() {
      setState((){

      });
    });
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

      WidgetsBinding.instance?.addPostFrameCallback((_){
        if(playedCardCallback==null){
          playedCardCallback = (String cardCode, String month) {
            String response = gameModel.gameLogic.evaluateSingleCard(gameModel.playerLevelCounter, month, cardCode);
            setState(() {
              animText = response;
              switch(response){
                case "Non male": {
                  animColor = Colors.red;
                } break;
                case "Ok": {
                  animColor = Colors.amber;
                } break;
                case "Bene": {
                  animColor = Colors.green;
                } break;
              }
              triggerPtsAnim = true;
              ptsAnimController.forward(from: 0);
            });
          };
        }
      });


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
           Expanded(flex: 3, child:
               triggerPtsAnim ?
               Stack(alignment: Alignment.center, children: [
                 TabBarView(controller: tabController,
                 children: generateBarChildren(gameModel)),
                 Positioned(top: screenHeight * 0.2 * (1 - (ptsAnimController.value * 0.8)), right: screenWidth * 0.05,
                 child: Text(animText!= null ? animText! : "",
                     style: TextStyle(fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: animColor!.withOpacity(1 - (ptsAnimController.value * 0.5)))))]) :
               TabBarView(controller: tabController,
                 children: generateBarChildren(gameModel))
           )]);
      });
    }

    List<Widget> generateBarChildren(GameModel gm){
     Map<String, String> playedCardsCodes = {};
     gm.playedCardsPerTeam[gm.team]!.forEach((key, value) {
       playedCardsCodes.putIfAbsent(key, () => value.code);
     });

     return gm.gameLogic.months.map((e) => PageLayout(gm.gameLogic.findCard(playedCardsCodes[e] ?? "null",
         gm.playerContextCode!, gm.playerLevelCounter), gm.gameLogic.months.indexOf(e),
         playedCardCallback!=null ? playedCardCallback! : (){})).toList();
    }
  }











