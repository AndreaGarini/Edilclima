

import 'package:collection/collection.dart';

class PngStackLogic {

  PngStackLogic();

  List<String> pngStack = [];

  Map<int, List<String>> initPngStackPerLevel = {
    1 : ['assets/gameBoardPng/Casa/MuriEsterno.png',
      'assets/gameBoardPng/Casa/MuriCappotto.png',
      'assets/gameBoardPng/Casa/MuriInterno.png',
      'assets/gameBoardPng/Casa/PavimentoBase.png',
      'assets/gameBoardPng/Casa/PavimentoRivestimento.png',
      'assets/gameBoardPng/Casa/LuciBase.png',
      'assets/gameBoardPng/Casa/CaldaiaBase.png',
      'assets/gameBoardPng/Casa/TettoBase.png',
      'assets/gameBoardPng/Casa/TettoRivestimentoBase.png',
      'assets/gameBoardPng/Casa/Tegole.png',
       ],
    2 : [],
    3 : [],
    4 : [],
  };


  Map<String, List<PngAction>> pngActionPerCard = {
    "inv01" : [PngAction("assets/gameBoardPng/Casa/MuriInterno.png", false),
      PngAction("assets/gameBoardPng/Casa/MuriCappotto.png", false),
      PngAction("assets/gameBoardPng/Casa/MuriCappottoBase.png", true),
      PngAction("assets/gameBoardPng/Casa/MuriInterno.png", true)],
    "inv02" : [PngAction("assets/gameBoardPng/Casa/MuriInterno.png", false),
      PngAction("assets/gameBoardPng/Casa/MuriCappotto.png", false),
      PngAction("assets/gameBoardPng/Casa/MuriCappottoEPS.png", true),
      PngAction("assets/gameBoardPng/Casa/MuriInterno.png", true)],
    "inv03" : [PngAction("assets/gameBoardPng/Casa/MuriInterno.png", false),
      PngAction("assets/gameBoardPng/Casa/MuriCappotto.png", false),
      PngAction("assets/gameBoardPng/Casa/MuriCappottoFibraLegno.png", true),
      PngAction("assets/gameBoardPng/Casa/MuriInterno.png", true)],
    "inv04" : [PngAction("assets/gameBoardPng/Casa/Tegole.png", false),
      PngAction("assets/gameBoardPng/Casa/TettoRivestimento.png", false),
      PngAction("assets/gameBoardPng/Casa/TettoRivestimentoBase.png", true),
      PngAction("assets/gameBoardPng/Casa/Tegole.png", true)],
    "inv05" : [PngAction("assets/gameBoardPng/Casa/Tegole.png", false),
      PngAction("assets/gameBoardPng/Casa/TettoRivestimento.png", false),
      PngAction("assets/gameBoardPng/Casa/TettoRivestimentoPoliuretano.png", true),
      PngAction("assets/gameBoardPng/Casa/Tegole.png", true)],
    "inv06" : [PngAction("assets/gameBoardPng/Casa/Tegole.png", false),
      PngAction("assets/gameBoardPng/Casa/TettoRivestimento.png", false),
      PngAction("assets/gameBoardPng/Casa/TettoRivestimentoFibraLegno.png", true),
      PngAction("assets/gameBoardPng/Casa/Tegole.png", true)],
    "inv07" : [PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", false),
      PngAction("assets/gameBoardPng/Casa/Finestra.png", false),
      PngAction("assets/gameBoardPng/Casa/FinestraBase.png", true),
      PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", true)],
    "inv08" : [PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", false),
      PngAction("assets/gameBoardPng/Casa/Finestra.png", false),
      PngAction("assets/gameBoardPng/Casa/FinestraLegno.png", true),
      PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", true)],
    "inv09" : [PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", false),
      PngAction("assets/gameBoardPng/Casa/Finestra.png", false),
      PngAction("assets/gameBoardPng/Casa/FinestraPVC2.png", true),
      PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", true)],
    "inv10" : [PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", false),
      PngAction("assets/gameBoardPng/Casa/Finestra.png", false),
      PngAction("assets/gameBoardPng/Casa/FinestraPVC3.png", true),
      PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", true)],
    "imp01" : [PngAction("assets/gameBoardPng/Casa/Termosifoni.png", true)],
    "imp02" : [PngAction("assets/gameBoardPng/Casa/PavimentoRivestimento.png", false),
      PngAction("assets/gameBoardPng/Casa/SondinePavimento.png", true),
      PngAction("assets/gameBoardPng/Casa/PavimentoRivestimento.png", true)],
    "imp03" : [PngAction("assets/gameBoardPng/Casa/Caldaia.png", false),
      PngAction("assets/gameBoardPng/Casa/CaldaiaBase.png", true)],
    "imp04" : [PngAction("assets/gameBoardPng/Casa/Caldaia.png", false),
      PngAction("assets/gameBoardPng/Casa/CaldaiaCondensazione.png", true)],
    "imp05" : [PngAction("assets/gameBoardPng/Casa/Caldaia.png", false),
      PngAction("assets/gameBoardPng/Casa/CaldaiaPellet.png", true)],
    "imp06" : [PngAction("assets/gameBoardPng/Casa/Caldaia.png", false),
      PngAction("assets/gameBoardPng/Casa/CaldaiaIbrido.png", true)],
    "imp07" : [PngAction("assets/gameBoardPng/Casa/PompaCalore.png", false),
      PngAction("assets/gameBoardPng/Casa/PompaCaloreBase.png", true)],
    "imp08" : [PngAction("assets/gameBoardPng/Casa/PompaCalore.png",false),
      PngAction("assets/gameBoardPng/Casa/PompaCaloreGeo.png", true)],
    "imp09" : [PngAction("assets/gameBoardPng/Casa/PannelloSolare.png", true)],
    "imp10" : [PngAction("assets/gameBoardPng/Casa/PannelloFotovoltaico.png", true)],
    "imp11" : [PngAction("assets/gameBoardPng/Casa/Accumulo.png", true)],
    "oth01" : [PngAction("assets/gameBoardPng/Casa/Luci.png", false),
      PngAction("assets/gameBoardPng/Casa/LuciBase.png", true)],
    "oth02" : [PngAction("assets/gameBoardPng/Casa/Luci.png", false),
      PngAction("assets/gameBoardPng/Casa/LuciNeon.png", true)],
    "oth03" : [PngAction("assets/gameBoardPng/Casa/Luci.png", false),
      PngAction("assets/gameBoardPng/Casa/LuciLed.png", true)],
    "oth04" : [PngAction("assets/gameBoardPng/Casa/VentMeccanica.png", true)],
    "oth05" : [PngAction("assets/gameBoardPng/Casa/Split.png", true)],
  };

  //todo: completare stack per ogni livello (metti anche le carte che non staranno mai assieme, tipo lampadine e neon)
  //todo: mettere le action giuste per ogni carta

  Map<int,List<String>> fullPngStackPerLevel = {
    1 : [
      'assets/gameBoardPng/Casa/MuriEsterno.png',
      'assets/gameBoardPng/Casa/MuriCappotto.png',
      'assets/gameBoardPng/Casa/MuriCappottoEPS.png',
      'assets/gameBoardPng/Casa/MuriCappottoFibraLegno.png',
      'assets/gameBoardPng/Casa/MuriInterno.png',
      'assets/gameBoardPng/Casa/PavimentoBase.png',
      'assets/gameBoardPng/Casa/SondinePavimento.png',
      'assets/gameBoardPng/Casa/PavimentoRivestimento.png',
      'assets/gameBoardPng/Casa/Split.png',
      'assets/gameBoardPng/Casa/LuciBase.png',
      'assets/gameBoardPng/Casa/LuciLED.png',
      'assets/gameBoardPng/Casa/LuciNeon.png',
      'assets/gameBoardPng/Casa/CaldaiaBase.png',
      'assets/gameBoardPng/Casa/CaldaiaCondensazione.png',
      'assets/gameBoardPng/Casa/CaldaiaPellet.png',
      'assets/gameBoardPng/Casa/CaldaiaIbrido.png',
      'assets/gameBoardPng/Casa/TettoBase.png',
      'assets/gameBoardPng/Casa/TettoRivestimentoBase.png',
      'assets/gameBoardPng/Casa/TettoRivestimentoPoliuretano.png',
      'assets/gameBoardPng/Casa/TettoRivestimentoFibraLegno.png',
      'assets/gameBoardPng/Casa/Tegole.png',
      'assets/gameBoardPng/Casa/PannelloFotovoltaico.png',
      'assets/gameBoardPng/Casa/PannelloSolare.png',
      'assets/gameBoardPng/Casa/FinestraVetri.png',
      'assets/gameBoardPng/Casa/FinestraVecchia.png',
      'assets/gameBoardPng/Casa/FinestraLegno.png',
      'assets/gameBoardPng/Casa/FinestraPVC2.png',
      'assets/gameBoardPng/Casa/FinestraPVC3.png',
      'assets/gameBoardPng/Casa/Accumulo.png',
      'assets/gameBoardPng/Casa/Termosifoni.png',
      'assets/gameBoardPng/Casa/PompaCaloreBase.png',
      'assets/gameBoardPng/Casa/VentMeccanica.png'],
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
            else if (pngStack.any((element) => element.contains(action.first()))){
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
          else if (pngStack.any((element) => element.contains(action.first()))){
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