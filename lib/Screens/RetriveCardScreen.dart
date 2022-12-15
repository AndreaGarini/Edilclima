
import 'package:edilclima_app/Components/RetriveCardPagerLayout/RetriveCardPager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';

class RetriveCardScreen extends StatefulWidget{

  @override
  State<RetriveCardScreen> createState() => RetriveCardScreenState();

}

class RetriveCardScreenState extends State<RetriveCardScreen>{

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child) {

    return Expanded(child: Center(child: RetriveCardPager(gameModel.gameLogic.months.length)));

  });
  }
}