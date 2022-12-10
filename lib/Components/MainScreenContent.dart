
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';
import 'BottomNavBar.dart';
import 'infoRow.dart';

class MainScreenContent extends StatefulWidget{

  Widget child;
  MainScreenContent(this.child);

  @override
  State<MainScreenContent> createState() => MainScreenContentState();

}

class MainScreenContentState extends State<MainScreenContent>{


  //todo: qui aggiungere la showDialog
  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {
      return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: infoRow(gameModel.push)),
            Expanded(flex: 5, child: widget.child)
          ],),
        bottomNavigationBar: BottomNavBar(context),
      );
    });
  }
}