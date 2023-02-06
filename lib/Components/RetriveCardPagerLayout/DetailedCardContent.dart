
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLottie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../DataClasses/CardData.dart';
import '../../Screens/WaitingScreen.dart';
import '../generalFeatures/ColorPalette.dart';
import '../generalFeatures/StylizedText.dart';
import 'VerticalStatsCard.dart';

class DetailedCardContent extends StatelessWidget{

  CardData cardData;
  String bodyText;
  late Widget lottieWidget;

  DetailedCardContent(this.cardData, this.bodyText);

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: screenHeight),
              child:
              IntrinsicHeight(
                child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 1, child: Center(child: StylizedText(darkBluePalette, cardData!.code, screenWidth * 0.3, FontWeight.bold))),
                    Divider(indent: screenWidth * 0.2, endIndent: screenWidth * 0.2, color: darkBluePalette, thickness: 1),
                    DetailedCardLottie(cardData.type),
                    Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                          const Spacer(),
                          Expanded(flex: 8, child: VerticalStatsCard("comfort", cardData!.comfort)),
                          const Spacer(),
                          Expanded(flex: 8, child: VerticalStatsCard("money", cardData!.money)),
                          const Spacer()
                        ])),
                    Expanded(flex: 2, child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, children: [
                          const Spacer(),
                          Expanded(flex: 8, child: VerticalStatsCard("smog", cardData!.smog)),
                          const Spacer(),
                          Expanded(flex: 8, child: VerticalStatsCard("energy", cardData!.energy)),
                          const Spacer()
                        ])),
                    Divider(indent: screenWidth * 0.2, endIndent: screenWidth * 0.2, color: darkBluePalette, thickness: 1),
                    Expanded(flex: 6, child:
                    Card(color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenHeight * 0.02)),
                        shadowColor: backgroundGreen,
                        elevation: 1,
                        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    const Spacer(),
                                    Expanded(flex: 6, child: Text(bodyText, style: TextStyle(color: darkBluePalette,
                                      fontSize: screenWidth * 0.03,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Roboto',),
                                        textAlign: TextAlign.justify)),
                                    const Spacer()
                                  ])
                            ])
                    )),
                  ],
                ),
              )
          )
      );
  }

}