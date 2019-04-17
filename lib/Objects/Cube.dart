import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Objects/Rule.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';

class Cube extends TM1Object {
  final String name;
  List<String> dimensions;
  Rule rules;
  final String classType = 'Cubes';

  Cube(this.name, {this.dimensions, this.rules});

  factory Cube.fromJson(Map<String, dynamic> parsedJson) {
    return new Cube(parsedJson['Name'],
        rules: Rule.fromJson(parsedJson['Name'], parsedJson));
  }


  @override
  String createTM1Path() {
    return 'api/v1/Cubes';
  }

  @override
  String body() {
    // TODO: implement body
    return null;
  }
}
