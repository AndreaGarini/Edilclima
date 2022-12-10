
import 'package:flutter/cupertino.dart';

class OtherTeamsScreen extends StatefulWidget{


  @override
  State<OtherTeamsScreen> createState() => OtherTeamsScreenState();

}

class OtherTeamsScreenState extends State<OtherTeamsScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text("other teams screen"))
      ],);
  }

}