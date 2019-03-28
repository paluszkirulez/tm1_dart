import 'TM1Object.dart';
import 'Dimension.dart';
import 'Element.dart';
import 'Subset.dart';
class Hierarchy extends TM1Object{
  ///abstraction of hierarchy, consist of elements and keeps reference
  ///to its dimension

  final String _name;
  final Dimension _dimension;
  final List<Element> _elements=[];
  final List<Subset> _subsets=[];

  Hierarchy(this._name, this._dimension);

  @override
  String createTM1Path() {
    // TODO: implement createTM1Path
    return null;
  }

  @override
  String body() {
    // TODO: implement body
    return null;
  }


}