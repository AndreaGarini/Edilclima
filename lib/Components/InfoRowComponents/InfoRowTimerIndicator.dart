
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';
import '../../Screens/WaitingScreen.dart';

class InfoRowTimerIndicator extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => InfoRowTimerIndicatorState();
}

class InfoRowTimerIndicatorState extends State<InfoRowTimerIndicator>
  with SingleTickerProviderStateMixin{

  late AnimationController indicatorController;
  late bool timerBeginSetted;
  late double timerBegin;
  late int timerDuration;

  @override
  void initState() {
    super.initState();
    timerBeginSetted = false;
    indicatorController = AnimationController(vsync: this, duration: const Duration(seconds: 63));
  }

  @override
  void dispose(){
    super.dispose();
    indicatorController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child){

        if(gameModel.playerTimerCountdown==null || (gameModel.playerTimerCountdown != null && gameModel.playerTimerCountdown! > 60)){
          return const Text("");
        }
        else{

          if(!timerBeginSetted){
            timerBeginSetted = true;
            timerBegin = gameModel.playerTimerCountdown!/62;
            timerDuration = (62 * timerBegin).toInt();
          }

          return TweenAnimationBuilder<double>(duration: const Duration(seconds: 63),
              curve: Curves.easeInOut,
              tween: Tween<double>(
                  begin: timerBegin,
                  end: 0
              ),
              builder: (context, value, _) {
                var colorAnim = ColorTween(begin: Colors.green, end: Colors.red).animate(indicatorController);
                indicatorController.value = 1 - value;
                return LinearProgressIndicator(value: value, valueColor:  colorAnim, minHeight: screenHeight * 0.03,);
              });
        }

    });
  }

}