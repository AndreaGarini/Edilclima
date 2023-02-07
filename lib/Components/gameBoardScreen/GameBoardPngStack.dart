
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../GameModel.dart';

class GameBoardPngStack extends StatefulWidget{

  double imageHeight;
  double imageWidth;

   GameBoardPngStack(this.imageHeight, this.imageWidth);

  @override
  State<StatefulWidget> createState() => GameBoardPngStackState();
}

class GameBoardPngStackState extends State<GameBoardPngStack> {

  //todo: considera aggiungere animazioni di entrata
  late List<Widget> pngList;
  late bool stackBuilded;
  late List<Widget> stackChildren;

  @override
  void initState() {
    super.initState();
    stackBuilded = false;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<GameModel>(builder: (context, gameModel, child)
    {
        if(!stackBuilded){
          print("building stack");
          print("master level counter: ${gameModel.gameLogic.masterLevelCounter}");
          List<Widget> pngStack = [];
          for(final path in gameModel.gameLogic.pngMapPerLevel[gameModel.gameLogic.masterLevelCounter]!){
            print("creating stack children");
            pngStack.add(Image.asset(path, width: widget.imageWidth, height: widget.imageHeight));
          }
          stackChildren = pngStack;
          stackBuilded = true;
        }

      // nella callback per evitare il setstate called during build
      //todo: cambia tutti i player level counter con quelli del master
      //todo: cambia tutti i presi dal gameModel con un indice del  team passato nel costruttore

      WidgetsBinding.instance?.addPostFrameCallback((_){
        //null check
        /*if(gameModel.playedCardsPerTeam[gameModel.team]!=null){
          List<String> cardCodeListFromPng = [];
          for(final pngPath in gameModel.gameLogic.pngMapPerLevel[gameModel.playerLevelCounter]!){
            //mi prendo ogni png della lista completa per il livello in corso
            String codeInPngPath = pngPath.split('/')[2].split('.')[0];
            //ogni png si chiama con il code della card, quindi se splitto il path ottengo il cardCode
            if(gameModel.playedCardsPerTeam[gameModel.team]!.values.contains(codeInPngPath)){
              //controllo che fra le carte giocate ci sia qualcuna con png per il livello in corso
              cardCodeListFromPng.add(pngPath);
            }
          }
          //aggiungo png muri e tetto che non sono legati ad un cardCode,
          //dato che in ogni livello i png di default cambiano considera di inserire una string che identifichi i png di default in
          // ogni livello in modo da inserirli cercando quella stringa e non in modo esplicito


          //cardCodeListFromPng.add(png Muri);
          //cardcodeListFromPng.add(png Tetto);
          cardCodeListFromPng.sort((a, b) => gameModel.gameLogic.pngMapPerLevel[gameModel.playerLevelCounter]!.indexOf(a)
              .compareTo(gameModel.gameLogic.pngMapPerLevel[gameModel.playerLevelCounter]!.indexOf(b)));

          //sorto per essere sicuro che i png delle carte giocate vengano sovrapposti secondo l'ordine corretto (ordine in gameLogic)
          setState((){
            stackChildren = cardCodeListFromPng.map((e) => Image.asset(e, width: widget.imageWidth, height: widget.imageHeight)).toList();
          });
        }*/
      });

      return Stack(
        alignment: Alignment.center,
        children: stackChildren,
      );
    });
  }


}
