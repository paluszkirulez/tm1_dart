import 'TM1Object.dart';
import 'Element.dart';
class Subset extends TM1Object{
  final String _name;
  final List<Element> _elements=[];
  final bool isDynamic = false;
  final String MDX = '';

  Subset(this._name);

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