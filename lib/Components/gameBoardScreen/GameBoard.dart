import 'package:edilclima_app/Components/gameBoardScreen/GameBoardDynamicTitle.dart';
import 'package:edilclima_app/Components/gameBoardScreen/GameBoardInfoCircle.dart';
import 'package:edilclima_app/Components/generalFeatures/MasterTutorialFeatures.dart';
import 'package:edilclima_app/DataClasses/DialogData.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/LevelEndedStats.dart';
import '../../GameModel.dart';
import '../generalFeatures/AnimatedGradient.dart';
import 'GameBoardCard.dart';

class GameBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  late double shortDim;
  late bool tutorialOpened;
  DialogData? lastDialogData;
  late Function closeMasterTutorialDialog;
  late List<Widget> columnContent;
  late List<GameBoardCard> cardsWidgets = [];
  late double usableCardHeight;
  late bool boardCardsCreated;
  late double cardHeight;
  GameBoardDynamicTitle? titleWidget;

  //todo: scopri come creare una dialog più stretta e riordina lo spazio di conseguenza (se no crea stack e positioned)

  @override
  void initState() {
    super.initState();
    shortDim = 0;
    tutorialOpened = false;
    cardHeight = 0;
    usableCardHeight = 0;
    columnContent = [];
    boardCardsCreated = false;
  }

  @override
  Widget build(BuildContext parentContext) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {

        gameModel.gameBoardLevelCallback ??= levelEndedCallback;

        var newDim = screenHeight > screenWidth ? screenWidth : screenHeight;
        if (newDim != shortDim) {
          setShortDim(newDim);
        }

        if (!tutorialOpened) {
          tutorialOpened = true;
          gameModel.masterTutorialDoneCheck().then((value) {
            if (!value) {
              openMasterTutorialDialog(gameModel);
            }
          });
        }
      });

      closeMasterTutorialDialog = () {
        gameModel.setMasterTutorialDone();
        gameModel.setDialogData(null);
      };

      if (gameModel.showDialog == null && lastDialogData != null) {
        lastDialogData = null;
        Navigator.of(context).pop();
      }

      if (gameModel.showDialog != null &&
          gameModel.showDialog != lastDialogData) {
        setDialogAvailable(parentContext, gameModel.showDialog!, gameModel);
      }

      cardHeight = shortDim / 2;
      if (cardHeight != usableCardHeight) {
        setUsableCardHeight(cardHeight);
      }

      if (!boardCardsCreated && usableCardHeight != 0) {
        List<Widget> cards = [];

        for (int i = 0; i < gameModel.teamsNum; i++){
          cardsWidgets.add(GameBoardCard(
              gameModel.teamsNames[i],
              gameModel
                  .objectivePerTeam[gameModel.teamsNames[i]]!,
              cardHeight));
        }

        switch (gameModel.teamsNum) {
          case 1:
            {
              cards.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: cardsWidgets[0]),
                    const Spacer()
                  ])));
              cards.add(const Spacer());
            }
            break;
          case 2:
            {
              cards.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child:cardsWidgets[0]),
                    Expanded(
                        child: cardsWidgets[1])
                  ])));
              cards.add(const Spacer());
            }
            break;
          case 3:
            {
              cards.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: cardsWidgets[0]),
                    Expanded(
                        child: cardsWidgets[1])
                  ])));
              cards.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: cardsWidgets[2]),
                    const Spacer()
                  ])));
            }
            break;
          case 4:
            {
              cards.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: cardsWidgets[0]),
                    Expanded(
                        child: cardsWidgets[1])
                  ])));
              cards.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: cardsWidgets[2]),
                    Expanded(
                        child: cardsWidgets[3])
                  ])));
            }
            break;
        }
        setColumnContent(cards);
      }

      return Stack(alignment: Alignment.center, children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: columnContent),
        GameBoardInfoCircle(screenHeight, killLevelEndedSequence),
        Positioned(top : screenHeight * 0.4, child: titleWidget ?? const SizedBox())
      ]);
    });
  }

  Future<void> openDialog(
      BuildContext context, DialogData data, GameModel gameModel) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          if (data.autoExpire) {
            Future.delayed(const Duration(seconds: 2), () {
              if (gameModel.tutorialOngoing) {
                gameModel.endTutorialAndNotify();
              }
              gameModel.setDialogData(null);
              Navigator.of(context).pop();
            });
            return Dialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Center(
                    child: AnimatedGradient(data.title, screenWidth * 0.4, 1500,
                        'Inspiration', false)));
          } else {
            return Dialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 10,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Expanded(flex: 10, child: data.body!),
                                const Spacer()
                              ],
                            ))
                      ],
                    )));
          }
        });
  }

  Future<void> setShortDim(double newDim) {
    return Future<void>.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        shortDim = newDim;
      });
    });
  }

  Future<void> setUsableCardHeight(double cardHeight) {
    return Future<void>.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        usableCardHeight = cardHeight;
        boardCardsCreated = false;
      });
    });
  }

  Future<void> setColumnContent(List<Widget> cardsWidget) {
    return Future<void>.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        columnContent = cardsWidget;
        boardCardsCreated = true;
      });
    });
  }

  Future<void> setDialogAvailable(
      BuildContext parentContext, DialogData data, GameModel gameModel) async {
    return Future<void>.delayed(const Duration(milliseconds: 1), () {
      openDialog(parentContext, data, gameModel);
      lastDialogData = data;
    });
  }

  Future<void> openMasterTutorialDialog(GameModel gameModel) {
    return Future.delayed(const Duration(milliseconds: 50), () {
      DialogData data = DialogData(
          "Tutorial", MasterTutorialFeatures(closeMasterTutorialDialog), false);
      gameModel.setDialogData(data);
    });
  }

  Future<void> levelEndedCallback(int level, int lastLevel, Map<String, LevelEndedStats> map) {
    return Future.delayed(const Duration(milliseconds: 50), () {
     setState((){
       if(level == lastLevel){
          titleWidget = GameBoardDynamicTitle("Fine partita");
        }
       else {
         titleWidget = GameBoardDynamicTitle("Intermezzo");
        }
     });
     Future.delayed(const Duration(milliseconds: 3000), () {
       for (var element in cardsWidgets) {
         Future.delayed(Duration(milliseconds: 6000 * cardsWidgets.indexOf(element)), () {
           if(element.startCrdCallback != null){
             element.startCrdCallback!(map);
           }
         });
       }
       Future.delayed(Duration(milliseconds: (1000 * cardsWidgets.length)), () {
         titleWidget!.reverseCallback!();
         Future.delayed(const Duration(milliseconds: 3000), () {
           setState(() {
             titleWidget = null;
           });
         });
       });
     });
    });
  }

  void killLevelEndedSequence(){
    for (var element in cardsWidgets) {
      if(element.endCrdCallback != null){
        element.endCrdCallback!();
      }
    }
  }




}
