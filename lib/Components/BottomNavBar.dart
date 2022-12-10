
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget{

  @override
  State<BottomNavBar> createState() => BottomNavBarState();

}

class BottomNavBarState extends  State<BottomNavBar>{

  var navItems = [
    BottomNavBarItem(icon: Icon(Icons.home), label: "Gioca carta", route: "cardSelectionScreen"),
    BottomNavBarItem(icon: Icon(Icons.add_circle_outline), label: "Gioca carta", route: "retriveCardScreen"),
    BottomNavBarItem(icon: Icon(Icons.people), label: "Gioca carta", route: "otherTeamsScreen"),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(items: navItems,currentIndex: currentIndex, onTap: (index) => onTapCallback(index, context));

  }

  onTapCallback (int index, BuildContext context) {
     if(index != currentIndex){
       context.go(navItems[index].route);
       currentIndex = index;
     }
  }
}

class BottomNavBarItem extends BottomNavigationBarItem{


  BottomNavBarItem({required this.route, required String label, required Widget icon})
   : super(icon: icon, label: label);

  final String route;
}


