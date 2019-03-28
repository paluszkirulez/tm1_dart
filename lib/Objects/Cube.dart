import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Objects/Rule.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';

List<String> getCubes(){

}

class Cube extends TM1Object{
  final String _name;
  final List<Dimension> _dimensions;
  final Rule rules;

  Cube(this._name, this._dimensions, this.rules);

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