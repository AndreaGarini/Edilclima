
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

import '../Components/selectCardLayout/NewUndetailedCardLayout.dart';
import '../Components/selectCardLayout/undetailedCardLayout.dart';
import '../GameModel.dart';
import 'WaitingScreen.dart';

class NewCardSelectionScreen extends StatefulWidget{

  @override
  State<NewCardSelectionScreen> createState() => NewCardSelectionState();
}


double parentWidth = 0;
double parentHeight = 0;


String playableCard = "null";
CardData? onFocusCard;

class NewCardSelectionState extends State<NewCardSelectionScreen>
    with TickerProviderStateMixin {

  late PageController pageController;
  List<Widget> cardList = [];
  late int focusIndex;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.75)..addListener(() {
      int index = pageController.page!.round();
      if(focusIndex!=index){
        setState((){
          focusIndex = index;
        });
      }
    });

    focusIndex = 0;
    }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

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
                        PageView.builder(
                            onPageChanged: (index){
                              playableCard = gameModel.playerCards[index].code;
                            },
                            clipBehavior: Clip.none,
                            controller: pageController,
                            itemCount: gameModel.playerCards.length,
                            itemBuilder: (context, int index){
                          bool onFocus = index == focusIndex;
                          return NewUndetailedCardLayout(onFocus, gameModel.playerCards[index]);
                      })
                    ),
                  ]
              ),
              InkWell(
                  onTap: (){
                    onFocusCard = gameModel.playerCards[focusIndex];
                    print("on focus card: ${gameModel.playerCards[focusIndex].code}");
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

}
