
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../../DataClasses/CardData.dart';

class DetailedCardLottie extends StatefulWidget{

  cardType type;
  DetailedCardLottie(this.type);

  @override
  State<StatefulWidget> createState() => DetailedCardLottieState();

}

class DetailedCardLottieState extends State<DetailedCardLottie> {

  late bool lottieLoaded;
  late Widget lottieWidget;

  @override
  void initState() {
    super.initState();
    lottieLoaded = false;
  }

  @override
  Widget build(BuildContext context) {

    switch (widget.type){
      case cardType.Energy: {
        lottieWidget = Lottie.asset('assets/animations/solarpanel.json',
            animate: false);
      }
      break;
      case cardType.Pollution: {
        lottieWidget = Lottie.asset('assets/animations/55131-grow-your-forest.json',
            animate: false);
      }
      break;
      case cardType.Research: {
        lottieWidget = Lottie.asset('assets/animations/100337-research-lottie-animation.json',
            animate: false);
      }
      break;
    }


      return  Expanded(flex: 3, child: lottieWidget);
  }
}
