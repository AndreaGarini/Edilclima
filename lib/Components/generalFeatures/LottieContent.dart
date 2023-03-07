
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LottieContent extends StatefulWidget{

  String asset;
  bool animate;
  LottieContent(this.asset, this.animate);

  @override
  LottieContentState createState() => LottieContentState();
}

class LottieContentState extends State<LottieContent>
    with SingleTickerProviderStateMixin{

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    if(!widget.animate) {
      controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.animate) {
      return Lottie.asset(widget.asset, controller: controller, onLoaded: (composition) {
        controller
          ..duration = composition.duration
          ..forward()
          ..repeat(reverse: true);
      });
    }
    else{
      return Lottie.asset(widget.asset, controller: controller);
    }
  }
}