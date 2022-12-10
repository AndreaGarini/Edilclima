import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {

  late GameModel gm;
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      gm.listenToLevelChange();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {
      gm = gameModel;

      if(gameModel.playerLevelCounter > 0){
        context.go("/cardSelectionScreen");
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: [
            Text(gameModel.playerLevelCounter.toString(), style: const TextStyle(color: Colors.white),),
            Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
                Expanded(flex: 1,
                    child: FittedBox(
                        fit: BoxFit.fill, child: ElevatedButton(onPressed: () {
                          gameModel.joinMatch();
                    }, child: Text("join match")))),
                Spacer()
              ],

            )),
            const Spacer()
          ]

      );
    });
  }
}