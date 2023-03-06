
import 'package:collection/collection.dart';
import 'package:edilclima_app/Components/generalFeatures/ShinyContent.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:flutter/material.dart';

import '../../Screens/WaitingScreen.dart';
import 'ColorPalette.dart';

class MidRankingDialog extends StatelessWidget{

  int lv;
  Map<String, int> pointsMap;
  Function closeDialogCallback;

  MidRankingDialog(this.lv, this.pointsMap, this.closeDialogCallback);


  //todo: se è l'ultimo livello chiudi la partita
  Widget midRankingCard (String team, int points) {
    return Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.15,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(screenHeight * 0.02)),
            color: Colors.white,
            boxShadow: [ BoxShadow(
              color: darkGreyPalette.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 0), // changes position of shadow
            )]),
        child: Card(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)),
        elevation: 3,
        color: backgroundGreen,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: Center(child: Text(team, style:
                  TextStyle(color: darkBluePalette,
                    fontWeight: FontWeight.normal,
                    fontSize: screenWidth * 0.06,
                  ), textAlign: TextAlign.justify))),
                  Expanded(child: Center(child:
                  ShinyContent(Text(points.toString(), style:
                  TextStyle(color: darkBluePalette,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                  ),textAlign: TextAlign.justify), darkBluePalette, true)))
                ])),
            Expanded(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Spacer(),
                  Expanded(child: Center(child: Text("points", style:
                  TextStyle(color: darkBluePalette,
                    fontWeight: FontWeight.normal,
                    fontSize: screenWidth * 0.04,
                  ), textAlign: TextAlign.justify)))
                ]))
          ])
    ));
  }

  List<Widget> createContent (int lv, Map<String, int> pointsMap, BuildContext context){
    List<Widget> content = [
      SizedBox(width: screenWidth * 0.6, height: screenHeight * 0.05,
          child: Center(child: Text("Classifica provvisoria : ",
              style: TextStyle(color: darkBluePalette, fontSize: screenWidth * 0.05, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center))),
      Divider(indent: screenWidth * 0.1, endIndent: screenWidth * 0.1, color: darkBluePalette, thickness: 2),
      SizedBox(width: screenWidth * 0.6, height: screenHeight * 0.05),
    ];

    for (final entry in pointsMap.entries.sortedBy<num>((element) => element.value)){
      content.add(midRankingCard(entry.key, entry.value));
    }

    content.add(SizedBox(width: screenWidth * 0.6, height: screenHeight * 0.2,
        child: Center(child: SizedButton(screenWidth * 0.3, "Avanti", () {
          print("button callback");
          closeDialogCallback(null);
          Navigator.of(context).pop();
        }))));

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return  ListView(
        padding: const EdgeInsets.all(8),
    shrinkWrap: true,
    children: createContent(lv, pointsMap, context));
  }

  }