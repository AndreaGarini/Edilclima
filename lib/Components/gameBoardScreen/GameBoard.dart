import 'package:edilclima_app/Components/gameBoardScreen/GameBoardInfoCircle.dart';
import 'package:edilclima_app/Components/generalFeatures/MasterTutorialFeatures.dart';
import 'package:edilclima_app/DataClasses/DialogData.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';
import '../generalFeatures/AnimatedGradient.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/StylizedText.dart';
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
  late double usableCardHeight;
  late bool boardCardsCreated;
  late double cardHeight;

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
        List<Widget> cardsWidgets = [];

        switch (gameModel.teamsNum) {
          case 1:
            {
              cardsWidgets.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[0],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[0]]!,
                            cardHeight)),
                    const Spacer()
                  ])));
              cardsWidgets.add(const Spacer());
            }
            break;
          case 2:
            {
              cardsWidgets.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[0],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[0]]!,
                            cardHeight)),
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[1],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[1]]!,
                            cardHeight))
                  ])));
              cardsWidgets.add(const Spacer());
            }
            break;
          case 3:
            {
              cardsWidgets.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[0],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[0]]!,
                            cardHeight)),
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[1],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[1]]!,
                            cardHeight))
                  ])));
              cardsWidgets.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[2],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[2]]!,
                            cardHeight)),
                    const Spacer()
                  ])));
            }
            break;
          case 4:
            {
              cardsWidgets.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[0],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[0]]!,
                            cardHeight)),
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[1],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[1]]!,
                            cardHeight))
                  ])));
              cardsWidgets.add(Expanded(
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[2],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[2]]!,
                            cardHeight)),
                    Expanded(
                        child: GameBoardCard(
                            gameModel.teamsNames[3],
                            gameModel
                                .objectivePerTeam[gameModel.teamsNames[3]]!,
                            cardHeight))
                  ])));
            }
            break;
        }

        setColumnContent(cardsWidgets);
      }

      return Stack(alignment: Alignment.center, children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: columnContent),
        GameBoardInfoCircle(screenHeight)
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
}
