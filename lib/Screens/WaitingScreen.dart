
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../Components/generalFeatures/AnimatedGradient.dart';

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

    return Material(color: Colors.white, child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Spacer(),
          Expanded(flex: 2, child: Center(child: AnimatedGradient("Edilclima", screenHeight * 0.12, 5200, 'Inspiration', true))),
          const Spacer(),
          Expanded(flex : 7, child: Lottie.asset('assets/animations/WaitingScreenHome.json')),
          Expanded(flex: 1, child: Center(child: StylizedText(darkBluePalette, "Chi sei?", screenWidth * 0.08, FontWeight.normal))),
          Divider(indent: screenWidth * 0.3, endIndent: screenWidth * 0.3, color: darkBluePalette, thickness: 2,),
          const Spacer(),
          Expanded(flex: 1, child: SizedButton(screenWidth * 0.6, "Il master", () {context.push("/initialScreen/matchMakingScreen");})),
          const Spacer(),
          Expanded(flex: 1, child: SizedButton(screenWidth * 0.6, "Un giocatore", () {context.push("/initialScreen/cameraScreen");})),
          const Spacer(),
        ],
      ),);
  }
}