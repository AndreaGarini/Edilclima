
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../../DataClasses/CardData.dart';
import '../generalFeatures/LottieContent.dart';

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

    switch (widget!.type){
      case cardType.Build: {
        lottieWidget = LottieContent('assets/animations/Muri.json', true);
      }
      break;
      case cardType.Gear: {
        lottieWidget = LottieContent('assets/animations/Impianto.json', true);
      }
      break;
      case cardType.Lights: {
        lottieWidget = LottieContent('assets/animations/Luci.json', true);
      }
      break;
      case cardType.Window: {
        lottieWidget = LottieContent('assets/animations/Finestra.json', true);
      }
      break;
      case cardType.Panels: {
        lottieWidget = LottieContent('assets/animations/Pannelli.json', true);
      }
      break;
    }

      return  Expanded(flex: 3, child: lottieWidget);
  }
}
