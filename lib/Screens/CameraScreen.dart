import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
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

  bool pushRoute = false;
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(child:
        Material(
      color: Colors.white,
        child:
    Consumer<GameModel>(builder: (context, gameModel, child)
    {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        updateData(gameModel);
        if(gameModel.playerLevelCounter > 0 && !pushRoute){
          if(!pushRoute){
            pushRoute = true;
            Future.delayed(const Duration(milliseconds: 500),()
            {context.push("/initialScreen/cameraScreen/splashScreen");});
          }
        }
      });

      return Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: [
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
    })));
  }

  Future<void> updateData(GameModel gm) async{
    return Future<void>.delayed(const Duration(milliseconds: 1), () {gm.listenToLevelChange();});
  }
}