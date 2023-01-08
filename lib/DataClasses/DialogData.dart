
import 'package:flutter/cupertino.dart';

class DialogData{
  String title;
  Widget? body;
  bool addButton;
  String? buttonText;
  Function? buttonCallback;
  DialogData(this.title, this.body, this.addButton, this.buttonText, this.buttonCallback);
}