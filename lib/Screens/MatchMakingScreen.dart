import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';

class MatchMakingScreen extends StatefulWidget {
  @override
  State<MatchMakingScreen> createState() => MatchMakingState();
}

class MatchMakingState extends State<MatchMakingScreen> {


  @override
  Widget build(BuildContext context) {

    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;


    return Material(
      color: backgroundGreen,
        child:
    Consumer<GameModel>(builder: (context, gameModel, child)
    {
      dynamicWidget(bool state) {
        if(state) {
          return  Expanded(flex: 1,
              child: SizedButton(
                  currentWidth * 0.4, "Start match", () {
                context.go("/gameBoardScreen");
              }));
        }
        else {
          return  Expanded(flex: 1,
              child: SizedButton(
                //todo: se premi due volte questo button fai next lvel due volte lato gm e non trova la zone
                  currentWidth * 0.4, "Prepare match", () {
                gameModel.prepareMatch();
              }));
        }
      }


      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: [
            Expanded(
              flex: 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Spacer(),
                  Expanded(flex: 2,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Spacer(),
                        Expanded(flex: 1,
                            child: SizedButton(
                                currentWidth * 0.4, "Create new match", () {
                             gameModel.createNewMatch();
                            })),
                        const Spacer()
                      ],),),
                  Spacer()
                ]
            ),),
            Expanded(
              flex: 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Spacer(),
                  Expanded(flex: 4,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Spacer(flex: 1,),
                        Expanded(flex: 1,
                            child: FittedBox(fit: BoxFit.fitWidth, child:
                            DefaultTextStyle(style: TextStyle(color: Colors
                                .black),
                                child: Text("connected players : ${gameModel.playerCounter}")))),
                        const Spacer(flex: 1,)
                      ],),),
                  Spacer(flex: 2)
                ]
            ),),
            Expanded(
              flex: 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Spacer(),
                  Expanded(flex: 2,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Spacer(),
                        dynamicWidget(gameModel.startMatch),
                        const Spacer()
                      ],),),
                  Spacer()
                ]
            ),),
          ]
      );
    }));
  }

}