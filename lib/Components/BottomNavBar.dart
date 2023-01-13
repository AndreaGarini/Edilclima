
import 'package:edilclima_app/Components/generalFeatures/ColorPalette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget{

  BuildContext parentContext;
  BottomNavBar(this.parentContext);

  @override
  State<BottomNavBar> createState() => BottomNavBarState(parentContext);

}

class BottomNavBarState extends  State<BottomNavBar>{

  BuildContext parentContext;
  BottomNavBarState(this.parentContext);

  var navItems = [
    BottomNavBarItem(
        icon: const Icon(Elusive.up_hand),
        label: "Gioca carta",
        route: "/cardSelectionScreen",
        color: darkBluePalette),
    BottomNavBarItem(
        icon: const Icon(Elusive.down_hand),
        label: "Prendi carta",
        route: "/retriveCardScreen",
        color: darkBluePalette),
    BottomNavBarItem(
        icon: const Icon(Icons.people),
        label: "Squadre",
        route: "/otherTeamsScreen",
        color: darkBluePalette),
  ];


  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(items: navItems,
        currentIndex: calculateSelectedIndex(context),
        onTap: (index) => onTapCallback(index),
        backgroundColor: darkBluePalette,
        unselectedItemColor: lightBluePalette,
        selectedItemColor: midColorPalette);
  }

  int calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;
    if (location.startsWith('/cardSelectionScreen')) {
      return 0;
    }
    if (location.startsWith('/retriveCardScreen')) {
      return 1;
    }
    if (location.startsWith('/otherTeamsScreen')) {
      return 2;
    }
    return 0;
  }

  onTapCallback (int index) {

       switch(index){
         case 0: context.go("/cardSelectionScreen");
          break;
         case 1: context.go("/retriveCardScreen");
         break;
         case 2: context.go("/otherTeamsScreen");
         break;
         default: context.go("/cardSelectionScreen");
         break;
       }
  }
}

class BottomNavBarItem extends BottomNavigationBarItem{


  BottomNavBarItem({required this.route, required String label, required Widget icon, required Color color})
   : super(icon: icon, label: label, backgroundColor: color);

  final String route;
}


