
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    BottomNavBarItem(icon: Icon(Icons.home), label: "Gioca carta", route: "/cardSelectionScreen"),
    BottomNavBarItem(icon: Icon(Icons.add_circle_outline), label: "Prendi carta", route: "/retriveCardScreen"),
    BottomNavBarItem(icon: Icon(Icons.people), label: "Squadre", route: "/otherTeamsScreen"),
  ];


  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(items: navItems,currentIndex: calculateSelectedIndex(context), onTap: (index) => onTapCallback(index));

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


  BottomNavBarItem({required this.route, required String label, required Widget icon})
   : super(icon: icon, label: label);

  final String route;
}


