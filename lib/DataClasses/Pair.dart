class Pair {
  Pair(this.left, this.right);

  final dynamic  left;
  final dynamic right;

  Object? second(){
    return right;
  }

  Object? first(){
    return left;
  }

  @override
  String toString() => 'Pair[$left, $right]';
}