
import 'package:flutter/cupertino.dart';

class infoRow extends StatefulWidget{

  @override
  State<infoRow> createState() => infoRowState();

}

class infoRowState extends State<infoRow>{

  @override
  Widget build(BuildContext context) {
   return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center, children: [
               Text("madonna puttana")
     ],);
  }

}