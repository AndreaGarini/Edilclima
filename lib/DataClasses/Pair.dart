class Pair {
  Pair(this.left, this.right);

  final dynamic  left;
  final dynamic right;

  String second(){
    return right;
  }

  String first(){
    return left;
  }

  @override
  String toString() => 'Pair[$left, $right]';
}