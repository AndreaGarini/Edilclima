
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../DataClasses/PngStackLogic.dart';
import '../../GameModel.dart';

class GameBoardPngExampleStack extends StatefulWidget{

  double imageHeight;
  double imageWidth;
  String team;
  GameBoardPngExampleStack(this.imageHeight, this.imageWidth, this.team);

  @override
  State<StatefulWidget> createState() => GameBoardPngExampleStackState();
}

class GameBoardPngExampleStackState extends State<GameBoardPngExampleStack> {

  late bool stackBuilded;
  late List<Widget> stackChildren;
  PngStackLogic pngLogic = PngStackLogic();

  @override
  void initState() {
    super.initState();
    stackBuilded = false;
    List<Widget> pngList =pngLogic.setPngStackFromLevel(1)
        .map((e) => Image.asset(e, height: widget.imageHeight, width: widget.imageWidth)).toList();
    stackChildren = pngList;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {
      return Stack(
        alignment: Alignment.center,
        children: stackChildren,
      );
    });
  }
}
