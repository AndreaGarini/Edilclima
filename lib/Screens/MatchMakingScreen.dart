import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/Components/generalFeatures/StylizedText.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../GameModel.dart';

class MatchMakingScreen extends StatefulWidget {
  @override
  State<MatchMakingScreen> createState() => MatchMakingState();
}

class MatchMakingState extends State<MatchMakingScreen> {

  late bool playShakeAnim;
  late bool matchPrepared;
  late bool matchCreated;
  late String timestamp;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    matchCreated = false;
    playShakeAnim = false;
    matchPrepared = false;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {

      dynamicWidget(bool state) {
        if(state) {
          return  Expanded(flex: 1,
              child: SizedButton(
                  screenWidth * 0.4, "Inizia il match", () {
                context.go("/initialScreen/matchMakingScreen/gameBoardScreen");
              }));
        }
        else {
          return  Expanded(flex: 1,
              child: SizedButton(
                //todo: se premi due volte questo button fai next lvel due volte lato gm e non trova la zone
                  screenWidth * 0.4, "Prepara il match", gameModel.playerCounter==0 ?
                  (){
                    setState((){
                      playShakeAnim = true;
                    });
                  stopShakeAnim();} : () {
                    gameModel.prepareMatch();
                    matchPrepared = true; }));
        }
      }

      return SafeArea(child:
          Material(
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max, children: [
                  matchCreated ? Expanded(child: Center(child: QrImage(
                  //todo: aggiungi qui il path corretto (che devi generare quando si preme crea nuovo match)
                  data: "${gameModel.masterUid!}/$timestamp",
                  size: 280,
                  // You can include embeddedImageStyle Property if you
                  //wanna embed an image from your Asset folder
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(
                      100,
                      100,
                    ),
                  ),
                ))) : const Spacer(),
                Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Expanded(flex: 4,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Spacer(flex: 1),
                                  Expanded(flex: 1,
                                      child: ShakeWidget(
                                        duration: const Duration(milliseconds: 1000),
                                        shakeConstant: ShakeHorizontalConstant1(),
                                        autoPlay: playShakeAnim,
                                        enableWebMouseHover: true,
                                        child: StylizedText(darkBluePalette, "Giocatori connessi : ${gameModel.playerCounter}",
                                            screenWidth * 0.05, FontWeight.normal),
                                      )),
                                  const Spacer(flex: 1)
                                ])),
                            const Spacer()
                          ]
                      )),
                      Expanded(
                        flex: 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Spacer(),
                            Expanded(flex: 2,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Spacer(),
                                  Expanded(flex: 1,
                                      child: SizedButton(
                                          screenWidth * 0.4, "Crea un nuovo match", !matchPrepared ?  () {
                                            String tmp = DateTime.now().millisecondsSinceEpoch.toString();
                                            setState((){
                                              matchCreated = true;
                                              timestamp = tmp;
                                            });
                                        gameModel.createNewMatch(tmp);
                                      } : null )),
                                  const Spacer()
                                ],),),
                            Spacer()
                          ]
                      ),),
                      Expanded(
                        flex: 1, child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Spacer(),
                            Expanded(flex: 2,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Spacer(),
                                  dynamicWidget(gameModel.startMatch),
                                  const Spacer()
                                ],),),
                            const Spacer()
                          ]
                      )),
                    ]))
                ])
          )
      );
    });
  }

  Future<void> stopShakeAnim() async{
    return Future<void>.delayed(const Duration(milliseconds: 1000),
            () {
      setState((){
        playShakeAnim = false;
      });
    });
  }

}