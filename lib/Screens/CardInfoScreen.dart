
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/Screens/CardSelectionScreen.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardInfoScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,children: [
            Padding(padding: EdgeInsets.only(
              top: screenHeight * 0.03,
              left: screenWidth * 0.04
            ),
              child: ElevatedButton(onPressed: () {context.go("/cardSelectionScreen");},
                  style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size.fromWidth(screenWidth * 0.1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))
                      ),
                      backgroundColor: MaterialStateProperty.all(lightBluePalette)),
                  child: const Center(child: Icon(Icons.arrow_back_ios, size: 40,))))
          ],)),
        Expanded(flex: 12, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Spacer(),
              Expanded(flex: 8, child: DetailedCardLayout(onFocusCard)),
              const Spacer()
          ])),
        const Spacer()
      ],);
  }


}