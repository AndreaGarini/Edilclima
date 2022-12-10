
import 'package:flutter/cupertino.dart';

class RetriveCardScreen extends StatefulWidget{

  @override
  State<RetriveCardScreen> createState() => RetriveCardScreenState();

}

class RetriveCardScreenState extends State<RetriveCardScreen>{

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(child: Text("retrtive card screen"))
    ],);
  }
}