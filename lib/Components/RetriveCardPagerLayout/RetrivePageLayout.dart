
import 'package:edilclima_app/Components/RetriveCardPagerLayout/DetailedCardLayout.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/CardData.dart';
import '../../GameModel.dart';

class RetrivePageLayout extends StatefulWidget {

  CardData? cardData;
  int pos;

  RetrivePageLayout(this.cardData, this.pos);

  @override
  State<StatefulWidget> createState() => RetriveCardLayoutState();

}

class RetriveCardLayoutState extends State<RetrivePageLayout>{

  late bool ableToRetrive;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      ableToRetrive = widget.cardData!=null && gameModel.playerTimer!=null;

      return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DetailedCardLayout(widget.cardData),
        SizedButton(screenWidth * 0.3, "Retrive card",ableToRetrive ? (){gameModel.retriveCardInPos(widget.pos);} : null)
      ],);
    });
  }


}