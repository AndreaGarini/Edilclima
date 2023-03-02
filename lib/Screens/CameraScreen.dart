
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:edilclima_app/Screens/WaitingScreen.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../Components/generalFeatures/StylizedText.dart';
import '../GameModel.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {

  final qrKey = GlobalKey(debugLabel: 'QR');
  bool pushRoute = false;
  late bool qrRead;
  QRViewController? controller;


  @override
  void initState(){
    super.initState();
    qrRead = false;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  void reassemble() async{
    super.reassemble();
    if(Platform.isAndroid){
      //await controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  Widget qrReadScreen(){
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max, children: [
        const Spacer(),
        Expanded(flex: 2, child: Center(child: Icon(Icons.done_all, color: lightOrangePalette, size: screenWidth * 0.6))),
        Expanded(child: StylizedText(darkBluePalette, "Attendi l'inizio della partita", screenWidth * 0.05, FontWeight.normal)),
        const Spacer()
      ],);
  }

  Widget openCameraScreen(GameModel gameModel){
    return   Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(flex: 2, child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("Scannerizza il qr code",
                style: TextStyle(color: darkBluePalette,
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.normal)),
            Divider(indent: screenWidth  * 0.1,
                endIndent: screenWidth * 0.1,
                color: darkBluePalette, thickness: 3),
          ],)),
        Expanded(flex: 4, child: QRView(
          key: qrKey,
          onQRViewCreated: (controller){
            setState(() {
              this.controller = controller;
              controller.resumeCamera();
            });

            controller.scannedDataStream.listen((scanData) {
              if(scanData.code!=null){
                gameModel.setFirebasePath(scanData.code!);
                controller.pauseCamera();
                setState(() {
                  qrRead = true;
                });
              }
            });
          },
          overlay: QrScannerOverlayShape(
            cutOutWidth: screenWidth * 0.75,
            cutOutHeight: screenWidth * 0.75,
            borderWidth: screenWidth * 0.03,
            borderLength: screenWidth * 0.1,
            borderRadius: screenWidth * 0.03,
            borderColor: lightOrangePalette,
          ),
        )),
        const Spacer(),
      ],);
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
        if(gameModel.firebasePath!=null && gameModel.firebasePath!.isNotEmpty){
          updateData(gameModel);
        }
        if(gameModel.playerLevelCounter > 0 && !pushRoute){
          if(!pushRoute && !routerCalled){
            pushRoute = true;
            Future.delayed(const Duration(milliseconds: 500),()
            {context.push("/initialScreen/cameraScreen/splashScreen");});
          }
        }
      });

      return qrRead ? qrReadScreen() : openCameraScreen(gameModel);

      return Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: [
            Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                Expanded(flex: 1,
                    child: FittedBox(
                        fit: BoxFit.fill, child: ElevatedButton(onPressed: () {
                          /*gameModel.joinMatch()*/;
                    }, child: Text("join match")))),
                const Spacer()
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