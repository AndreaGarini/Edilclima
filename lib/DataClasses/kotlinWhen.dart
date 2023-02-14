
class KotlinWhen{
  KotlinWhen(this.pairs, this.def);

  List<KotlinPair> pairs;
  Function() def;

  whenExeute() {
    if(pairs.map((e) => e.first()).where((element) => element).isNotEmpty){
      for (var element in pairs) {element.checkCondition();}
    }
    else{
      def();
    }
  }

}

class KotlinPair {
  KotlinPair(this.left, this.right);

  final bool  left;
  final Function() right;

  Function() second(){
    return right;
  }

  bool first(){
    return left;
  }

  void checkCondition(){
    if(left) {
      right.call();
    }
  }
}