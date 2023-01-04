
import 'package:edilclima_app/Components/generalFeatures/AnimatedGradient.dart';
import 'package:edilclima_app/Components/generalFeatures/SizedButton.dart';
import 'package:edilclima_app/DataClasses/DialogData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GameModel.dart';
import '../Screens/WaitingScreen.dart';
import 'BottomNavBar.dart';
import 'infoRow.dart';

class MainScreenContent extends StatefulWidget {

  Widget child;

  MainScreenContent(this.child);

  @override
  State<MainScreenContent> createState() => MainScreenContentState();
}

DialogData? lastDialogData;

class MainScreenContentState extends State<MainScreenContent>{


  @override
  Widget build(BuildContext parentContext) {
    return Consumer<GameModel>(builder: (context, gameModel, child) {

      if(gameModel.showDialog!=null && gameModel.showDialog!=lastDialogData){
        setDialogAvailable(parentContext, gameModel.showDialog!, gameModel);
      }

      return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: infoRow()),
            Expanded(flex: 10, child: widget.child)
          ],),
        bottomNavigationBar:  SizedBox(width: screenWidth, height: screenHeight * 0.1, child: BottomNavBar(context))
      );
    });
  }


  //todo: sistemare lo stile della dialog
  Future<void> openDialog(BuildContext context, DialogData data, GameModel gameModel){

    return showDialog<void>(context: context, builder: (BuildContext context){

      if(!data.addButton)
        {
          Future.delayed(const Duration(seconds: 2), () {
            gameModel.setDialogData(null);
            Navigator.of(context).pop();
          });
          return Dialog(child: Center(child:
            AnimatedGradient(data.title, screenWidth * 0.4, 1500, 'Inspiration', false)));
        }

      else {
        return Dialog(child: Column(mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Row(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(child: Center(child: Text(data.title, style: const TextStyle(color: Colors.black)))),
                const Spacer()
              ],
            )),
            const Spacer(),
            Expanded(flex: 3, child: Row(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(flex: 2, child: Text(data.bodyText!=null ? data.bodyText! : "",
                    style: const TextStyle(color: Colors.black))),
                const Spacer()
              ],
            )),
            const Spacer(),
            data.addButton ? Expanded(flex: 1,
                child: SizedButton(screenWidth * 0.3, data.buttonText!,
                        (){ Navigator.of(context).pop();}))
                : const Spacer()
          ],
        ));
      }
  });
  }

  Future<void> setDialogAvailable(BuildContext parentContext, DialogData data, GameModel gameModel) async{
    return Future<void>.delayed(const Duration(milliseconds: 200),
            () {
      openDialog(parentContext, data, gameModel);
      setState((){ lastDialogData = gameModel.showDialog;});});
  }
}