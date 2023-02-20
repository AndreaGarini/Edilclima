

import 'package:collection/collection.dart';

class PngStackLogic {

  PngStackLogic();

  List<String> pngStack = [];

  Map<int, List<String>> initPngStackPerLevel = {
    1 : ['assets/gameBoardPng/MuriEsterno.png',
      'assets/gameBoardPng/MuriCappotto.png',
      'assets/gameBoardPng/MuriInterno.png',
      'assets/gameBoardPng/PavimentoBase.png',
      'assets/gameBoardPng/PavimentoRivestimento.png',
      'assets/gameBoardPng/Lampadina.png',
      'assets/gameBoardPng/Caldaia.png',
      'assets/gameBoardPng/TettoBase.png',
      'assets/gameBoardPng/TettoRivestimento.png',
      'assets/gameBoardPng/Tegole.png',
       ],
    2 : [],
    3 : [],
    4 : [],
  };


  Map<String, List<PngAction>> pngActionPerCard = {
    "inv01" : [PngAction("assets/gameBoardPng/MuriEsterno.png", false),
      PngAction("assets/gameBoardPng/MuriCappotto.png", false),
      PngAction("assets/gameBoardPng/MuriCappotto.png", true),
      PngAction("assets/gameBoardPng/MuriEsterno.png", true)],
    "inv02" : [PngAction("assets/gameBoardPng/MuriEsterno.png", false),
      PngAction("assets/gameBoardPng/MuriCappotto.png", false),
      PngAction("assets/gameBoardPng/MuriCappotto.png", true),
      PngAction("assets/gameBoardPng/MuriEsterno.png", true)],
    "inv03" : [PngAction("assets/gameBoardPng/MuriEsterno.png", false),
      PngAction("assets/gameBoardPng/MuriCappotto.png", false),
      PngAction("assets/gameBoardPng/MuriCappotto.png", true),
      PngAction("assets/gameBoardPng/MuriEsterno.png", true)],
    "inv04" : [PngAction("assets/gameBoardPng/Tegole.png", false),
      PngAction("assets/gameBoardPng/TettoRivestimento.png", false),
      PngAction("assets/gameBoardPng/TettoRivestimento.png", true),
      PngAction("assets/gameBoardPng/Tegole.png", true)],
    "inv05" : [PngAction("assets/gameBoardPng/Tegole.png", false),
      PngAction("assets/gameBoardPng/TettoRivestimento.png", false),
      PngAction("assets/gameBoardPng/TettoRivestimento.png", true),
      PngAction("assets/gameBoardPng/Tegole.png", true)],
    "inv06" : [PngAction("assets/gameBoardPng/Tegole.png", false),
      PngAction("assets/gameBoardPng/TettoRivestimento.png", false),
      PngAction("assets/gameBoardPng/TettoRivestimento.png", true),
      PngAction("assets/gameBoardPng/Tegole.png", true)],
    "inv07" : [PngAction("assets/gameBoardPng/FinestraVetri.png", false),
      PngAction("assets/gameBoardPng/Finestra.png", false),
      PngAction("assets/gameBoardPng/Finestra.png", true),
      PngAction("assets/gameBoardPng/FinestraVetri.png", true)],
    "inv08" : [PngAction("assets/gameBoardPng/FinestraVetri.png", false),
      PngAction("assets/gameBoardPng/Finestra.png", false),
      PngAction("assets/gameBoardPng/Finestra.png", true),
      PngAction("assets/gameBoardPng/FinestraVetri.png", true)],
    "inv09" : [PngAction("assets/gameBoardPng/FinestraVetri.png", false),
      PngAction("assets/gameBoardPng/Finestra.png", false),
      PngAction("assets/gameBoardPng/Finestra.png", true),
      PngAction("assets/gameBoardPng/FinestraVetri.png", true)],
    "inv10" : [PngAction("assets/gameBoardPng/FinestraVetri.png", false),
      PngAction("assets/gameBoardPng/Finestra.png", false),
      PngAction("assets/gameBoardPng/Finestra.png", true),
      PngAction("assets/gameBoardPng/FinestraVetri.png", true)],
    "imp01" : [PngAction("assets/gameBoardPng/Termosifoni.png", true)],
    "imp02" : [PngAction("assets/gameBoardPng/PavimentoRivestimento.png", false),
      PngAction("assets/gameBoardPng/SondinePavimento.png", true),
      PngAction("assets/gameBoardPng/PavimentoRivestimento.png", true)],
    "imp03" : [PngAction("assets/gameBoardPng/Caldaia.png", true)],
    "imp04" : [PngAction("assets/gameBoardPng/Caldaia.png", true)],
    "imp05" : [PngAction("assets/gameBoardPng/Caldaia.png", true)],
    "imp06" : [PngAction("assets/gameBoardPng/Caldaia.png", true)],
    "imp07" : [PngAction("assets/gameBoardPng/PompaCalore.png", true)],
    "imp08" : [PngAction("assets/gameBoardPng/PompaCalore.png", true)],
    "imp09" : [PngAction("assets/gameBoardPng/PannelliSolari.png", true)],
    "imp10" : [PngAction("assets/gameBoardPng/PannelliFotovoltaici.png", true)],
    "imp11" : [PngAction("assets/gameBoardPng/Accumulo.png", true)],
    "oth01" : [PngAction("assets/gameBoardPng/Lampadina.png", false),
      PngAction("assets/gameBoardPng/Lampadina.png", true)],
    "oth02" : [PngAction("assets/gameBoardPng/Lampadina.png", false),
      PngAction("assets/gameBoardPng/Lampadina.png", true)],
    "oth03" : [PngAction("assets/gameBoardPng/Lampadina.png", false),
      PngAction("assets/gameBoardPng/Lampadina.png", true)],
    "oth04" : [PngAction("assets/gameBoardPng/VentMeccanica.png", true)],
    "oth05" : [PngAction("assets/gameBoardPng/Split.png", true)],
  };

  //todo: completare stack per ogni livello (metti anche le carte che non staranno mai assieme, tipo lampadine e neon)
  //todo: mettere le action giuste per ogni carta

  Map<int,List<String>> fullPngStackPerLevel = {
    1 : [
      'assets/gameBoardPng/MuriEsterno.png',
      'assets/gameBoardPng/MuriCappotto.png',
      'assets/gameBoardPng/MuriCappottoEPS.png',
      'assets/gameBoardPng/MuriCappottoFibraLegno.png',
      'assets/gameBoardPng/MuriInterno.png',
      'assets/gameBoardPng/PavimentoBase.png',
      'assets/gameBoardPng/SondinePavimento.png',
      'assets/gameBoardPng/PavimentoRivestimento.png',
      'assets/gameBoardPng/Split.png',
      'assets/gameBoardPng/Lampadina.png',
      'assets/gameBoardPng/LuciLED.png',
      'assets/gameBoardPng/LuciNeon.png',
      'assets/gameBoardPng/Caldaia.png',
      'assets/gameBoardPng/CaldaiaCondensazione.png',
      'assets/gameBoardPng/CaldaiaPellet.png',
      'assets/gameBoardPng/CaldaiaIbrido.png',
      'assets/gameBoardPng/TettoBase.png',
      'assets/gameBoardPng/TettoRivestimento.png',
      'assets/gameBoardPng/TettoRivestimentoPoliuretano.png',
      'assets/gameBoardPng/TettoRivestimentoFibraLegno.png',
      'assets/gameBoardPng/Tegole.png',
      'assets/gameBoardPng/PannelloFotovoltaico.png',
      'assets/gameBoardPng/PannelloSolare.png',
      'assets/gameBoardPng/FinestraVetri.png',
      'assets/gameBoardPng/FinestraVecchia.png',
      'assets/gameBoardPng/FinestraLegno.png',
      'assets/gameBoardPng/FinestraPVC2.png',
      'assets/gameBoardPng/FinestraPVC3.png',
      'assets/gameBoardPng/Accumulo.png',
      'assets/gameBoardPng/Termosifoni.png',
      'assets/gameBoardPng/PompaCalore.png',
      'assets/gameBoardPng/VentMeccanica.png'],
    2 : [],
    3 : [],
    4 : [],
  };

  List<String> getCurrentPngStack(){
    return pngStack;
  }

  //todo: qui passare anche il context e creare lo sfondo in base al context
  List<String> setPngStackFromLevel(int level){
    pngStack = initPngStackPerLevel[level]!;
    return pngStack;
  }

  List<List<String>> getNewPngStack(String cardCode, bool isPlayed, int level){

    List<List<String>> finalPngStackList = [];

    if(isPlayed){
      //play card
      for (var action in pngActionPerCard[cardCode]!) {
        if(action.second()){
          List<String> newPngStack = fullPngStackPerLevel[level]!.
          where((element) => pngStack.contains(element) || element == action.first()).toList();
           newPngStack.sort((a, b) => fullPngStackPerLevel[level]!.indexOf(a).compareTo(fullPngStackPerLevel[level]!.indexOf(b)));
           pngStack = newPngStack;
          finalPngStackList.add(newPngStack);
        }
        else {
          //path generico per ogni elemento che sostituisce un altro non definito (es. cappotto), e poi controlli che il path sia presente in fullPngStackPerLevel,
          //se non è presente allora cerchi fra i png già presenti nel pngStack assets/gameBoardPng/pathGenerico (e non consideri cosa viene dopo il path generico) (es. cappotto vecchio)
            if(fullPngStackPerLevel[level]!.any((element) => element==action.first())){
              //not generic path
              pngStack.remove(action.first());
            }
            else{
              //generic path
              pngStack.remove(pngStack.where((element) => element.contains(action.first())).single);
            }
            List<String> newPngStack = pngStack.map((e) => e).toList();
            finalPngStackList.add(newPngStack);
        }
      }
    }
    //retrieve card
    else {
      for (var action in pngActionPerCard[cardCode]!.reversed){
        if(action.second()){
          if(fullPngStackPerLevel[level]!.any((element) => element==action.first())){
            //not generic path
            pngStack.remove(action.first());
          }
          else{
            //generic path
            pngStack.remove(pngStack.where((element) => element.contains(action.first())).single);
          }
          List<String> newPngStack = pngStack.map((e) => e).toList();
          finalPngStackList.add(newPngStack);
        }
        else {
          List<String> newPngStack = fullPngStackPerLevel[level]!.where((element) => pngStack.contains(element) || element == action.first()).toList();
          newPngStack.sort((a, b) => fullPngStackPerLevel[level]!.indexOf(a).compareTo(fullPngStackPerLevel[level]!.indexOf(b)));
          pngStack = newPngStack;
          finalPngStackList.add(newPngStack);
          }
      }
    }
    return finalPngStackList;
  }
}

class PngAction {
  String pngPath;
  bool add;
  PngAction(this.pngPath, this.add);

  String first(){
    return pngPath;
  }

  bool second(){
    return add;
  }
}