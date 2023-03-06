

import 'package:collection/collection.dart';

class PngStackLogic {

  PngStackLogic();

  List<String> pngStack = [];

  List<String> playedCards = [];

  Map<int, List<String>> initPlayedCardsPerLevel = {
    1: [
      "inv01", "inv02", "imp03", "oth01"
    ],
    2: [],
    3: [],
    4: [],
  };

  Map<int, List<String>> initPngStackPerLevel = {
    1 : ['assets/gameBoardPng/Casa/MuriEsterno.png',
      'assets/gameBoardPng/Casa/MuriCappottoBase.png',
      'assets/gameBoardPng/Casa/MuriInterno.png',
      'assets/gameBoardPng/Casa/PavimentoBase.png',
      'assets/gameBoardPng/Casa/PavimentoRivestimento.png',
      'assets/gameBoardPng/Casa/LuciBase.png',
      'assets/gameBoardPng/Casa/CaldaiaBase.png',
      'assets/gameBoardPng/Casa/TettoBase.png',
      'assets/gameBoardPng/Casa/TettoRivestimentoBase.png',
      'assets/gameBoardPng/Casa/Tegole.png',
       ],
    2 : ['assets/gameBoardPng/Condominio/CMuriEsterno.png',
      'assets/gameBoardPng/Condominio/CMuriCappottoBase.png',
      'assets/gameBoardPng/Condominio/CMuriInterno.png',
      'assets/gameBoardPng/Condominio/CPavimentoBase.png',
      'assets/gameBoardPng/Condominio/CPavimentoRivestimento.png',
      'assets/gameBoardPng/Condominio/CLuciBase.png',
      'assets/gameBoardPng/Condominio/CCaldaiaBase.png',
      'assets/gameBoardPng/Condominio/CTettoBase.png',
      'assets/gameBoardPng/Condominio/CTettoRivestimentoBase.png',
       ],
    3 : [],
    4 : [],
  };


  Map<int, Map<String, List<PngAction>>> pngActionPerCardPerLevel = {
    1 :  {
      "inv01" : [PngAction("assets/gameBoardPng/Casa/MuriInterno.png", false),
        PngAction("assets/gameBoardPng/Casa/MuriCappotto", false),
        PngAction("assets/gameBoardPng/Casa/MuriCappottoBase.png", true),
        PngAction("assets/gameBoardPng/Casa/MuriInterno.png", true)],
      "inv02" : [PngAction("assets/gameBoardPng/Casa/MuriInterno.png", false),
        PngAction("assets/gameBoardPng/Casa/MuriCappotto", false),
        PngAction("assets/gameBoardPng/Casa/MuriCappottoEPS.png", true),
        PngAction("assets/gameBoardPng/Casa/MuriInterno.png", true)],
      "inv03" : [PngAction("assets/gameBoardPng/Casa/MuriInterno.png", false),
        PngAction("assets/gameBoardPng/Casa/MuriCappotto", false),
        PngAction("assets/gameBoardPng/Casa/MuriCappottoFibraLegno.png", true),
        PngAction("assets/gameBoardPng/Casa/MuriInterno.png", true)],
      "inv04" : [PngAction("assets/gameBoardPng/Casa/Tegole.png", false),
        PngAction("assets/gameBoardPng/Casa/TettoRivestimento", false),
        PngAction("assets/gameBoardPng/Casa/TettoRivestimentoBase.png", true),
        PngAction("assets/gameBoardPng/Casa/Tegole.png", true)],
      "inv05" : [PngAction("assets/gameBoardPng/Casa/Tegole.png", false),
        PngAction("assets/gameBoardPng/Casa/TettoRivestimento", false),
        PngAction("assets/gameBoardPng/Casa/TettoRivestimentoPoliuretano.png", true),
        PngAction("assets/gameBoardPng/Casa/Tegole.png", true)],
      "inv06" : [PngAction("assets/gameBoardPng/Casa/Tegole.png", false),
        PngAction("assets/gameBoardPng/Casa/TettoRivestimento", false),
        PngAction("assets/gameBoardPng/Casa/TettoRivestimentoFibraLegno.png", true),
        PngAction("assets/gameBoardPng/Casa/Tegole.png", true)],
      "inv07" : [PngAction("assets/gameBoardPng/Casa/FinestraBase.png", true),
        PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", true)],
      "inv08" : [PngAction("assets/gameBoardPng/Casa/FinestraLegno.png", true),
        PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", true)],
      "inv09" : [PngAction("assets/gameBoardPng/Casa/FinestraPVC2.png", true),
        PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", true)],
      "inv10" : [PngAction("assets/gameBoardPng/Casa/FinestraPVC3.png", true),
        PngAction("assets/gameBoardPng/Casa/FinestraVetri.png", true)],
      "imp01" : [PngAction("assets/gameBoardPng/Casa/Termosifoni.png", true)],
      "imp02" : [PngAction("assets/gameBoardPng/Casa/PavimentoRivestimento.png", false),
        PngAction("assets/gameBoardPng/Casa/SondinePavimento.png", true),
        PngAction("assets/gameBoardPng/Casa/PavimentoRivestimento.png", true)],
      "imp03" : [PngAction("assets/gameBoardPng/Casa/Caldaia", false),
        PngAction("assets/gameBoardPng/Casa/CaldaiaBase.png", true)],
      "imp04" : [PngAction("assets/gameBoardPng/Casa/Caldaia", false),
        PngAction("assets/gameBoardPng/Casa/CaldaiaCondensazione.png", true)],
      "imp05" : [PngAction("assets/gameBoardPng/Casa/Caldaia", false),
        PngAction("assets/gameBoardPng/Casa/CaldaiaPellet.png", true)],
      "imp06" : [PngAction("assets/gameBoardPng/Casa/Caldaia", false),
        PngAction("assets/gameBoardPng/Casa/CaldaiaIbrido.png", true)],
      "imp07" : [PngAction("assets/gameBoardPng/Casa/PompaCalore", false),
        PngAction("assets/gameBoardPng/Casa/PompaCaloreBase.png", true)],
      "imp08" : [PngAction("assets/gameBoardPng/Casa/PompaCalore",false),
        PngAction("assets/gameBoardPng/Casa/PompaCaloreGeo.png", true)],
      "imp09" : [PngAction("assets/gameBoardPng/Casa/PannelloSolare.png", true)],
      "imp10" : [PngAction("assets/gameBoardPng/Casa/PannelloFotovoltaico.png", true)],
      "imp11" : [PngAction("assets/gameBoardPng/Casa/Accumulo.png", true)],
      "oth01" : [PngAction("assets/gameBoardPng/Casa/Luci", false),
        PngAction("assets/gameBoardPng/Casa/LuciBase.png", true)],
      "oth02" : [PngAction("assets/gameBoardPng/Casa/Luci", false),
        PngAction("assets/gameBoardPng/Casa/LuciNeon.png", true)],
      "oth03" : [PngAction("assets/gameBoardPng/Casa/Luci", false),
        PngAction("assets/gameBoardPng/Casa/LuciLed.png", true)],
      "oth04" : [PngAction("assets/gameBoardPng/Casa/VentMeccanica.png", true)],
      "oth05" : [PngAction("assets/gameBoardPng/Casa/Split.png", true)],
    },
    2 :  {
      "inv01" : [PngAction("assets/gameBoardPng/Condominio/CMuriInterno.png", false),
        PngAction("assets/gameBoardPng/Condominio/CMuriCappotto", false),
        PngAction("assets/gameBoardPng/Condominio/CMuriCappottoBase.png", true),
        PngAction("assets/gameBoardPng/Condominio/CMuriInterno.png", true)],
      "inv02" : [PngAction("assets/gameBoardPng/Condominio/CMuriInterno.png", false),
        PngAction("assets/gameBoardPng/Condominio/CMuriCappotto", false),
        PngAction("assets/gameBoardPng/Condominio/CMuriCappottoEPS.png", true),
        PngAction("assets/gameBoardPng/Condominio/CMuriInterno.png", true)],
      "inv03" : [PngAction("assets/gameBoardPng/Condominio/CMuriInterno.png", false),
        PngAction("assets/gameBoardPng/Condominio/CMuriCappotto", false),
        PngAction("assets/gameBoardPng/Condominio/CMuriCappottoFibraLegno.png", true),
        PngAction("assets/gameBoardPng/Condominio/CMuriInterno.png", true)],
      "inv04" : [PngAction("assets/gameBoardPng/Condominio/CTettoRivestimento", false),
        PngAction("assets/gameBoardPng/Condominio/CTettoRivestimentoBase.png", true)],
      "inv05" : [PngAction("assets/gameBoardPng/Condominio/CTettoRivestimento", false),
        PngAction("assets/gameBoardPng/Condominio/CTettoRivestimentoPoliuretano.png", true)],
      "inv06" : [PngAction("assets/gameBoardPng/Condominio/CTettoRivestimento", false),
        PngAction("assets/gameBoardPng/Condominio/CTettoRivestimentoFibraLegno.png", true)],
      "inv07" : [PngAction("assets/gameBoardPng/Condominio/CFinestraBase.png", true),
        PngAction("assets/gameBoardPng/Condominio/CFinestraVetri.png", true)],
      "inv08" : [PngAction("assets/gameBoardPng/Condominio/CFinestraLegno.png", true),
        PngAction("assets/gameBoardPng/Condominio/CFinestraVetri.png", true)],
      "inv09" : [PngAction("assets/gameBoardPng/Condominio/CFinestraPVC2.png", true),
        PngAction("assets/gameBoardPng/Condominio/CFinestraVetri.png", true)],
      "inv10" : [PngAction("assets/gameBoardPng/Condominio/CFinestraPVC3.png", true),
        PngAction("assets/gameBoardPng/Condominio/CFinestraVetri.png", true)],
      "imp01" : [PngAction("assets/gameBoardPng/Condominio/CTermosifoni.png", true)],
      "imp02" : [PngAction("assets/gameBoardPng/Condominio/CPavimentoRivestimento.png", false),
        PngAction("assets/gameBoardPng/Condominio/CSondinePavimento.png", true),
        PngAction("assets/gameBoardPng/Condominio/CPavimentoRivestimento.png", true)],
      "imp03" : [PngAction("assets/gameBoardPng/Condominio/CCaldaia", false),
        PngAction("assets/gameBoardPng/Condominio/CCaldaiaBase.png", true)],
      "imp04" : [PngAction("assets/gameBoardPng/Condominio/CCaldaia", false),
        PngAction("assets/gameBoardPng/Condominio/CCaldaiaCondensazione.png", true)],
      "imp05" : [PngAction("assets/gameBoardPng/Condominio/CCaldaia", false),
        PngAction("assets/gameBoardPng/Condominio/CCaldaiaPellet.png", true)],
      "imp06" : [PngAction("assets/gameBoardPng/Condominio/CCaldaia", false),
        PngAction("assets/gameBoardPng/Condominio/CCaldaiaIbrido.png", true)],
      "imp07" : [PngAction("assets/gameBoardPng/Condominio/CPompaCalore", false),
        PngAction("assets/gameBoardPng/Condominio/CPompaCaloreBase.png", true)],
      "imp08" : [PngAction("assets/gameBoardPng/Condominio/CPompaCalore",false),
        PngAction("assets/gameBoardPng/Condominio/CPompaCaloreGeo.png", true)],
      "imp09" : [PngAction("assets/gameBoardPng/Condominio/CPannelloSolare.png", true)],
      "imp10" : [PngAction("assets/gameBoardPng/Condominio/CPannelloFotovoltaico.png", true)],
      "imp11" : [PngAction("assets/gameBoardPng/Condominio/CAccumulo.png", true)],
      "oth01" : [PngAction("assets/gameBoardPng/Condominio/CLuci", false),
        PngAction("assets/gameBoardPng/Condominio/CLuciBase.png", true)],
      "oth02" : [PngAction("assets/gameBoardPng/Condominio/CLuci", false),
        PngAction("assets/gameBoardPng/Condominio/CLuciNeon.png", true)],
      "oth03" : [PngAction("assets/gameBoardPng/Condominio/CLuci", false),
        PngAction("assets/gameBoardPng/Condominio/CLuciLed.png", true)],
      "oth04" : [PngAction("assets/gameBoardPng/Condominio/CVentMeccanica.png", true)],
      "oth05" : [PngAction("assets/gameBoardPng/Condominio/CSplit.png", true)],
    },
    3:  {},
    4 : {},
  };

  //todo: completare stack per ogni livello (metti anche le carte che non staranno mai assieme, tipo lampadine e neon)
  //todo: mettere le action giuste per ogni carta

  Map<int,List<String>> fullPngStackPerLevel = {
    1 : [
      'assets/gameBoardPng/Casa/MuriEsterno.png',
      'assets/gameBoardPng/Casa/MuriCappottoBase.png',
      'assets/gameBoardPng/Casa/MuriCappottoEPS.png',
      'assets/gameBoardPng/Casa/MuriCappottoFibraLegno.png',
      'assets/gameBoardPng/Casa/MuriInterno.png',
      'assets/gameBoardPng/Casa/PavimentoBase.png',
      'assets/gameBoardPng/Casa/SondinePavimento.png',
      'assets/gameBoardPng/Casa/PavimentoRivestimento.png',
      'assets/gameBoardPng/Casa/Split.png',
      'assets/gameBoardPng/Casa/LuciBase.png',
      'assets/gameBoardPng/Casa/LuciLed.png',
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
      'assets/gameBoardPng/Casa/FinestraBase.png',
      'assets/gameBoardPng/Casa/FinestraLegno.png',
      'assets/gameBoardPng/Casa/FinestraPVC2.png',
      'assets/gameBoardPng/Casa/FinestraPVC3.png',
      'assets/gameBoardPng/Casa/Accumulo.png',
      'assets/gameBoardPng/Casa/Termosifoni.png',
      'assets/gameBoardPng/Casa/PompaCaloreBase.png',
      'assets/gameBoardPng/Casa/PompaCaloreGeo.png',
      'assets/gameBoardPng/Casa/VentMeccanica.png'],
    2 : ['assets/gameBoardPng/Condominio/CMuriEsterno.png',
      'assets/gameBoardPng/Condominio/CMuriCappottoBase.png',
      'assets/gameBoardPng/Condominio/CMuriCappottoEPS.png',
      'assets/gameBoardPng/Condominio/CMuriCappottoFibraLegno.png',
      'assets/gameBoardPng/Condominio/CMuriInterno.png',
      'assets/gameBoardPng/Condominio/CPavimentoBase.png',
      'assets/gameBoardPng/Condominio/CSondinePavimento.png',
      'assets/gameBoardPng/Condominio/CPavimentoRivestimento.png',
      'assets/gameBoardPng/Condominio/CSplit.png',
      'assets/gameBoardPng/Condominio/CLuciBase.png',
      'assets/gameBoardPng/Condominio/CLuciLed.png',
      'assets/gameBoardPng/Condominio/CLuciNeon.png',
      'assets/gameBoardPng/Condominio/CCaldaiaBase.png',
      'assets/gameBoardPng/Condominio/CCaldaiaCondensazione.png',
      'assets/gameBoardPng/Condominio/CCaldaiaPellet.png',
      'assets/gameBoardPng/Condominio/CCaldaiaIbrido.png',
      'assets/gameBoardPng/Condominio/CTettoBase.png',
      'assets/gameBoardPng/Condominio/CTettoRivestimentoBase.png',
      'assets/gameBoardPng/Condominio/CTettoRivestimentoPoliuretano.png',
      'assets/gameBoardPng/Condominio/CTettoRivestimentoFibraLegno.png',
      'assets/gameBoardPng/Condominio/CPannelloFotovoltaico.png',
      'assets/gameBoardPng/Condominio/CPannelloSolare.png',
      'assets/gameBoardPng/Condominio/CFinestraVetri.png',
      'assets/gameBoardPng/Condominio/CFinestraBase.png',
      'assets/gameBoardPng/Condominio/CFinestraLegno.png',
      'assets/gameBoardPng/Condominio/CFinestraPVC2.png',
      'assets/gameBoardPng/Condominio/CFinestraPVC3.png',
      'assets/gameBoardPng/Condominio/CAccumulo.png',
      'assets/gameBoardPng/Condominio/CTermosifoni.png',
      'assets/gameBoardPng/Condominio/CPompaCaloreBase.png',
      'assets/gameBoardPng/Condominio/CPompaCaloreGeo.png',
      'assets/gameBoardPng/Condominio/CVentMeccanica.png'],
    3 : [],
    4 : [],
  };

  List<String> getCurrentPngStack(){
    return pngStack;
  }

  //todo: qui passare anche il context e creare lo sfondo in base al context
  List<String> setPngStackFromLevel(int level){
    pngStack = initPngStackPerLevel[level]!;
    playedCards = initPlayedCardsPerLevel[level]!;
    return pngStack;
  }

  List<List<String>> getNewPngStack(String cardCode, bool isPlayed, int level){

    List<List<String>> finalPngStackList = [];

    if(isPlayed && !playedCards.contains(cardCode)){
      //play card
      playedCards.add(cardCode);
    }
    else {
      //retrieve card
      playedCards.remove(cardCode);
    }

    List<String> onlyAddPngStack = [];
    for (String card in playedCards){
      for(PngAction action in pngActionPerCardPerLevel[level]![card]!){
        if(action.second()){
          onlyAddPngStack.add(action.first());
        }
      }
      for (String startingPng in initPngStackPerLevel[level]!){
        if(!onlyAddPngStack.contains(startingPng)){
          onlyAddPngStack.add(startingPng);
        }
      }
    }


    if(isPlayed){
      //play card
      for (var action in pngActionPerCardPerLevel[level]![cardCode]!) {
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
      for (var action in pngActionPerCardPerLevel[level]![cardCode]!.reversed){
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
            List<String> newPngStack = fullPngStackPerLevel[level]!.where((element) => pngStack.contains(element)).toList();
            bool genericPath = !fullPngStackPerLevel[level]!.any((png) => png == action.first());
            bool hasSubstitute = onlyAddPngStack.any((png) => png.contains(action.first()));

            if(genericPath && hasSubstitute){
              List<String> substitutePng = onlyAddPngStack.where((png) => png.contains(action.first())).toList();
              substitutePng.sort((a, b) => fullPngStackPerLevel[level]!.indexOf(a).compareTo(fullPngStackPerLevel[level]!.indexOf(b)));
              newPngStack.add(substitutePng.last);
            }
            else if (!genericPath){
              newPngStack.add(action.first());
            }
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