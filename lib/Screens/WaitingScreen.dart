
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';

class WaitingScreen extends StatefulWidget {

  @override
  State<WaitingScreen> createState() => WaitingScreenState();
}

double screenWidth = 0;
double screenHeight = 0;

class WaitingScreenState extends State<WaitingScreen> {

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Material(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          Expanded(flex : 4, child: Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min,
              children: const [
                Spacer(flex: 1),
                Expanded(flex : 2, child: FittedBox(fit: BoxFit.fill, child: Icon(Icons.access_alarm_rounded, color: Colors.orange))),
                Spacer(flex: 1)
              ]),),
          Expanded(flex : 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min,
              children : [
                Spacer(),
                Expanded(flex: 1, child: FittedBox(fit: BoxFit.fill, child: ElevatedButton(onPressed: () {
                  context.go("/matchMakingScreen");
                }, child: Text("Create new match")))),
                Spacer()
              ]),),
          Spacer(),
          Expanded(flex : 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min,
              children : [
                Spacer(),
                Expanded(flex: 1, child: FittedBox(fit: BoxFit.fill, child: ElevatedButton(onPressed: () {
                  context.go("/cameraScreen");
                }, child: Text("join match")))),
                Spacer()
              ]),),
          Spacer(),
        ],
      ));
  }
}