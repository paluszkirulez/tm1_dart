import 'TM1Object.dart';
import 'Dimension.dart';
import 'Element.dart';
import 'Subset.dart';

class Hierarchy extends TM1Object {
  ///abstraction of hierarchy, consist of elements and keeps reference
  ///to its dimension
  final String classType = 'Hierarchy';
  final String name;
  final String dimension;
  List<String> elements;

  Hierarchy(this.dimension, {this.name});

  factory Hierarchy.fromJson(
      String dimension, Map<String, dynamic> parsedJson) {
    return new Hierarchy(dimension,
        name: parsedJson['Name']);
  }


  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimension\')/Hierarchies';
  }

  @override
  String body() {
    Map<String, dynamic> bodyMap = {
      '"Name"': '"$name"',
    };
    return bodyMap.toString();
  }
}
